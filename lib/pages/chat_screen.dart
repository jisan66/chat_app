import 'dart:math';

import 'package:chat_app/global%20_variable.dart';
import 'package:chat_app/pages/home_screen.dart';
import 'package:chat_app/service/fireStore_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String? name, photo, userName, chatRoomId;

  const ChatScreen(
      {super.key,
      required this.photo,
      required this.name,
      required this.userName,
      required this.chatRoomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  TextEditingController messageController = TextEditingController();
  String? messageId;
  String? chatRoomId;

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  Stream? messageStream;
  bool isTyped = false;

  String getChatRoomId(String a, String b) {
    if (a.compareTo(b) < 0) {
      return "$a\_$b";
    } else {
      return "$b\_$a";
    }
  }

  addMessage(bool sendClicked) {
    if (messageController != "") {
      print("aaaaaaaaaaaaaaaaaa");
      String message = messageController.text;
      messageController.clear();
      DateTime dateTime = DateTime.now();
      String formattedDate = DateFormat("h:mma").format(dateTime);
      Map<String, dynamic> messageInfo = {
        "message": message,
        "sendBy": myUserName,
        "ts": formattedDate,
        "time": FieldValue.serverTimestamp(),
        "imageUrl": myPhoto
      };
      // if(messageId == ""){
      //   messageId = getRandomString(12);
      // }
      FireStoreDatabase()
          .addMessage(chatRoomId!, getRandomString(12), messageInfo)
          .then((value) {
        Map<String, dynamic> lastMessageInfo = {
          "lastMessage": message,
          "lastMessageSendTs": formattedDate,
          "time": FieldValue.serverTimestamp(),
          "lastMessageSendBy": myUserName
        };
        FireStoreDatabase()
            .updateLastMessageSend(chatRoomId!, lastMessageInfo);
        if (sendClicked) {
          messageId = "";
        }
      });
    }
  }

  Widget chatMessage() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.black));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.only(bottom: 90, top: 130),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return chatMessageTile(ds["message"], myUserName == ds["sendBy"]);
            },
          );
        } else {
          return const Center(
            child: Text("No Message found!"),
          );
        }
      },
    );
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
            child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(24),
                  topLeft: const Radius.circular(24),
                  bottomRight: sendByMe
                      ? const Radius.circular(0)
                      : const Radius.circular(24),
                  bottomLeft: sendByMe
                      ? const Radius.circular(24)
                      : const Radius.circular(0)),
              color: Colors.white),
          child: Text(message),
        ))
      ],
    );
  }

  getAndSetMessages() async {
    messageStream =
        await FireStoreDatabase().getChatRoomMessages(widget.chatRoomId!);
  }

  Future<void> loadData() async {
    chatRoomId = getChatRoomId(widget.userName!, myUserName);
    await getAndSetMessages();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.name!),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height / 1.12,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
            color: Colors.black12,
          ),
          child: Stack(
            children: [
              FutureBuilder(
                future: loadData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return chatMessage();
                  }
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 70,
                  child: Card(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: SizedBox(
                            height: 70,
                            width: size.width / 1.20,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: messageController,
                                onTap: (){},
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.message),
                                  contentPadding: const EdgeInsets.all(4),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {
                              messageController.text.isNotEmpty ? addMessage(true) : null;
                            },
                            icon: Icon(
                              Icons.send,
                              color:messageController!=null ? Colors.black : Colors.black12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
