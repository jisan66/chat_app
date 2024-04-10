import 'package:chat_app/modal/userInfo_modal.dart';
import 'package:chat_app/pages/chat_screen.dart';
import 'package:chat_app/pages/signin_screen.dart';
import 'package:chat_app/service/fireStore_database.dart';
import 'package:chat_app/service/local_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../global _variable.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    print(
                        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return ChatRoomListTile(
                        chatRoomId: ds.id,
                        lastMessage: ds['lastMessage'],
                        time: ds['lastMessageSendTs']);
                  })
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
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
                              // setState(() {});
                              var chatRoomId =
                                  getChatRoomId(myUserName, item['username']);
                              Map<String, dynamic> chatRoomInfo = {
                                'user': [myUserName, item['username']]
                              };
                              await FireStoreDatabase()
                                  .createChatRoom(chatRoomId, chatRoomInfo);
                              setState(() {});
                              print(
                                  'name: ${item["name"]},userName: ${item["username"]},photo: ${item["photo"]},chatRoomId: $chatRoomId,');

                              if (mounted) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                              name: item["name"],
                                              userName: item["username"],
                                              photo: item["photo"],
                                              chatRoomId: chatRoomId,
                                            )));
                              }
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 60,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.asset(
                                        "assets/images/person1.jpg",
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
                                              color: Colors.black
                                                  .withOpacity(.51)),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                    : chatRoomList()),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          SharedPreferenceStorage.clearUserInfo();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignInScreen()), (route) => false);
        },
        child: Icon(Icons.logout_outlined),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  String? lastMessage, chatRoomId, time;

  ChatRoomListTile(
      {super.key,
      required this.chatRoomId,
      required this.lastMessage,
      required this.time});

  @override
  State<ChatRoomListTile> createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String photo = '', name = '', username = '', id = '';
  bool isLoading = false;

  getThisUserInfo() async {
    setState(() {
      isLoading = true;
    });

    print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu  photo = $photo");
    if (widget.chatRoomId == '${myUserName}_$myUserName') {
      username = myUserName;
    } else {
      username =
          widget.chatRoomId!.replaceAll("_", "").replaceAll(myUserName, "");
    }
    print("Fetching user info for username: $username");
    QuerySnapshot userData =
        await FireStoreDatabase().getUserInfo(username.toUpperCase());
    setState(() {
      name = userData.docs[0]['name'];
      photo = userData.docs[0]['photo'];
      id = userData.docs[0]['id'];
      isLoading = false;
    });
    print("User info fetched successfully: name=$name, photo=$photo");
    print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu  photo = $photo");
  }

  loadInfo() async {
    await getThisUserInfo();
  }

  @override
  void initState() {
    loadInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async{

        Map<String, dynamic> chatRoomInfo = {
          'user': [myUserName, username]
        };
        await FireStoreDatabase()
            .createChatRoom(widget.chatRoomId!, chatRoomInfo);
        setState(() {});
        if(mounted){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        name: name,
                        userName: username,
                        photo: photo,
                        chatRoomId: widget.chatRoomId,
                      )));
        }
        print("ame: $name,userName: $username,photo: $photo,chatRoomId: ${widget.chatRoomId},aaaaaaaaaaaauuuuuuuuuuuuuuuuuuuuuu");
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isLoading
                  ? const SizedBox(
                      height: 50,
                      width: 50,
                      child: LinearProgressIndicator(),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        photo,
                        fit: BoxFit.cover,
                        height: 50,
                        width: 50,
                      ),
                    ),
              SizedBox(
                width: size.width / 40,
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.lastMessage ?? '',
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                          color: Colors.black.withOpacity(.51)),
                    )
                  ],
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 1,
                child: Text(widget.time ?? '',
                    style: TextStyle(
                        fontSize: 12, color: Colors.black.withOpacity(.51))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
