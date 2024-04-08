import 'package:chat_app/pages/chat_screen.dart';
import 'package:chat_app/pages/home_screen.dart';
import 'package:chat_app/pages/signin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBRjmcZ5qzCLgvHQzD85b3Y0KvaWzzgBz8", // paste your api key here
      appId: "1:1097673795104:android:45aee039e8c3b089967e45", //paste your app id here
      messagingSenderId: "1097673795104", //paste your messagingSenderId here
      projectId: "chat-app-7deac", //paste your project id here
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
          colorScheme: const ColorScheme.light(primary: Colors.black)
      ),
      home: const SignInScreen(),
    );
  }
}
