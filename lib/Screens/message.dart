
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  final String from;
  final String text;
  final String date;
  final bool me;
  final docId;


  const Message({Key key, this.from, this.text,this.date, this.me,this.docId}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {

  final Firestore _firestore = Firestore.instance;

  deleteDoc(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Delete this message?"),
          actions: <Widget>[
            FlatButton(child: Text("No"),
        onPressed: () => Navigator.pop(context),),
        FlatButton(child: Text("Yes"),
        onPressed: () {
         _firestore.collection("messages").document(widget.docId).delete();
         Navigator.pop(context);
        }
         )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          crossAxisAlignment:
              widget.me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            
            GestureDetector(
              onLongPress: deleteDoc,
                child: Material(
                color: widget.me ? Colors.blue : Colors.teal,
                borderRadius: BorderRadius.circular(5.0),
                elevation: 2.0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Text(
                    widget.text,
                  ),
                ),
              ),
            ),
            Text(
              widget.from,
            ),
            Text(widget.date.substring(11,19)),
            Text(widget.date.substring(0,10)),
             Padding(padding: const EdgeInsets.only(top:12)),
          ],
        ),
      ),
    );
  }
}
