import 'package:chat2/Chat/Home.dart';
import 'package:chat2/Chat/Register.dart';
import 'package:chat2/Chat/ResetPass.dart';
import 'package:chat2/Chat/chatScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;
  bool _obscureText= true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> loginUser() async {
    FirebaseUser user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    Fluttertoast.showToast(msg: "Logged in successfully");
  //if (user.isEmailVerified)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          user: user,
        ),
      ),
    );
  }

Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YouChat"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (context) => Home(),));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
              child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(top:50)),
            
            Text("Log In",textAlign:TextAlign.center,
              style:TextStyle(fontWeight: FontWeight.bold,fontSize: 40),),
              Padding(padding: const EdgeInsets.only(top:10)),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                  labelText: "Enter Your Email...",
                  icon: Icon(Icons.email),
                ),
              ),
            ),
           
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autocorrect: false,
                obscureText: _obscureText,
                onChanged: (value) => password = value,
                decoration: InputDecoration(
                  labelText: "Enter Your Password...",
                  icon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                   _obscureText
                   ? Icons.visibility
                   : Icons.visibility_off,
                   color: Theme.of(context).primaryColorLight,
                   ),
                onPressed: () {
                   // Update the state i.e. toogle the state of passwordVisible variable
                   setState(() {
                       _obscureText = !_obscureText;
                   });
                 },
                ),
                ),
              ),
            ),
            CustomButton(
              text: "Log In",
              callback: () async {
                await loginUser();
              },
            ),
            Padding(padding: const EdgeInsets.only(top:8)),
            GestureDetector(
             child: Text("Create new account",textAlign: TextAlign.center, style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue,fontSize: 20)),
              onTap: () {
                // do what you need to do when "Click here" gets clicked
                Navigator.of(context).push(new MaterialPageRoute(builder: (context) => Register(),));
            }
            ),
            Padding(padding: const EdgeInsets.only(top:12)),
            GestureDetector(
             child: Text("Forgot Password?",textAlign: TextAlign.center, style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue,fontSize: 20)),
              onTap: () {
                // do what you need to do when "Click here" gets clicked
                Navigator.of(context).push(new MaterialPageRoute(builder: (context) => Reset(),));
            }
            ),
             Padding(padding: const EdgeInsets.only(top:60))
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child:Text("Built by @TS❤️",textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15,),),
       // color:Colors.grey
      ),
    );
  }
}

