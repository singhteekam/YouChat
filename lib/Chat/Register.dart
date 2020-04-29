
import 'package:chat2/Chat/Home.dart';
import 'package:chat2/Chat/Login.dart';
import 'package:chat2/Chat/chatScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email;
  String password;
  String name;
  bool _obscureText= true;
  // String _timeString;
  // String _dateString;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser() async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    Fluttertoast.showToast(msg: "New account created");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          user: user,name: name,
        ),
      ),
    );
  }
  //  @override
  // void initState(){
  //   _timeString = "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
  //   Timer.periodic(Duration(seconds:1), (Timer t)=>_getCurrentTime());
  //   super.initState();
  // }
  // void _getCurrentTime()  {
  //   setState(() {
  // _timeString = "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
  //  _dateString = "${DateTime.now().year} / ${DateTime.now().month} /${DateTime.now().day}";
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YouChat"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
             Navigator.of(context).push(new MaterialPageRoute(builder: (context) => Home(),));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
              child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(top:50)),
            // Text(_timeString,textAlign: TextAlign.center, style: TextStyle(fontSize: 14),),
            // Text(_dateString,textAlign: TextAlign.center, style: TextStyle(fontSize: 14),),
           
            Text("Sign Up",textAlign:TextAlign.center,
              style:TextStyle(fontWeight: FontWeight.bold,fontSize: 40),),
              Padding(padding: const EdgeInsets.only(top:10)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => name = value,
                decoration: InputDecoration(
                  labelText: "Enter Your Name...",
                  icon: Icon(Icons.person),
                ),
            ),
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
                  labelText: "Create Password...",
                  icon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                   _obscureText
                   ? Icons.visibility
                   : Icons.visibility_off,
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
              text: "Register",
              callback: () async {
                await registerUser();
              },
            ),
            Padding(padding: const EdgeInsets.only(top:5)),
            GestureDetector(
             child: Text("Already have account?Login Here",textAlign: TextAlign.center, style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue,fontSize: 20)),
              onTap: () {
                // do what you need to do when "Click here" gets clicked
                Navigator.of(context).push(new MaterialPageRoute(builder: (context) => LoginPage(),));
            }
            ),
            Padding(padding: const EdgeInsets.only(top:1))
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child:Text("Built by @TS❤️",textAlign: TextAlign.center, style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15,),),
       // color:Colors.grey
      ),
    );
  }
}

