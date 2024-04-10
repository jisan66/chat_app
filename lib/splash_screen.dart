import 'dart:io';
import 'package:chat_app/pages/home_screen.dart';
import 'package:chat_app/pages/signin_screen.dart';
import 'package:chat_app/service/local_database.dart';
import 'package:flutter/material.dart';

import 'global _variable.dart';
import 'modal/userInfo_modal.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<double> _animation;
  UserInfoModal userData = UserInfoModal();



  getUserDetails() async {
    try {
      userData = await SharedPreferenceStorage.getUserInfo();
      myName = userData.name ?? "";
      myUserName = userData.username ?? "";
      myPhoto = userData.photo ?? "";
      myEmail = userData.email ?? "";
      myId = userData.id ?? "";
    } catch (e) {
      print('Error getting user details: $e');
    }
  }

  Future<void> initAsync() async {
    try {
      await getUserDetails();
    } catch (e) {
      print('Error during initialization: $e');
    }

    Future.delayed(const Duration(seconds: 0)).then((_) {
      navigateToLogin();
    });
  }

  Future<void> navigateToLogin() async {
    final bool isLoggedin = await SharedPreferenceStorage.checkIfLoggedIn();
    {
      if(isLoggedin == true){
        await getUserDetails();
        if(mounted){
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) => const HomeScreen()),
                  (route) => false);
        }
      }
      else {
        if(mounted){
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const SignInScreen()),
                  (route) => false);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
         initAsync();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: ScaleTransition(
              scale: _animation,
              child: const Text("ChatApp", style: TextStyle(fontSize: 40,fontWeight: FontWeight.w600),)
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
          ),
          const Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(children: [
              Text(
              "Version-1.0",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: .5),
            ),
              Text(
                "JISAN SAHA",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 6, fontWeight: FontWeight.w800, letterSpacing: 2.5),
              )],),
          )
        ],
      ),
    );
  }
}
