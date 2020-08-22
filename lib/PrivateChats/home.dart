import 'package:YouChat/GroupChat/Profile.dart';
import 'package:YouChat/Home/homeScreen.dart';
import 'package:YouChat/PrivateChats/allChats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:YouChat/PrivateChats/NewChat.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PrivateHome extends StatefulWidget {
  @override
  _PrivateHomeState createState() => _PrivateHomeState();
}

class _PrivateHomeState extends State<PrivateHome> {
  Firestore firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Private Chats"),
          actions: <Widget>[
            PopupMenuButton(itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem(
                  child: ListTile(
                    onTap: () =>
                        Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => Profile(),
                    )),
                    leading: Icon(Icons.chat),
                    title: Text("Profile"),
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    onTap: () =>
                        Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => NewChat(),
                    )),
                    leading: Icon(Icons.chat),
                    title: Text("New Chat"),
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    onTap: () {
                      _auth.signOut();
                      googleSignIn.signOut();
                      Navigator.of(context)
                          .pushReplacement(new MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ));
                    },
                    leading: Icon(Icons.exit_to_app),
                    title: Text("Log Out"),
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    onTap: () => Navigator.of(context)
                        .pushReplacement(new MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    )),
                    leading: Icon(Icons.home),
                    title: Text("Home"),
                  ),
                ),
              ];
            }),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );

              List<DocumentSnapshot> allChats = snapshot.data.documents;

              List<Widget> allChats2 = allChats.map((doc) {
                return AllChats(
                  email: doc.data['email'],
                );
              }).toList();

              return ListView.builder(
                  itemCount: allChats2.length,
                  itemBuilder: (BuildContext context, int index) {
                    return allChats2[index];
                  });
            }));
  }
}
