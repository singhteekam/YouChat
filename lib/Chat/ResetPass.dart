import 'package:chat2/Chat/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Reset extends StatefulWidget {
  @override
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  String resetEmail;
   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    Fluttertoast.showToast(msg: "Password reset mail sent successfully!!");
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => Home(),));
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Reset Password"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (context) => Home(),));
            },
          )
        ],
      ),
      body: Column(
        children:<Widget>[
          Padding(padding: const EdgeInsets.only(top:25)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => resetEmail = value,
              decoration: InputDecoration(
                labelText: "Enter Your Email...",
                icon: Icon(Icons.email)
              ),
            ),
          ),
          CustomButton(
            text: "Reset password",
            callback: () async {
              await resetPassword(resetEmail);
              
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Only Registered users can reset their password.",textAlign: TextAlign.center,style: TextStyle(
              fontSize:15,fontWeight:FontWeight.bold
            ),),
          )
        ]
      ),
      bottomNavigationBar: BottomAppBar(
        child:Text("Built by @TS❤️",textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15,),),
       // color:Colors.grey
      ),
    );
  }
}