
import 'package:chat2/Chat/Login.dart';
import 'package:chat2/Chat/Register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
              child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding:  EdgeInsets.only(top:MediaQuery.of(context).size.width*0.2),
              child: Image.asset("assets/images/logo2.jpg",width: MediaQuery.of(context).size.width*0.4,height: MediaQuery.of(context).size.height*0.2,),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: const EdgeInsets.only(left: 13.0)),
                Text(
                  "YouChat",
                  style: TextStyle(
                    fontSize: 40.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            CustomButton(
              text: "Log In",
              callback: () {
                Navigator.of(context).push(new MaterialPageRoute(builder: (context) => LoginPage(),));
              },
            ),
            CustomButton(
              text: "Sign Up",
              callback: () {
                Navigator.of(context).push(new MaterialPageRoute(builder: (context) => Register(),));
              },
            ),
            // CustomButton(
            //   text: "Sign In with Google",
            //   callback: () {
            //     _signIn();
            //   },
            // ),
            // new RaisedButton(
            //     child: new Text("Sign in"),
            //     color: Colors.blue,
            //     onPressed: () async {
            //       GoogleSignInAccount googleUser = await googleSignIn.signIn();
            //       final GoogleSignInAuthentication googleAuth =
            //           await googleUser.authentication;
            //       final AuthCredential credential =
            //           GoogleAuthProvider.getCredential(
            //         accessToken: googleAuth.accessToken,
            //         idToken: googleAuth.idToken,
            //       );
            //       final FirebaseUser user = (await _auth
            //           .signInWithCredential(credential)) as FirebaseUser;
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => Chat(
            //             user: user,
            //           ),
            //         ),
            //       );
            //     }
            //     ),
            Padding(padding: const EdgeInsets.all(10)),
            Text(
              "Note: Please register yourself with valid email address to receive password reset emails.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            
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
        // color:Colors.grey
      ),
    );
  }

  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
}

class CustomButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;

  const CustomButton({Key key, this.callback, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.blue,
        elevation: 6.0,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: callback,
          minWidth: 200.0,
          height: 45.0,
          child: Text(text),
        ),
      ),
    );
  }
}
