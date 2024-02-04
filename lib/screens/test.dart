import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  String answer = 'asd';

  Future<void> sendPromptToServer(String prompt) async {
    try {
      // Define the endpoint URL
      const String url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBdUzwBDPozaAmnw8P6uku2QlkoVeXCpWA';

      // Make the POST request
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
            {
              "contents": [
                {
                  "parts": [
                    {"text": prompt}
                  ]
                }
              ]
            },
          ));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        debugPrint('Prompt sent successfully');
        setState(() {
          var body = jsonDecode(response.body);
          answer = body['candidates'][0]['content']['parts'][0]['text'];
          ;
        });
      } else {
        debugPrint(
            'Failed to send prompt. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sending prompt: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(answer),
            ElevatedButton(
              onPressed: () {
                sendPromptToServer('What is the Capital of Canada?');
              },
              child: Text('answer'),
            ),
          ],
        ),
      ),
    );
  }
}
