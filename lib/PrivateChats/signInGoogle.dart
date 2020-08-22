import 'package:YouChat/PrivateChats/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInPrivate extends StatefulWidget {
  @override
  _SignInPrivateState createState() => _SignInPrivateState();
}

class _SignInPrivateState extends State<SignInPrivate> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  FirebaseUser _user;
  final Firestore _firestore = Firestore.instance;
  int flag=0;

  @override
  initState() {
    super.initState();
    isLoggedIn();
  }



  isLoggedIn() async {
    _user = await _auth.currentUser();
    if (_user != null) {
      Fluttertoast.showToast(msg: "Signed in as: "+_user.email,backgroundColor: Colors.white,textColor: Colors.black);
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => PrivateHome()));
    }
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
          if (user.email == doc.data["email"]){
            flag=1;
          }
         });
         if(flag==0)
       _firestore.collection('users').document(user.email).setData({
        'email': user.email,
        'photoUrl': user.photoUrl,
        'name': user.displayName
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
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Private Chat",textScaleFactor: 5,style: GoogleFonts.lobster(),),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SignInButton(
                    Buttons.GoogleDark,
                    // text: "Sign In with Google",
                    onPressed: () => _signIn().whenComplete(() =>
                        Navigator.pushReplacement(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) => PrivateHome()))),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}