import 'package:YouChat/GroupChat/CustomBtn.dart';
import 'package:YouChat/GroupChat/Login.dart';
import 'package:YouChat/GroupChat/chatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final Firestore _firestore = Firestore.instance;

  String email;
  String password;
  String name;
  bool _obscureText = true;
  int flag = 0;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser() async {
    try {
      FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // await user.sendEmailVerification();
    Fluttertoast.showToast(msg: "New account created",backgroundColor: Colors.white,textColor: Colors.black);

    await _firestore.collection("users").getDocuments().then((fetchData) {
      fetchData.documents.forEach((doc) {
        if (user.email == doc.data["email"]) {
          flag = 1;
        }
      });
      if (flag == 0) 
      _firestore.collection('users').document(user.email).setData({
        'email': user.email,
        'name': name,
        'photoUrl': "https://banner2.cleanpng.com/20180521/ocp/kisspng-computer-icons-user-profile-avatar-french-people-5b0365e4f1ce65.9760504415269493489905.jpg",
        'isEmailVerified': user.isEmailVerified.toString()
      });
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(),
      ),
    );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Email already exists!!",
        backgroundColor: Colors.white,
        textColor: Colors.black);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("Group Chat",
                  textScaleFactor: 5, style: GoogleFonts.lobster()),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => name = value,
                  decoration: InputDecoration(
                    labelText: "Enter Your Name...",
                    icon: Icon(Icons.person),
                  ),
                ),
              ),
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
                    labelText: "Create Password...",
                    icon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _obscureText ? Icons.visibility : Icons.visibility_off,
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
                text: "Register",
                callback: () async {
                  await registerUser();
                },
              ),
              Padding(padding: const EdgeInsets.only(top: 5)),
              GestureDetector(
                  child: Text("Already have an account?Login Here",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                          fontSize: 20)),
                  onTap: () {
                    // do what you need to do when "Click here" gets clicked
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (context) => SignInGroup(),
                    ));
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Note: Please register yourself with valid email address to receive password reset emails.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Text(
          "Built by @TS❤️",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        // color:Colors.grey
      ),
    );
  }
}
