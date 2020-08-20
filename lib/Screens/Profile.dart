import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  FirebaseUser user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  initState(){
    super.initState();
    initUser();
  }

  initUser() async{
     user = await _auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          builder: (context, fetchSnap) {
          if (fetchSnap.connectionState == ConnectionState.none && fetchSnap.hasData == null) {
            return Container();
          }
          return Column(
          children: <Widget>[
           Center(
                    child: ClipOval(
                    child: Image.network(
                      "https://www.kindpng.com/picc/m/78-785827_user-profile-avatar-login-account-male-user-icon.png",
                      fit: BoxFit.fill,
                      width: 100,
                      height: 100,
                    ),
                  )),
                
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     user.displayName,
            //     textScaleFactor: 2,
            //     style: TextStyle(
            //         fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Email: " + user.email,
                textScaleFactor: 1.3,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Account Verified: " + user.isEmailVerified.toString(),
                textScaleFactor: 1.3,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
            ),
            
          ],
        );
          },
          future: initUser(),
        ),
      ),
    );
  }
}

