import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../screens/auth_ui/login_screen.dart';
import '../../controller/firebase_api.dart';
import '../../constant/widget/roundButton.dart';
import '../../controller/auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final firestore = FirebaseFirestore.instance.collection('customer');
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool showPassword = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Container(child: Image.asset("images/Signwall.jpeg")),
            Container(
              margin:
              EdgeInsets.only(top: mq.height * .12, left: mq.width * .35),
              height: mq.height * .1,
              child: ClipOval(
                child: Image.asset("images/app_icon.jpeg"),
              ),
            ),
            Container(
              margin:
              EdgeInsets.only(top: mq.height * .22, left: mq.width * .27),
              child: Text(
                "ClosetHunt",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: 200,
              height: 80,
              margin:
              EdgeInsets.only(top: mq.height * .29, left: mq.width * .22),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: LinearGradient(
                      colors: [
                        Colors.green.shade100,
                        Colors.greenAccent.shade200,
                        Colors.greenAccent.shade200,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.3, 0.9, 0.4])),
              child: const Center(
                child: Text(
                  "Welcome",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                    top: mq.height * .43,
                    left: mq.width * .03,
                    right: mq.width * .03),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: 'Name',
                          prefixIcon: Icon(Icons.create),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.alternate_email_sharp),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: showPassword == false ? true : false,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                                icon: showPassword
                                    ? Icon(Icons.lock_open_outlined)
                                    : Icon(Icons.lock_outline))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordController2,
                        obscureText: showPassword == false ? true : false,
                        decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                                icon: showPassword
                                    ? Icon(Icons.lock_open_outlined)
                                    : Icon(Icons.lock_outline))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      DropdownButton(
                        // Initial Value
                        value: Auth.dropdownvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: Auth.items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            Auth.dropdownvalue = newValue!;
                          });
                        },
                      ),
                      RoundButton(
                          title: 'Sign Up',
                          colors: Colors.white,
                          loading: loading,
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              Future.delayed(
                                  Duration(seconds: 3),
                                      () async => await Auth.signUp(
                                      nameController.text,
                                      emailController.text,
                                      passwordController.text,
                                      passwordController2.text,
                                      context)
                                      .then((value) {
                                    setState(() {
                                      loading = false;
                                    });
                                  }));
                              // Auth.signUp(
                              //         nameController.text,
                              //         emailController.text,
                              //         passwordController.text,
                              //         passwordController2.text,
                              //         context)
                              //     .then((value) {
                              //   setState(() {
                              //     loading = false;
                              //   });
                              // });
                            }
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account ? ",
                            style:
                            TextStyle(fontSize: 17, color: Colors.blueGrey),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                              child: Text(
                                'Login !',
                                style:
                                TextStyle(fontSize: 18, color: Colors.blue),
                              ))
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
    );
  }
}