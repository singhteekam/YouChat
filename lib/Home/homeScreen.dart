import 'package:YouChat/GroupChat/Login.dart';
import 'package:YouChat/GroupChat/customBtn.dart';
import 'package:YouChat/PrivateChats/signInGoogle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text("YouChat",
                  textScaleFactor: 5, style: GoogleFonts.lobster()),
              CustomButton(
                text: "Private Chat",
                callback: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> SignInPrivate())),
              ),
              CustomButton(
                text: "Group Chat",
                callback: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> SignInGroup())),
              )
            ],
          ),
        ),
      ),
    );
  }
}