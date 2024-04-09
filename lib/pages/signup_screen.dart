import 'dart:math';

import 'package:chat_app/modal/userInfo_modal.dart';
import 'package:chat_app/pages/signin_screen.dart';
import 'package:chat_app/service/fireStore_database.dart';
import 'package:chat_app/service/local_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool? check1 = false;
  bool hidePass = true;
  bool isLoading = false;
  final formkey = GlobalKey<FormState>();
  String email = "",
      password = "",
      name = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  registration() async {

    if (email.isNotEmpty && passwordController.text.toString() == confirmPasswordController.text.toString()) {
      print("qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
      try {

        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        String id = Random().nextInt(10).toString();
        String user = emailController.text.replaceAll("@gmail.com", "");
        String userName = user.replaceFirst(user[0], user[0].toUpperCase());
        String firstLetter = user.substring(0,1).toUpperCase();
        UserInfoModal userInfo = UserInfoModal(name: nameController.text,
            username: userName.toUpperCase(),
            email: emailController.text,
            firstLetter: firstLetter.toUpperCase(),
            password: passwordController.text,
            photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWzt3Izh2jMM-3ed5bT5v0RZzT0UcdQd9Xg7MnkHCSyQ&s",
            id: id);

        await FireStoreDatabase().addUserInfo(userInfo, id);
        await SharedPreferenceStorage.saveUserInfo(userInfo);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration Successful")));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Password too weak")));
        }
        else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Account already exists!")));
        }
      }
    }
  }

  String? emailCheck;
  String? passwordCheck;

  bool isButtonEnable() {
    bool check = (emailCheck?.isNotEmpty ?? false) &&
        (passwordCheck?.isNotEmpty ?? false);

    return check;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height / 10,
              ),
              Container(
                height: size.height * .7,
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 16),
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.black.withOpacity(.7)),
                          ),
                          SizedBox(
                            height: size.height / 25,
                          ),
                          TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1)),
                                filled: false,
                                contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                                hintText: "Name",
                                prefixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              validator: (String? nameText) {
                                if (nameText?.isEmpty ?? true) {
                                  return "Enter Name";
                                } else if (nameText!.contains("@") == true) {
                                  return "Enter valid name";
                                }
                                return null;
                              }),
                          SizedBox(
                              height: size.height / 30
                          ),
                          TextFormField(
                              onChanged: (value) {
                                emailCheck = value;
                                setState(() {});
                              },
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1)),
                                filled: false,
                                contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                                hintText: "Email",
                                prefixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.email_outlined,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              validator: (String? emailText) {
                                if (emailText?.isEmpty ?? true) {
                                  return "Enter email address";
                                } else if (emailText!.contains("@") == false) {
                                  return "Enter a valid address";
                                }
                                return null;
                              }),
                          SizedBox(
                            height: size.height / 30,
                          ),
                          TextFormField(
                              controller: passwordController,
                              onChanged: (value) {
                                passwordCheck = value;
                                setState(() {});
                              },
                              obscureText: hidePass,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1)),
                                contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                                hintText: "Password",
                                prefixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.lock,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {},
                                ),
                                suffixIcon: IconButton(
                                  icon: hidePass
                                      ? const Icon(
                                    Icons.visibility_off,
                                    color: Colors.black,
                                  )
                                      : const Icon(
                                    Icons.visibility,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      hidePass = !hidePass;
                                    });
                                  },
                                ),
                              ),
                              validator: (String? passText) {
                                if (passText?.isEmpty ?? true) {
                                  return "Enter Password";
                                }
                                return null;
                              }),
                          SizedBox(
                            height: size.height / 30,
                          ),
                          TextFormField(
                              controller: confirmPasswordController,
                              onChanged: (value) {
                                passwordCheck = value;
                                setState(() {});
                              },
                              obscureText: hidePass,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1)),
                                contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                                hintText: "Confirm Password",
                                prefixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.lock,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              validator: (String? passText) {
                                if (passText?.isEmpty ?? true) {
                                  return "Enter Password";
                                } else if (passwordController.text.toString() !=
                                    confirmPasswordController.text.toString()) {
                                  return "Passwords are not same";
                                }
                                return null;
                              }),
                          SizedBox(
                            height: size.height / 20,
                          ),
                          SizedBox(
                            height: size.height / 15,
                            width: double.infinity,
                            child: MaterialButton(
                              color: Colors.black,
                              onPressed: () {
                                print(passwordController.text.toString());
                                print(confirmPasswordController.text.toString());
                                if (formkey.currentState!.validate()) {
                                  email = emailController.text;
                                  password = passwordController.text;
                                  name = nameController.text;
                                  registration();
                                  print("dddddddddddddddddddddddd");
                                }
                              },
                              child: const Text(
                                "Sign up",
                                style:
                                TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  SizedBox(
                    width: size.width / 60,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
                      },
                      child: const Text("Sign In")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
