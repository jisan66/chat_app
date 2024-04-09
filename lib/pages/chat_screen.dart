import 'dart:math';

import 'package:chat_app/global%20_variable.dart';
import 'package:chat_app/service/fireStore_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String? name, photo, userName,chatRoomId;
  const ChatScreen({super.key, required this.photo, required this.name, required this.userName, required this.chatRoomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  TextEditingController messageController = TextEditingController();
  String? messageId;

  getChatRoomId(String a, String b){
    if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0))
    {return "$b\_$a";}
    else
    {return "$a\_$b";}
  }

  addMessage(bool sendClicked)
  {

    if(messageController != "")
      {print("aaaaaaaaaaaaaaaaaa");
        String message = messageController.text;
        messageController.clear();
        DateTime dateTime = DateTime.now();
        String formattedDate = DateFormat("h:mma").format(dateTime);
        Map<String,dynamic> messageInfo = {
          "message" : message,
          "sendBy" : myUserName,
          "ts" : formattedDate,
          "time" : FieldValue.serverTimestamp(),
          "imageUrl" : myPhoto
        };
        // if(messageId == ""){
        //   messageId = getRandomString(12);
        // }
        FireStoreDatabase().addMessage(widget.chatRoomId!,getRandomString(12), messageInfo).then((value){
          Map<String, dynamic> lastMessageInfo ={
            "lastMessage" : message,
            "lastMessageSendTs" : formattedDate,
            "time" : FieldValue.serverTimestamp(),
            "lastMessageSendBy" : myUserName
          };
          FireStoreDatabase().updateLastMessageSend(widget.chatRoomId!, lastMessageInfo);
          if(sendClicked)
            {
              messageId ="";
            }
        });
      }

  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.name!),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.pop(context);
        },),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: size.height/1.12,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25), topLeft: Radius.circular(25)),
              color: Colors.black12
          ),
          child:Stack(
            children: [Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: size.width/3),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15)
                      ),
                      color: Colors.white
                    ),
                    child: const Align(alignment: Alignment.bottomLeft,child: Text("Hi, how are you?ddddddddddddddddddd")),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(10),
                    margin: EdgeInsets.only(right: size.width/2),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                        ),
                        color: Colors.white
                    ),
                    child: const Text("I am good. How about you??"),
                  ),
                ],
              ),
            ),
              Positioned(

                bottom: 10,
                child: Container(
                  height: 70,
                  child: Card(
                    child: Row(
                      children: [
                        SizedBox(height : 70, width: size.width/1.20,child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: messageController,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.message),
                                contentPadding: const EdgeInsets.all(4),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25)
                                )
                            ),
                          ),
                        )),
                        IconButton(onPressed: (){

                          addMessage(true);
                        }, icon: const Icon(Icons.send))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
