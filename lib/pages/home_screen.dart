import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Chat App"),
              IconButton(icon : const Icon(Icons.search), onPressed: () {},)]),
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: size.height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16))
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 60,),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset("assets/images/person1.jpg",fit: BoxFit.cover,height: 50,width: 50,),
                        ),
                        SizedBox(width: size.width/40,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Jisan Saha",style: TextStyle(fontSize: 16),),
                            SizedBox(height: 8,),
                            Text("How are You", style: TextStyle(color: Colors.black.withOpacity(.51)),)
                          ],
                        ),
                        Spacer(),
                        Text("04.22PM",style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(.51)))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
