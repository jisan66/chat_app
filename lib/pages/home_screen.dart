import 'package:chat_app/modal/userInfo_modal.dart';
import 'package:chat_app/pages/chat_screen.dart';
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

  getSharedPref() async{
    UserInfoModal userData = await SharedPreferenceStorage.getUserInfo();
    myName = userData.name ?? "";
    myUserName = userData.username ?? "";
    myPhoto = userData.photo ?? "";
    myEmail = userData.email ?? "";
    myId = userData.id ?? "";
  }

  loadMyData() async{
    await getSharedPref();
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
        if (element['username'].toString().toUpperCase().startsWith(capitalizedValue)) {
          setState(() {
            temSearchStore.add(element);
          });
        }
      });
    }
  }

  getChatRoomId(String a, String b){
    if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0))
      {return "$b\_$a";}
    else
      {return "$a\_$b";}
  }

  @override
  void initState() {
    loadMyData();
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
                            onTap: () async{
                              searchBox = false;
                              setState(() {

                              });
                              var chatRoomId = getChatRoomId(myUserName!, item['username']);
                              Map<String, dynamic> chatRoomInfo = {
                                'users' : [myUserName, item['username']]
                              };
                              await FireStoreDatabase().createChatRoom(chatRoomId, chatRoomInfo);
                              if(mounted){
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
                                              color:
                                                  Colors.black.withOpacity(.51)),
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    Text("04.22PM",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black.withOpacity(.51)))
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                    : ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Card(
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
                                      const Text(
                                        "Jisan Saha",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "How are You",
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(.51)),
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  Text("04.22PM",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black.withOpacity(.51)))
                                ],
                              ),
                            ),
                          );
                        })),
          ),
        ),
      ),
    );
  }
}
