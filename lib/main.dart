import 'package:chat2/Chat/Home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YouChat',
      theme: ThemeData.dark(),
      // home: MyHomePage(),
      home: Home(),
    );
  }
}


