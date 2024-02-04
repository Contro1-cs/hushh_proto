import 'package:flutter/material.dart';
import 'package:hushh_proto/widgets/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool lightMode = false;
  TextEditingController chatController = TextEditingController();
  List chatList = [
    {'role': 'user', 'message': 'My name is Aaditya.'},
    {'role': 'model', 'message': 'Hey Aaditya How can I help you today?'}
  ];

  @override
  Widget build(BuildContext context) {
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
                bool owner = chatList[index]['role'] == 'user' ? true : false;
                String message = chatList[index]['message'];

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
                      setState(() {
                        chatList.add({
                          'role': 'user',
                          'message': chatController.text,
                        });
                      });
                      chatController.clear();
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
