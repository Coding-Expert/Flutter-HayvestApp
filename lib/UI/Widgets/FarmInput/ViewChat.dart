import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/Buying/ChatObjectBuyer.dart';

import 'ChatObject.dart';

class ViewChat extends StatefulWidget {
  Map party;
  String DocID;
  bool farm;

  ViewChat(this.party, this.DocID, {this.farm = false});

  @override
  _ViewChatState createState() => _ViewChatState();
}

class _ViewChatState extends State<ViewChat> {
  TextEditingController counterController;
  bool animatedStatus = false;

  @override
  Widget build(BuildContext context) {
    bool farm = widget.farm;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.party["name"]),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection("chats")
            .document(widget.DocID)
            .collection("Messages")
            .orderBy('Time')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: farm
                          ? ChatObject(widget.party,
                              snapshot.data.documents[index], widget.DocID)
                          : ChatObjectBuyer(widget.party,
                              snapshot.data.documents[index], widget.DocID));
                });
          }
        },
      ),
    );
  }
}
