import 'package:chat_app/modal/userInfo_modal.dart';
import 'package:chat_app/pages/forgot_password_screen.dart';
import 'package:chat_app/pages/home_screen.dart';
import 'package:chat_app/pages/signup_screen.dart';
import 'package:chat_app/service/fireStore_database.dart';
import 'package:chat_app/service/local_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String email = "";
  String name = "";
  String userName = "";
  String photo = "";
  String id = "";
  bool? check1 = false;
  bool hidePass = true;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? emailCheck;
  String? passwordCheck;

  // bool isButtonEnable() {
  //   bool check = (emailCheck?.isNotEmpty ?? false) &&
  //       (passwordCheck?.isNotEmpty ?? false);
  //   return check;
  // }

  userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailCheck!, password: passwordCheck!);
      QuerySnapshot querySnapshot = await FireStoreDatabase().getUserInfoByEmail(emailCheck!);
      name = "${querySnapshot.docs.first['name']}";
      userName = "${querySnapshot.docs.first['username']}";
      photo = "${querySnapshot.docs.first['photo']}";
      id = "${querySnapshot.docs.first['id']}";

      UserInfoModal userInfoModal = UserInfoModal(name: name, username: userName,photo: photo, id: id );

      await SharedPreferenceStorage.saveUserInfo(userInfoModal);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No user found for that email!")));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Password Incorrect")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height / 8,
              ),
              Container(
                height: size.height * .65,
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sign In",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.black.withOpacity(.7)),
                          ),
                          SizedBox(
                            height: size.height / 15,
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
                            height: size.height / 20,
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
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const ForgotPasswordScreen()));
                            }, child: const Text("Forgot Password")),
                          ),
                          SizedBox(
                            height: size.height / 20,
                          ),
                          SizedBox(
                            height: size.height / 15,
                            width: double.infinity,
                            child: MaterialButton(
                              color: Colors.black,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  emailCheck = emailController.text;
                                  passwordCheck = passwordController.text;
                                  userLogin();
                                }
                              },
                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height / 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              SizedBox(
                                width: size.width / 60,
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUpScreen()));
                                  },
                                  child: const Text("Sign Up")),
                            ],
                          ),
                        ],
                      ),
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
