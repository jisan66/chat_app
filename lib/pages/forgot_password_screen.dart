import 'package:chat_app/pages/signin_screen.dart';
import 'package:chat_app/pages/signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String emailCheck = "";

  resetPassword() async{
    try{
      FirebaseAuth.instance.sendPasswordResetEmail(email: emailCheck);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password email has been sent")));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const SignInScreen()), (route) => false);
    } on FirebaseAuthException catch (e){
      if(e.code =='user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No user found for that email")));
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
                height: size.height * .6,
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
                            "Password Recovery",
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
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1)),
                                filled: false,
                                contentPadding:
                                EdgeInsets.symmetric(vertical: 10),
                                hintText: "Email",
                                prefixIcon:  Icon(
                                    Icons.email_outlined,
                                    color: Colors.black,
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
                          SizedBox(
                            height: size.height / 15,
                            width: double.infinity,
                            child: MaterialButton(
                              color: Colors.black,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  emailCheck = emailController.text;
                                  resetPassword();
                                }
                              },
                              child: const Text(
                                "Send Email",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height / 12,
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
