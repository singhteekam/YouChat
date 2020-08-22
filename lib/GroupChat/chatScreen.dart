import 'package:YouChat/GroupChat/groupMessage.dart';
import 'package:YouChat/GroupChat/Profile.dart';
import 'package:YouChat/GroupChat/sendMessage.dart';
import 'package:YouChat/Home/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  FirebaseUser user;
  String name, email;

  @override
  initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    user = await _auth.currentUser();
    name = user.displayName;
    email = user.email;
  }

  Future<void> sendMessage() async {
    if (messageController.text.length > 0) {
      await _firestore.collection('Group Messages').add({
        'name': name,
        'text': messageController.text,
        'from': email,
        'date': DateTime.now().toIso8601String().toString().substring(0, 19),
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      Fluttertoast.showToast(msg: "Message is empty",backgroundColor: Colors.white,textColor: Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            onTap: null,
            child: Text(
              "YouChat",
              style: GoogleFonts.lobster(),
            )),
        actions: <Widget>[
          PopupMenuButton(itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem(
                child: ListTile(
                  onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => Profile(),
                  )),
                  leading: Icon(Icons.person),
                  title: Text("Profile"),
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  onTap: () {
                    _auth.signOut();
                    googleSignIn.signOut();
                    Fluttertoast.showToast(msg: "Logged out successfully",backgroundColor: Colors.white,textColor: Colors.black);
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ));
                  },
                  leading: Icon(Icons.exit_to_app),
                  title: Text("Logout"),
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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('Group Messages')
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  List<DocumentSnapshot> docs = snapshot.data.documents;

                  List<Widget> messages = docs
                      .map((doc) => Message(
                            from: doc.data['from'],
                            text: doc.data['text'],
                            date: doc.data['date'],
                            me: email == doc.data['from'],
                            docId: doc.documentID,
                          ))
                      .toList();

                  // return ListView(
                  //   controller: scrollController,
                  //   children: <Widget>[
                  //    ...messages,
                  //   ],
                  // );

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        controller: scrollController,
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return messages[index];
                        }),
                  );
                },
              ),
            ),
            

            SendMessage(
              submitCallback: (value)=>sendMessage(),
              controllerCallback: messageController,
              sendCallback: sendMessage,
            )
          ],
        ),
      ),
    );
  }
}
