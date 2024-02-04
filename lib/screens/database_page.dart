import 'package:flutter/material.dart';
import 'package:hushh_proto/screens/home.dart';
import 'package:hushh_proto/screens/widgets/button.dart';
import 'package:hushh_proto/screens/widgets/colors.dart';
import 'package:hushh_proto/screens/widgets/dataset.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  bool coolText = false;
  //Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  //Lists
  List dailyWear = [];
  List formalsWear = [];
  List partyWear = [];

  //Variables
  String userGender = gender[0];

  fetchData() {
    _nameController.text = database['name'];
    _ageController.text = database['age'];
    dailyWear = database['daily'];
    formalsWear = database['formals'];
    partyWear = database['party'];
    userGender = database['gender'];
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightMode ? Pallet.white : Pallet.black,
      appBar: AppBar(
        backgroundColor: lightMode ? Pallet.white : Pallet.black,
        iconTheme: IconThemeData(
          color: lightMode ? Pallet.black : Pallet.white,
        ),
        title: Text(
          'Database',
          style: TextStyle(
            color: lightMode ? Pallet.black : Pallet.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                color: Pallet.white,
                child: Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            coolText = !coolText;
                          });
                        },
                        child: Text(
                          'Tap here if you are cool',
                          style: TextStyle(
                            color: Pallet.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    //Cool Text
                    Visibility(
                      visible: coolText,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'I am Aaditya Jagdale, the creator of Zeus. I present you this app as an application for a flutter dev intern at your company Hushh.ai',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Pallet.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'I am proposing you a deal',
                              style: TextStyle(
                                color: Pallet.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "assets/meme.png",
                                height: 200,
                                width: 200,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'What do you think? I am pretty good at what I do 😎\nI mean someone had to work on 2 live projects and 3 internships to be able to apply at Hushh',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Pallet.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'I have relevant links below. Do visit my profile to see more cool stuff',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Pallet.black,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                socialButton(
                                    'assets/linkedin.svg',
                                    'LinkedIn',
                                    () => launchUrl(Uri.parse(
                                        'https://www.linkedin.com/in/aaditya-jagdale/'))),
                                const SizedBox(width: 10),
                                socialButton(
                                  'assets/github.svg',
                                  'Github',
                                  () => launchUrlString(
                                      'https://github.com/Contro1-cs'),
                                ),
                                const SizedBox(width: 10),
                                socialButton(
                                    'assets/twitter.svg',
                                    'X',
                                    () => launchUrlString(
                                        'https://twitter.com/Pxa_cheesecake')),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Dataset Information',
                  style: TextStyle(
                    color: Pallet.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'For simplicity the dataset used in this version of app is static. However, the data can be easily fetched from backend but I dont want to complicate stuff.',
                    style: TextStyle(
                      color: Pallet.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'The data that is used in this app is: ',
                    style: TextStyle(
                      color: Pallet.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Daily wear: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Pallet.white,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: dailyWear.length,
                    itemBuilder: (context, index) {
                      return Text(
                        '  -   ${dailyWear[index]}',
                        style: TextStyle(
                          color: Pallet.white,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Party wear: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Pallet.white,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: dailyWear.length,
                    itemBuilder: (context, index) {
                      return Text(
                        '  -   ${partyWear[index]}',
                        style: TextStyle(
                          color: Pallet.white,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Formal wear: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Pallet.white,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: formalsWear.length,
                    itemBuilder: (context, index) {
                      return Text(
                        '  -   ${dailyWear[index]}',
                        style: TextStyle(
                          color: Pallet.white,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
