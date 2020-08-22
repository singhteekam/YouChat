import 'package:YouChat/GroupChat/CustomBtn.dart';
import 'package:YouChat/GroupChat/Register.dart';
import 'package:YouChat/GroupChat/ResetPass.dart';
import 'package:YouChat/GroupChat/chatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInGroup extends StatefulWidget {
  @override
  _SignInGroupState createState() => _SignInGroupState();
}

class _SignInGroupState extends State<SignInGroup> {
  String email;
  String password;
  bool _obscureText = true;
  int flag = 0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _user;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final Firestore _firestore = Firestore.instance;

  @override
  initState() {
    super.initState();
    isLoggedIn();
  }

  isLoggedIn() async {
    _user = await _auth.currentUser();
    if (_user != null) {
      Fluttertoast.showToast(
          msg: "Signed in as: " + _user.email,
          backgroundColor: Colors.white,
          textColor: Colors.black);
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (BuildContext context) => Chat()));
    }
  }

  Future<void> loginUser() async {
    try {
      await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    Fluttertoast.showToast(
        msg: "Logged in successfully",
        backgroundColor: Colors.white,
        textColor: Colors.black);

    //if (user.isEmailVerified)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(),
      ),
    );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Invalid user",
        backgroundColor: Colors.white,
        textColor: Colors.black);
    }

    
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)) as FirebaseUser;

    await _firestore.collection("users").getDocuments().then((fetchData) {
      fetchData.documents.forEach((doc) {
        if (user.email == doc.data["email"]) {
          flag = 1;
        }
      });
      if (flag == 0)
        _firestore.collection('users').document(user.email).setData({
          'email': user.email,
          'photoUrl': user.photoUrl,
          'name': user.displayName,
          'isEmailVerified': user.isEmailVerified
        });
    });

    return user;
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
                text: "Log In",
                callback: () async {
                  await loginUser();
                },
              ),
              Padding(padding: const EdgeInsets.only(top: 8)),
              GestureDetector(
                  child: Text("Create new account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                          fontSize: 20)),
                  onTap: () {
                    // do what you need to do when "Click here" gets clicked
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (context) => Register(),
                    ));
                  }),
              Padding(padding: const EdgeInsets.only(top: 12)),
              GestureDetector(
                  child: Text("Forgot Password?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                          fontSize: 20)),
                  onTap: () {
                    // do what you need to do when "Click here" gets clicked
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => Reset(),
                    ));
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SignInButton(
                  Buttons.GoogleDark,
                  onPressed: () => _signIn().whenComplete(() =>
                      Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) => Chat()))),
                ),
              ),
              Padding(padding: const EdgeInsets.only(top: 60))
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
      ),
    );
  }
}
