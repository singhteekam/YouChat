import 'package:flutter/material.dart';
import 'package:YouChat/PrivateChats/NewChat.dart';

class PrivateHome extends StatefulWidget {
  @override
  _PrivateHomeState createState() => _PrivateHomeState();
}

class _PrivateHomeState extends State<PrivateHome> {
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
                      builder: (context) => NewChat(),
                    )),
                    leading: Icon(Icons.chat),
                    title: Text("New Chat"),
                  ),
                ),
              ];
            }),
          ],
        ),
        body: StreamBuilder(builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );

            return null;
        }));
  }
}
