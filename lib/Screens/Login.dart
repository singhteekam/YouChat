import 'package:YouChat/Screens/CustomBtn.dart';
import 'package:YouChat/Screens/Register.dart';
import 'package:YouChat/Screens/ResetPass.dart';
import 'package:YouChat/Screens/chatScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:YouChat/PrivateChats/home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;
  bool _obscureText = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _user;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  initState() {
    super.initState();
    isLoggedIn();
  }

  isLoggedIn() async {
    _user = await _auth.currentUser();
    if (_user != null) {
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (BuildContext context) => Chat()));
    }
  }

  Future<void> loginUser() async {
    FirebaseUser user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    Fluttertoast.showToast(msg: "Logged in successfully");
    //if (user.isEmailVerified)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(),
      ),
    );
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

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.2,
                  bottom: MediaQuery.of(context).size.width * 0.2),
              child: Text("YouChat",
                  textScaleFactor: 5, style: GoogleFonts.lobster()),
            ),
            Text(
              "Log In",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40),
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
            FlatButton(
              color: Colors.green,
              child: Text("Private Chats"),
              onPressed: () => Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => PrivateHome())),
            ),
            Padding(padding: const EdgeInsets.only(top: 60))
          ],
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
