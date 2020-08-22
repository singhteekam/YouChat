
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
    return Container(
      child: Column(
        crossAxisAlignment:
            widget.me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.from,style: TextStyle(fontSize: 12,fontStyle: FontStyle.italic,color: Colors.grey[300])
          ),
          GestureDetector(
            onLongPress: deleteDoc,
              child: Material(
              color: widget.me ? Colors.blue : Colors.teal,
              borderRadius: BorderRadius.circular(5.0),
              elevation: 2.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: Text.rich(
                  TextSpan(
                  text: widget.text,
                  style: TextStyle(fontSize: 18),
                  children: <InlineSpan>[
                    TextSpan(
                      text: "\t\t"+widget.date.substring(11,16),
                      style: TextStyle(fontSize: 12,fontStyle: FontStyle.italic,color: Colors.blueGrey[100])
                    )
                  ]
                ),
                )
              ),
            ),
          ),
          
          Text(widget.date.substring(0,10),style: TextStyle(fontSize: 12,fontStyle: FontStyle.italic,color: Colors.grey[300])),
           Padding(padding: const EdgeInsets.only(top:12)),
        ],
      ),
    );
  }
}
