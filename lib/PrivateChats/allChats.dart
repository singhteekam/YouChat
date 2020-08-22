import 'package:YouChat/PrivateChats/privateChatScn.dart';
import 'package:flutter/material.dart';

class AllChats extends StatefulWidget {

  final email;
  AllChats({@required this.email,});

  @override
  _AllChatsState createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {


  
   @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(borderRadius:BorderRadius.circular(10),color: Colors.grey,),
        child: ListTile(
          onTap: () { 
            Navigator.push(context, MaterialPageRoute(builder: (context) => PrivateChatSCreen(
            reciever: widget.email,
          ),));
          },
          leading: Icon(Icons.person),
          title: Text(widget.email),
        ),
      ),
    );
  }
}