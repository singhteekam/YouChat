import 'package:YouChat/Screens/Login.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YouChat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        // textTheme: GoogleFonts.actorTextTheme(
        //     Theme.of(context).textTheme,
        //   )
      ),
      home: LoginPage(),
    );
  }
}

