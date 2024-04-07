import 'package:chat_app/pages/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool? check1 = false;
  bool hidePass = true;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? emailCheck;
  String? passwordCheck;

  bool isButtonEnable() {
    bool check = (emailCheck?.isNotEmpty ?? false) &&
        (passwordCheck?.isNotEmpty ?? false);

    return check;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height/8,),
              Container(
                height: size.height*.6,
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
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
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1)),
                              filled: false,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1)),
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
                          height: size.height / 12,
                        ),
                        SizedBox(
                          height: size.height/15,
                          width: double.infinity,
                          child: MaterialButton(
                            color: Colors.black,
                            onPressed: () {  },
                            child: const Text("Sign in", style: TextStyle(color: Colors.white,fontSize: 18),),
                          ),
                        ),
                        SizedBox(height: size.height/12,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            SizedBox(width: size.width/60,),
                            TextButton(onPressed: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUpScreen()));
                            }, child: Text("Sign Up")),
                          ],
                        ),
                      ],
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
