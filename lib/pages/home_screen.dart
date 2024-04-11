import 'package:chat_app/modal/userInfo_modal.dart';
import 'package:chat_app/pages/chat_screen.dart';
import 'package:chat_app/pages/signin_screen.dart';
import 'package:chat_app/service/fireStore_database.dart';
import 'package:chat_app/service/local_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../global _variable.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool searchBox = false;
  var querySearchList = [];
  var temSearchStore = [];
  Stream? chatRoomStream;

  getSharedPref() async {
    UserInfoModal userData = await SharedPreferenceStorage.getUserInfo();
    myName = userData.name ?? "";
    myUserName = userData.username ?? "";
    myPhoto = userData.photo ?? "";
    myEmail = userData.email ?? "";
    myId = userData.id ?? "";
  }

  loadMyData() async {
    await getSharedPref();
    chatRoomStream = await FireStoreDatabase().getChatRooms();
    setState(() {});
  }

  initSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        querySearchList = [];
        temSearchStore = [];
      });
    }
    setState(() {
      searchBox = true;
    });
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (querySearchList.isEmpty && value.length == 1) {
      FireStoreDatabase()
          .searchUser(capitalizedValue)
          .then((QuerySnapshot data) {
        for (int i = 0; i < data.docs.length; i++) {
          setState(() {
            querySearchList.add(data.docs[i].data());
          });
        }
      });
    } else {
      temSearchStore = [];
      querySearchList.forEach((element) {
        if (element['username']
            .toString()
            .toUpperCase()
            .startsWith(capitalizedValue)) {
          setState(() {
            temSearchStore.add(element);
          });
        }
      });
    }
  }

  String getChatRoomId(String a, String b) {
    if (a.compareTo(b) < 0) {
      return "$a\_$b";
    } else {
      return "$b\_$a";
    }
  }

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              String chatRoomId = ds.id;
              String lastMessage = ds['lastMessage'];
              String time = ds['lastMessageSendTs'];

              // Fetch user information for the current chat room
              return FutureBuilder(
                future: FireStoreDatabase().getUserInfo(getUsernameFromChatRoomId(chatRoomId)),
                builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return LinearProgressIndicator();
                  } else if (userSnapshot.hasError) {
                    return Text('Error: ${userSnapshot.error}');
                  } else {
                    String name = userSnapshot.data!.docs[0]['name'];
                    String photo = userSnapshot.data!.docs[0]['photo'];

                    return ChatRoomListTile(
                      chatRoomId: chatRoomId,
                      lastMessage: lastMessage,
                      time: time,
                      name: name,
                      photo: photo,
                    );
                  }
                },
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // Helper function to extract username from chat room id
  String getUsernameFromChatRoomId(String chatRoomId) {
    List<String> parts = chatRoomId.split('_');
    return parts.first == myUserName ? parts.last : parts.first;
  }

  @override
  void initState() {
    loadMyData();
    print(myUserName);
    print(myName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          searchBox
              ? Expanded(
            flex: 10,
            child: TextFormField(
              onChanged: (value) {
                initSearch(value.toUpperCase());
              },
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderSide: BorderSide.none),
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchBox = false;
                      setState(() {});
                    },
                    icon: const Icon(Icons.close),
                  ),
                  hintText: "Search"),
            ),
          )
              : const Expanded(flex: 10, child: Text("Chat App")),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                searchBox = true;
                setState(() {});
              },
            ),
          )
        ]),
        foregroundColor: Colors.black87,
      ),
      body: GestureDetector(
        onTap: () {},
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: size.height,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius:
                const BorderRadius.only(topLeft: Radius.circular(16))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: searchBox
                  ? ListView.builder(
                  itemCount: temSearchStore.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> item = temSearchStore[index];
                    return GestureDetector(
                      onTap: () async {
                        searchBox = false;
                        var chatRoomId =
                        getChatRoomId(myUserName, item['username']);
                        Map<String, dynamic> chatRoomInfo = {
                          'user': [myUserName, item['username']]
                        };
                        await FireStoreDatabase()
                            .createChatRoom(chatRoomId, chatRoomInfo);
                        setState(() {});
                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                name: item["name"],
                                userName: item["username"],
                                photo: item["photo"],
                                chatRoomId: chatRoomId,
                              ),
                            ),
                          );
                        }
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const SizedBox(
                                height: 60,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset(
                                  "assets/images/person1.png",
                                  fit: BoxFit.cover,
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                              SizedBox(
                                width: size.width / 40,
                              ),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'].toString(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    item['username'],
                                    style: TextStyle(
                                        color:
                                        Colors.black.withOpacity(.51)),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
                  : chatRoomList(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SharedPreferenceStorage.clearUserInfo();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
                (route) => false,
          );
        },
        child: Icon(Icons.logout_outlined),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  String? lastMessage, chatRoomId, time, name, photo;

  ChatRoomListTile({
    Key? key,
    required this.chatRoomId,
    required this.lastMessage,
    required this.time,
    required this.name,
    required this.photo,
  }) : super(key: key);

  @override
  State<ChatRoomListTile> createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async {
        Map<String, dynamic> chatRoomInfo = {
          'user': [myUserName, getUsernameFromChatRoomId(widget.chatRoomId!)],
        };
        await FireStoreDatabase()
            .createChatRoom(widget.chatRoomId!, chatRoomInfo);
        setState(() {});
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                name: widget.name,
                userName: getUsernameFromChatRoomId(widget.chatRoomId!),
                photo: widget.photo,
                chatRoomId: widget.chatRoomId,
              ),
            ),
          );
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  widget.photo!,
                  fit: BoxFit.cover,
                  height: 50,
                  width: 50,
                ),
              ),
              SizedBox(
                width: size.width / 40,
              ),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.lastMessage ?? '',
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.black.withOpacity(.51),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Expanded(
                flex: 2,
                child: Text(
                  widget.time ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withOpacity(.51),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to extract username from chat room id
  String getUsernameFromChatRoomId(String chatRoomId) {
    List<String> parts = chatRoomId.split('_');
    return parts.first == myUserName ? parts.last : parts.first;
  }
}
