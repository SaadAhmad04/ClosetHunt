import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/utils/utilities.dart';
import '../../constant/widget/roundButton.dart';
import '../../controller/auth.dart';
import '../forgot_password_screen.dart';
import '../customer/customer_home.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: mq.height * .47,
                width: mq.width * 1,
                child: Opacity(
                    opacity: 0.6,
                    child: Image.asset(
                      "images/Logwall.jpeg",
                      fit: BoxFit.cover,
                    )),
              ),
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
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: mq.height * .42, horizontal: mq.width * .1),
                child: Center(
                  child: Container(
                    width: mq.width * .6,
                    height: mq.height * .1,
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
                    child: Center(
                      child: Text(
                        "Hello",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                      top: mq.height * .55,
                      left: mq.width * .03,
                      right: mq.width * .03),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
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
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock_open_outlined),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
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
                            title: 'Login',
                            loading: loading,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 10,
                                  ),
                                );

                                Auth.login(
                                    emailController.text.toString(),
                                    passwordController.text.toString(),
                                    context);
                              }
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account ? ",
                              style: TextStyle(
                                  fontSize: 17, color: Colors.blueGrey),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignUpScreen()));
                                },
                                child: Text(
                                  'Sign Up !',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.blue),
                                ))
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen()));
                            },
                            child: Text(
                              'Forgot Password ? ',
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            ))
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
