import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hushh_proto/screens/home.dart';
import 'package:hushh_proto/screens/widgets/colors.dart';
import 'package:hushh_proto/screens/widgets/snackbars.dart';
import 'package:hushh_proto/screens/widgets/textfield.dart';
import 'package:http/http.dart' as http;
import 'package:hushh_proto/screens/widgets/transitions.dart';

class GithubAuth extends StatefulWidget {
  const GithubAuth({super.key});

  @override
  State<GithubAuth> createState() => _GithubAuthState();
}

class _GithubAuthState extends State<GithubAuth> {
  //Controllers
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _currentPosition = TextEditingController();
  TextEditingController _targetPosition = TextEditingController();
  //functions
  Future<void> githubAPI(String username) async {
    final String baseUrl = 'https://api.github.com/users/$username';

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': "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",
        },
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        Map<String, dynamic> userData = json.decode(response.body);
        int repoCount = userData['public_repos'];
        String name = userData['name'];
        successSnackbar(context, 'Found $repoCount repos');
        rightSlideTransition(
          context,
          HomePage(
            username: username,
            name: name,
            currentPos: _currentPosition.text.trim(),
            targetPos: _targetPosition.text.trim(),
          ),
        );
      } else if (response.statusCode == 403 || response.statusCode == 429) {
        errorSnackbar(
            context, 'We are facing a lot of traffic. Please try again later');
      } else {
        errorSnackbar(context, '$username not valid');
      }
    } catch (e) {
      errorSnackbar(context, 'error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallet.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            lightMode
                ? SvgPicture.asset("assets/zeus_dark.svg")
                : SvgPicture.asset("assets/zeus.svg"),
            const SizedBox(height: 20),
            Text(
              'Personalized Growth\nCoach',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Pallet.white,
                fontWeight: FontWeight.normal,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    customTextField(
                      context,
                      'Github Username',
                      _usernameController,
                      lightMode ? Pallet.black : Pallet.white,
                    ),
                    const SizedBox(height: 20),
                    customTextField(
                      context,
                      'Current Position',
                      _currentPosition,
                      lightMode ? Pallet.black : Pallet.white,
                    ),
                    const SizedBox(height: 20),
                    customTextField(
                      context,
                      'Target Position',
                      _targetPosition,
                      lightMode ? Pallet.black : Pallet.white,
                    ),
                  ],
                )),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: lightMode ? Pallet.black : Pallet.white,
                ),
                onPressed: () {
                  if (_usernameController.text.trim().isEmpty) {
                    errorSnackbar(context, 'Please enter your Github Username');
                  } else {
                    githubAPI(_usernameController.text.trim());
                  }
                },
                child: Text(
                  'Get Started',
                  style:
                      TextStyle(color: lightMode ? Pallet.white : Pallet.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
