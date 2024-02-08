import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hushh_proto/models/message_model.dart';
import 'package:hushh_proto/screens/github_auth.dart';
import 'package:hushh_proto/screens/widgets/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hushh_proto/screens/widgets/snackbars.dart';
import 'package:hushh_proto/screens/widgets/transitions.dart';

bool lightMode = false;

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.username,
    required this.name,
    required this.currentPos,
    required this.targetPos,
  });
  final String username;
  final String name;
  final String currentPos;
  final String targetPos;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Chat chat = Chat();

  //Controllers
  TextEditingController chatController = TextEditingController();
  ScrollController chatScrollController = ScrollController();

  //Variables
  bool loading = true;
  bool fetchingContent = true;
  String stats = '';

  //github
  List repoContent = [];
  Map<String, int> languageStats = {};
  Map<String, int> languagePercentStats = {};

  //Chat
  List<Message> chatList = [];

  fetchRepoContent() async {
    final String baseUrl =
        'https://api.github.com/users/${widget.username}/repos';
    try {
      List<dynamic> allRepos = [];
      var response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': "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",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> repos = json.decode(response.body);

        allRepos.addAll(repos);

        // Check for pagination headers
        while (response.headers.containsKey('link') &&
            response.headers['link']!.contains('rel="next"')) {
          // Extract the URL for the next page
          var nextUrl = response.headers['link']!
              .split(',')
              .firstWhere((link) => link.contains('rel="next"'))
              .split(';')
              .first
              .trim()
              .replaceAll('<', '')
              .replaceAll('>', '');

          // Fetch the next page of repositories
          response = await http.get(
            Uri.parse(nextUrl),
            headers: {
              'Authorization': "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",
            },
          );
          repos = json.decode(response.body);
          allRepos.addAll(repos);
        }

        setState(() {
          repoContent = allRepos;
          calculatePercent(repoContent);
        });
      } else if (response.statusCode == 400) {
        errorSnackbar(context, 'Bad Request');
      } else {
        errorSnackbar(context, 'Failed to fetch repo information');
        Navigator.pop(context);
      }
    } catch (e) {
      errorSnackbar(context, 'error: $e');
    }
    setState(() {
      fetchingContent = false;
    });
  }

  calculatePercent(List repos) {
    for (Map repo in repos) {
      var language = repo['language'];
      if (language != null) {
        if (languageStats.containsKey(language)) {
          languageStats[language] = languageStats[language]! + 1;
        } else {
          languageStats[language] = 1;
        }
      }
    }
    int sum = languageStats.values.fold(0, (prev, element) => prev + element);

    languageStats.forEach((key, value) {
      int percent = (value / sum * 100).round();
      languagePercentStats[key] = percent;
    });

    setState(() {
      languagePercentStats.forEach((key, value) {
        stats = '$stats\n$key: $value%';
      });
      chatList.add(
        Message(
          sender: 'model',
          content:
              'Hi ${widget.name},\nYour current position is ${widget.currentPos} and you want to become ${widget.targetPos}',
        ),
      );

      chatList.add(
        Message(
          sender: 'model',
          content: 'Here is the breakdown of your Github profile.\n$stats',
        ),
      );

      chatList.add(
        Message(
          sender: 'user',
          content:
              'Based on my current profile and my goal, what are the top 3 best options for me?',
        ),
      );
    });
  }

  //function
  Future<void> geminiAPI(String prompt) async {
    List contents = [
      {
        "role": "user",
        "parts": [
          {
            "text":
                "Hey Gemini, I want to make some advancements in my career and I need your help to get me there. I need answers that are on point and dont give too long answers, short and medium size answers are appreciated."
          }
        ]
      },
      {
        "role": "model",
        "parts": [
          {
            "text":
                "Sure, I will answer your questions in short and consize way."
          }
        ]
      },
      {
        "role": "user",
        "parts": [
          {
            "text":
                'I am giving you an example on how I want the answers to be.\nExample:\nSuppose if I ask you that my current portfolio contains Flutter and I want to become a full stack engineer so your answer should be in this format\n"These are the best languages for you to become a full-stack engineer: *languages*\n *50 word description on why you suggested that specific language*"'
          }
        ]
      },
      {
        "role": "model",
        "parts": [
          {"text": "Okay I have noted the format of answers"}
        ]
      },
      {
        "role": "user",
        "parts": [
          {
            "text":
                'Later on I will also ask you to give me step by step guide and I want you to answer in this format only:\n"For you to become *starting position* to *target position* you can follow these steps:\nStep 1-2: *Brief summary on the languages he can learn and how he can start learning those languages*, Step 3-4: *In detail information on different types of learning techniques he can adapt such as project base learning, buying a course etc*, Step 4-5:*Steps on how he can engage with the people in that community such as open source contribution etc.*\n Keep a note to list down each step saperately and not to combine 1 and 2, 3 and 4 etc"'
          }
        ]
      },
      {
        "role": "model",
        "parts": [
          {
            "text":
                "Okay I have noted the format for step-wise guide that might be asked later"
          }
        ]
      },
      {
        "role": "user",
        "parts": [
          {"text": "Here is the breakdown of my Github profile.\n$stats"}
        ]
      },
      {
        "role": "model",
        "parts": [
          {"text": "Okay I have noted your github profile breakdown"}
        ]
      },
      {
        "role": "user",
        "parts": [
          {
            "text":
                "I am currenty working as ${widget.currentPos} and I want to become ${widget.targetPos}"
          }
        ]
      },
      {
        "role": "model",
        "parts": [
          {
            "text":
                "Okay. I have noted your current position and your end goal."
          }
        ]
      },
      {
        "role": "user",
        "parts": [
          {"text": prompt}
        ]
      }
    ];
    try {
      // Define the endpoint URL
      const String url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBdUzwBDPozaAmnw8P6uku2QlkoVeXCpWA';

      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "contents": contents,
            "generationConfig": {
              "temperature": 0.6,
              "topK": 1,
              "topP": 1,
              "maxOutputTokens": 1024,
              "stopSequences": []
            },
            "safetySettings": [
              {
                "category": "HARM_CATEGORY_HARASSMENT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              },
              {
                "category": "HARM_CATEGORY_HATE_SPEECH",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              },
              {
                "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              },
              {
                "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              }
            ]
          },
        ),
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        debugPrint('Prompt sent successfully');
        setState(() {
          var body = jsonDecode(response.body);

          chatList.add(
            Message(
              sender: 'model',
              content: body['candidates'][0]['content']['parts'][0]['text'],
            ),
          );

          //adding in the chat history for knowledge persistence
          contents.add({
            "role": "user",
            "parts": [
              {"text": prompt}
            ]
          });
          contents.add({
            "role": "model",
            "parts": [
              {"text": body['candidates'][0]['content']['parts'][0]['text']}
            ]
          });
        });
      } else {
        errorSnackbar(context, 'Something went wrong.');
      }
    } catch (e) {
      debugPrint('Error sending prompt: $e');
    }
    setState(() {
      loading = false;
    });
    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
    );
  }

  @override
  void initState() {
    fetchingContent = true;
    fetchRepoContent();
    geminiAPI(
        'Now I want you observe my github profile in depth before answering my question. Question: Based on my current profile and my goal, what are the top 3 best options for me? Just answer me in this format "These are the best lanauges for you are: *name of languages*. If there any languages in my profile that already align with certian domain of becomming a ${widget.targetPos} then dont suggest some other languages. Also I need a very short and simple answer just like the example I gave you earlier');
    super.initState();
  }

  @override
  void dispose() {
    fetchingContent = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formatText(String input) {
      String formattedText = input.replaceAll("**", "");

      return formattedText;
    }

    return Scaffold(
      backgroundColor: lightMode ? Pallet.white : Pallet.black,
      appBar: fetchingContent
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: lightMode ? Pallet.white : Pallet.black,
              title: Text(
                "Zeus",
                style: TextStyle(
                  color: lightMode ? Pallet.black : Pallet.white,
                ),
              ),
              actions: <Widget>[
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: lightMode ? Pallet.black : Pallet.white,
                  ), // Three dots icon
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/github.svg',
                            height: 20,
                          ),
                          SizedBox(width: 5),
                          Text('Change Github Info'),
                        ],
                      ),
                      onTap: () {
                        rightSlideTransition(
                          context,
                          const GithubAuth(),
                        );
                      },
                    ),
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(
                            Icons.refresh,
                            color: Pallet.red,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Reset chat',
                            style: TextStyle(color: Pallet.red),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          chatList.clear();
                        });
                      },
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            lightMode ? Icons.dark_mode : Icons.light_mode,
                            color: Pallet.black,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            lightMode ? 'Dark Mode' : 'Light Mode',
                            style: const TextStyle(color: Pallet.black),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          lightMode = !lightMode;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
      body: fetchingContent
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Pallet.blue,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Fetching your Data',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Pallet.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                //Chat internface
                const SizedBox(height: 20),
                Expanded(
                  child: chatList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
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
                            ],
                          ),
                        )
                      : RawScrollbar(
                          thickness: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          controller: chatScrollController,
                          child: ListView.builder(
                            controller: chatScrollController,
                            itemCount: chatList.length,
                            itemBuilder: (context, index) {
                              Message msg = chatList[index];
                              bool owner = msg.sender == 'user' ? true : false;
                              String message = formatText(msg.content);

                              return Wrap(
                                alignment: owner
                                    ? WrapAlignment.end
                                    : WrapAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                      owner ? 50 : 10,
                                      5,
                                      owner ? 10 : 50,
                                      5,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: lightMode
                                          ? Pallet.blue
                                          : Pallet.white,
                                    ),
                                    child: Text(
                                      message,
                                      softWrap: true,
                                      // maxLines: null,
                                      style: TextStyle(
                                        color: lightMode
                                            ? Pallet.white
                                            : Pallet.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                ),

                //Chat Box
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: lightMode
                                ? Pallet.black.withOpacity(0.2)
                                : Pallet.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            controller: chatController,
                            cursorColor:
                                lightMode ? Pallet.black : Pallet.white,
                            style: TextStyle(
                              color: lightMode ? Pallet.black : Pallet.white,
                            ),
                            maxLines: null,
                            cursorRadius: const Radius.circular(100),
                            cursorOpacityAnimates: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Message',
                              hintStyle: TextStyle(
                                color: lightMode
                                    ? Pallet.black.withOpacity(0.5)
                                    : Pallet.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 45,
                        width: 45,
                        child: IconButton.filledTonal(
                          color: Colors.white,
                          style: IconButton.styleFrom(
                              backgroundColor:
                                  lightMode ? Pallet.black : Pallet.white),
                          onPressed: () {
                            if (chatController.text.trim().isNotEmpty &&
                                !loading) {
                              setState(() {
                                chatList.add(
                                  Message(
                                    sender: 'user',
                                    content: chatController.text.trim(),
                                  ),
                                );
                                loading = true;
                              });

                              geminiAPI(chatController.text.trim());
                              chatController.clear();
                            }
                          },
                          icon: loading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Icon(
                                  Icons.arrow_upward_rounded,
                                  color:
                                      lightMode ? Pallet.white : Pallet.black,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
