import 'package:flutter/material.dart';

class SendMessage extends StatelessWidget {
  final submitCallback, controllerCallback, sendCallback;
  SendMessage(
      {this.submitCallback, this.controllerCallback, this.sendCallback});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextField(
                  onSubmitted: (value) => submitCallback(),
                  decoration: InputDecoration(
                    hintText: "Type a Message",
                    // border: const OutlineInputBorder(),
                  ),
                  controller: controllerCallback),
            ),
          ),
          FlatButton(
              color: Colors.blueAccent,
              onPressed: sendCallback,
              child: Icon(Icons.send),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0))),
        ],
      ),
    );
  }
}
