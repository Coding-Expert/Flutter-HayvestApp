import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ChatObjectBuyer extends StatefulWidget {
  Map party;
  DocumentSnapshot Document;
  String DocId;

  ChatObjectBuyer(this.party, this.Document, this.DocId);

  @override
  _ChatObjectBuyerState createState() => _ChatObjectBuyerState();
}

class _ChatObjectBuyerState extends State<ChatObjectBuyer> {
  bool animatedStatus = false;
  TextEditingController counterController = TextEditingController();
  String NotifyQuery = r''' 
    mutation ($Message: String!, $action: String!, $title: String!, $type: String!) {
      notify(Message: $Message, partyId: 1, type: $type, title: $title, action: $action) {
        chat {
          id
        }
      }
    }
  ''';

  @override
  Widget build(BuildContext context) {
    final HttpLink _httplink =
    HttpLink(uri: "http://34.76.96.215:8000/graphql/");
    final Link _link = _httplink;
    final GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: _link,
    );;
    DocumentSnapshot document = widget.Document;
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 200),
      crossFadeState:
      animatedStatus ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstChild: Bubble(
          color: (document["Sender"] == "Party A")
              ? Colors.grey
              : Color.fromRGBO(225, 255, 199, 1.0),
          nip: (document["Sender"] == "Party A")
              ? BubbleNip.rightTop
              : BubbleNip.leftTop,
          alignment: Alignment.topLeft,
          child: ListTile(
            title: Text(
              (document["Sender"] == "Party A")
                  ? "You are offering"
                  : widget.party["name"] + " wants to sell",
              style: TextStyle(fontSize: 17.0),
            ),
            subtitle: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "KSh. " + document["Price"],
                  style: TextStyle(fontSize: 16.0),
                ),
                ((document["Status"] == "Open") &&
                    (document["Sender"] == "Party B"))
                    ? Row(
                  children: <Widget>[
                    FlatButton(
                        color: Colors.green,
                        onPressed: () {},
                        child: Text("Yes")),
                    SizedBox(
                      width: 8,
                    ),
                    FlatButton(
                        color: Colors.orange,
                        onPressed: () {
                          setState(() {
                            animatedStatus = true;
                          });
                        },
                        child: Text("Negotiate")),
                  ],
                )
                    : SizedBox()
              ],
            ),
          )),
      secondChild: Bubble(
          color: (document["Sender"] == "Party A")
              ? Colors.grey
              : Color.fromRGBO(225, 255, 199, 1.0),
          nip: (document["Sender"] == "Party A")
              ? BubbleNip.rightTop
              : BubbleNip.leftTop,
          alignment: Alignment.topLeft,
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  "Buyer",
                  style: TextStyle(fontSize: 17.0),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      "KS. " + document["Price"],
                      style: TextStyle(fontSize: 16.0),
                    ),
                    FlatButton(
                        color: Colors.orange,
                        onPressed: () {
                          setState(() {
                            animatedStatus = false;
                          });
                        },
                        child: Text("Cancel")),
                  ],
                ),
              ),
              TextField(
                keyboardType: TextInputType.numberWithOptions(),
                controller: counterController,
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: new BorderSide(
                          color: Colors.blueGrey[700],
                          width: 2,
                          style: BorderStyle.solid)),
                  hintText: "New Price",
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  FloatingActionButton.extended(
                    onPressed: () {
                      print("Buyer Chat");
                      print("${widget.party["name"]}");
                      counterPrice(document, counterController.text);
                      print("Id: ${widget.party["id"]}");
                      MutationOptions options =
                      MutationOptions(document: NotifyQuery, variables: {
                        "Message": counterController.text,
                        "action": "TakeAction",
                        "partyId": widget.party["id"],
                        "title": "Counter Offer Re",
                        "type": "Farmer"
                      });
                      _client.mutate(options);
                    },
                    icon: Icon(
                      Icons.send,
                      size: 20,
                    ),
                    label: Text("Send"),
                  ),
                ],
              )
            ],
          )),
    );
  }

  void counterPrice(DocumentSnapshot document, String Price) async {
    print(widget.DocId);
    CollectionReference collections = Firestore.instance
        .collection("chats")
        .document(widget.DocId)
        .collection("Messages");
    try {
      await collections.add({
        "Message": "Counter offer",
        "Price": Price,
        "Status": "Open",
        "Sender": "Party A",
        "Time": DateTime.now()
      });
      setState(() {
        animatedStatus = false;
      });
    } catch (e) {
      print("Adding Failed");
      print(e);
    }

    try {
      await collections
          .document(document.documentID)
          .setData({"Status": "Rejected"}, merge: true);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Sending Price"),
      ));
    } catch (e) {
      print("Adding Failed");
      print(e.message);
    }
  }
}
