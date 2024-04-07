import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Jisan Saha"),
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
            children: [Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: size.width/2),
                  child: const Text("Hi, how are you?"),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15)
                    ),
                    color: Colors.white
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: size.width/2),
                  child: const Text("I am good. How about you??"),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                      ),
                      color: Colors.white
                  ),
                ),
              ],
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
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.message),
                                contentPadding: const EdgeInsets.all(4),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25)
                                )
                            ),
                          ),
                        )),
                        IconButton(onPressed: (){}, icon: const Icon(Icons.send))
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
