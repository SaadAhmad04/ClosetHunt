import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mall/screens/auth_ui/login_screen.dart';
import '../constant/widget/roundButton.dart';
import '../controller/auth.dart';
import '../main.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(

          leading: IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
          }, icon: Icon(Icons.arrow_back_outlined,color: Colors.black,),

          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: mq.height*.15,left: mq.width*.05),
              //color: Colors.blue,
              child: Text("Forgot your password ?",

                style: TextStyle(
                  fontSize: 22,

                ),),
            ),
            Container(
              //color: Colors.pink,
              margin: EdgeInsets.only(top: mq.height*.02,left: mq.width*.02),
              child: Text("\t\t Entered your registered email below \n to receive password reset instructions",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: mq.height*.07),
                height: mq.height*0.24,
                child: ClipOval(
                    child: Image.network("https://i.pinimg.com/1200x/d1/5b/31/d15b31eef4348435de616adb3c371dfe.jpg")),
              ),
            ),
            SizedBox(height: mq.height*.04),
            SingleChildScrollView(
              child: Container(
                child: Column(

                  children: [
                    Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextFormField(

                            controller: emailController,
                            decoration: InputDecoration(

                              prefixIcon: Icon(Icons.alternate_email_outlined),
                              hintText: 'Email',
                            ),
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Enter email';
                              }
                              return null;
                            },
                          ),
                        )
                    ),
                    SizedBox(height: mq.height*0.02,),
                    RoundButton(
                        title: 'Send Verification Email',
                        onTap: () {
                          if(_formKey.currentState!.validate()){
                            CircularProgressIndicator();
                            Auth.forgotpassword(emailController.text);
                          }
                        })
                  ],
                ),
              ),
            )


          ],
        ),




      ),
    );
  }
}