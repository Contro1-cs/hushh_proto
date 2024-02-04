import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hushh_proto/models/message_model.dart';
import 'package:hushh_proto/screens/database_page.dart';
import 'package:hushh_proto/screens/widgets/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hushh_proto/screens/widgets/dataset.dart';
import 'package:hushh_proto/screens/widgets/snackbars.dart';
import 'package:hushh_proto/screens/widgets/transitions.dart';

bool lightMode = false;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Chat chat = Chat();

  //Controllers
  TextEditingController chatController = TextEditingController();
  ScrollController chatScrollController = ScrollController();

  //Variables
  bool loading = false;
  String age = '';
  String userGender = '';
  List dailyWear = [];
  List formalsWear = [];
  List partyWear = [];

  //Chat
  List<Message> chatList = [];

  fetchData() {
    age = database['age'];
    userGender = database['gender'];
    dailyWear = database['daily'];
    formalsWear = database['formals'];
    partyWear = database['party'];
  }

  @override
  Widget build(BuildContext context) {
    Future<void> geminiAPI(String prompt) async {
      try {
        // Define the endpoint URL
        const String url =
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBdUzwBDPozaAmnw8P6uku2QlkoVeXCpWA';

        // Make the POST request
        final response = await http.post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "contents": [
                {
                  "role": "user",
                  "parts": [
                    {"text": "I am $age year old $gender"}
                  ]
                },
                {
                  "role": "model",
                  "parts": [
                    {"text": "Okay I have noted your age and gender."}
                  ]
                },
                {
                  "role": "user",
                  "parts": [
                    {
                      "text":
                          "My current daily wear wardrobe is ${dailyWear.join(", ")}"
                    }
                  ]
                },
                {
                  "role": "model",
                  "parts": [
                    {
                      "text":
                          "Okay I have noted down items in your daily wardrobe"
                    }
                  ]
                },
                {
                  "role": "user",
                  "parts": [
                    {
                      "text":
                          "My current party wear wardrobe has ${partyWear.join(", ")}"
                    }
                  ]
                },
                {
                  "role": "model",
                  "parts": [
                    {"text": "Okay I have noted your party wear wardrobe"}
                  ]
                },
                {
                  "role": "user",
                  "parts": [
                    {"text": "My formal wardrobe has ${formalsWear.join(", ")}"}
                  ]
                },
                {
                  "role": "model",
                  "parts": [
                    {"text": "Okay I have noted items in your formal wardrobe"}
                  ]
                },
                {
                  "role": "user",
                  "parts": [
                    {"text": "list items in my daily wear wardrobe"}
                  ]
                },
                {
                  "role": "model",
                  "parts": [
                    {
                      "text":
                          "Your daily wardrobe has black shorts, a white T-shirt and blue pyjamas"
                    }
                  ]
                },
                {
                  "role": "user",
                  "parts": [
                    {"text": "What is in my formal wardrobe?"}
                  ]
                },
                {
                  "role": "model",
                  "parts": [
                    {
                      "text":
                          "Your current formal wardrobe has blue shirt, red tie, black blazer, and brown shoes"
                    }
                  ]
                },
                {
                  "role": "user",
                  "parts": [
                    {"text": "What options do I have in party wear?"}
                  ]
                },
                {
                  "role": "model",
                  "parts": [
                    {
                      "text":
                          "Your party wardrobe has black shirt, blue pants and black shoes"
                    }
                  ]
                },
                {
                  "role": "user",
                  "parts": [
                    {"text": "What can I wear for my next party?"}
                  ]
                },
                {
                  "role": "model",
                  "parts": [
                    {
                      "text":
                          "Based on the items in your party wear wardrobe, you can wear the following outfit:\n\n- Black shirt\n- Blue pants\n- Black shoes\n\nYou can accessorize this outfit with a watch, bracelet, or necklace to complete the look. If the party is more formal, you could add a blazer or jacket."
                    }
                  ]
                },
                {
                  "role": "user",
                  "parts": [
                    {
                      "text":
                          '$prompt. Dont print message such as "These are only the items listed in your daile wear" etc'
                    }
                  ]
                }
              ],
              "generationConfig": {
                "temperature": 0.9,
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
            }));

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
            ;
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

    String formatText(String input) {
      String formattedText = input.replaceAll("**", "");

      return formattedText;
    }

    return Scaffold(
      backgroundColor: lightMode ? Pallet.white : Pallet.black,
      appBar: AppBar(
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
                child: const Row(
                  children: [
                    Icon(
                      Icons.ios_share,
                      size: 20,
                    ),
                    SizedBox(width: 5),
                    Text('Shared Data'),
                  ],
                ),
                onTap: () {
                  rightSlideTransition(
                    context,
                    const DatabasePage(),
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
      body: Column(
        children: [
          //Chat internface
          const SizedBox(height: 20),
          Expanded(
            child: chatList.isEmpty
                ? Center(
                    child: lightMode
                        ? SvgPicture.asset("assets/zeus_dark.svg")
                        : SvgPicture.asset("assets/zeus.svg"),
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
                          alignment:
                              owner ? WrapAlignment.end : WrapAlignment.start,
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
                                color: lightMode ? Pallet.black : Pallet.white,
                              ),
                              child: Text(
                                message,
                                softWrap: true,
                                // maxLines: null,
                                style: TextStyle(
                                  color:
                                      lightMode ? Pallet.white : Pallet.black,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: lightMode
                          ? Pallet.black.withOpacity(0.2)
                          : Pallet.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: chatController,
                      cursorColor: lightMode ? Pallet.black : Pallet.white,
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
                      if (chatController.text.trim().isNotEmpty && !loading) {
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
                            Icons.send_rounded,
                            color: lightMode ? Pallet.white : Pallet.black,
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
