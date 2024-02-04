import 'package:flutter/material.dart';
import 'package:hushh_proto/models/message_model.dart';
import 'package:hushh_proto/widgets/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;

  Chat chat = Chat();
  bool lightMode = false;
  TextEditingController chatController = TextEditingController();
  List<Message> chatList = [
    Message(sender: 'user', content: 'Hi I am Aaditya'),
    Message(sender: 'model', content: 'Hi Aaditya how can I help you today?'),
  ];

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
            chatList.add(
              Message(
                sender: 'model',
                content: body['candidates'][0]['content']['parts'][0]['text'],
              ),
            );
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

    return Scaffold(
      backgroundColor: lightMode ? Pallet.white : Pallet.black,
      appBar: AppBar(
        backgroundColor: lightMode ? Pallet.white : Pallet.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Zeus",
              style: TextStyle(
                color: lightMode ? Pallet.black : Pallet.white,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  lightMode = !lightMode;
                });
              },
              icon: lightMode
                  ? const Icon(
                      Icons.dark_mode,
                      color: Pallet.black,
                    )
                  : const Icon(
                      Icons.light_mode,
                      color: Pallet.white,
                    ),
            )
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          //Chat internface
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                Message msg = chatList[index];
                bool owner = msg.sender == 'user' ? true : false;
                String message = msg.content;

                return Wrap(
                  alignment: owner ? WrapAlignment.end : WrapAlignment.start,
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
                          color: lightMode ? Pallet.white : Pallet.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                );
              },
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
                      style: const TextStyle(color: Pallet.white),
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
                      if (chatController.text.trim().isNotEmpty) {
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
                    icon: Icon(
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
