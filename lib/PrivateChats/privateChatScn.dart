import 'package:YouChat/GroupChat/groupMessage.dart';
import 'package:YouChat/GroupChat/sendMessage.dart';
import 'package:YouChat/PrivateChats/privateMessage.dart';
import 'package:YouChat/PrivateChats/recieverProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivateChatSCreen extends StatefulWidget {
  final reciever;
  PrivateChatSCreen({@required this.reciever});
  @override
  _PrivateChatSCreenState createState() => _PrivateChatSCreenState();
}

class _PrivateChatSCreenState extends State<PrivateChatSCreen> {

  final Firestore _firestore = Firestore.instance;
    FirebaseUser user;
    String email;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  @override
  initState(){
    super.initState();
    initUser();
    // print(widget.reciever);
  }


  initUser() async{
    user=await _auth.currentUser();
    email=user.email;
    setState(() {});
  }


  sendPrivateMessage() async{
    if (messageController.text.length > 0) {
      await _firestore.collection('users').document(user.email).collection(widget.reciever).add({
        'Sender': user.email,
        'text': messageController.text,
        'Reciever': widget.reciever,
        'date': DateTime.now().toIso8601String().toString().substring(0, 19),
      });

      await _firestore.collection('users').document(widget.reciever).collection(user.email).add({
        'Sender': user.email,
        'text': messageController.text,
        'Reciever': widget.reciever,
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
  

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(child: Text(widget.reciever,style: GoogleFonts.lobster(),),onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RecieverProfile(reciever: widget.reciever,),)),),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection("users").document(user.email).collection(widget.reciever).orderBy("date").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData )
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  List<DocumentSnapshot> docs = snapshot.data.documents;

                  List<Widget> messages = docs
                      .map((doc) => PrivateMessage(
                            text: doc.data['text'],
                            date: doc.data['date'],
                            me: email == doc.data['Sender'],
                            docId: doc.documentID,
                          ))
                      .toList();


                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        controller: scrollController,
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return messages[index];
                          // return Message(
                          //   from: docs[index].data['Sender'],
                          //   text: docs[index].data['text'],
                          //   date: docs[index].data['date'],
                          //   me: email==docs[index].data['Sender'],
                          //   docId: docs[index].documentID,
                          // );
                        }),
                  );

                  // return FutureBuilder(
                  //   future: null,
                  //   builder: (context, snapshot) {
                  //     if(!snapshot.hasData && snapshot.connectionState==ConnectionState.none){
                  //       return Center(
                  //         child: CircularProgressIndicator(),
                  //       );
                  //     }
                  //   return ListView.builder(
                  //     controller: scrollController,
                  //     itemCount: messages.length,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return messages[index];
                  //     });
                  //   },
                  // );
                },
              ),
            ),

            SendMessage(
              submitCallback: (value)=>sendPrivateMessage(),
              controllerCallback: messageController,
              sendCallback: sendPrivateMessage,
            )
          ],
        ),
      ),
    );
  }
}