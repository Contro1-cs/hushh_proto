import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  Chat chat = Chat();
  
  //Controllers
  TextEditingController chatController = TextEditingController();
  ScrollController chatScrollController = ScrollController();

  //Variables
  bool loading = false;
  bool lightMode = false;
  List<Message> chatList = [];

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
      List<String> parts = input.split('**');
      StringBuffer formattedText = StringBuffer();

      for (int i = 0; i < parts.length; i++) {
        if (i.isEven) {
          formattedText.write(parts[i]);
        } else {
          formattedText.write(parts[i]);
        }
      }

      return formattedText.toString();
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
            icon: const Icon(
              Icons.more_vert,
              color: Pallet.white,
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
                onTap: () {},
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
                    child: SvgPicture.asset("assets/zeus.svg"),
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
