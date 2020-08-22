import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecieverProfile extends StatefulWidget {
  final reciever;
  RecieverProfile({this.reciever});
  @override
  _RecieverProfileState createState() => _RecieverProfileState();
}

class _RecieverProfileState extends State<RecieverProfile> {

  final Firestore _firestore = Firestore.instance;
  String name,photoUrl;
  
  @override
  void initState() {
    super.initState();
    initReciever();
  }

  initReciever() async{
    await _firestore.collection("users").getDocuments().then((docs) {
      docs.documents.forEach((fetchData) {
        if(fetchData.data['email']==widget.reciever){
          name= fetchData.data['name'];
          photoUrl= fetchData.data['photoUrl'];
          setState(() {});
          return;
        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          builder: (context, fetchSnap) {
            if (fetchSnap.connectionState == ConnectionState.none &&
                fetchSnap.hasData == null) {
              return Container();
            }
            return Column(
              children: <Widget>[
                Center(
                    child: ClipOval(
                  child: Image.network(
                    photoUrl,
                    fit: BoxFit.fill,
                    width: 100,
                    height: 100,
                  ),
                )),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    name,
                    textScaleFactor: 2,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Email: " + widget.reciever,
                    textScaleFactor: 1.3,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                
              ],
            );
          },
          future: initReciever(),
        ),
      ),
    );
  }
}
