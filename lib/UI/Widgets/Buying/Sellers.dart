import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

class Selling extends StatefulWidget {
  String ProudctName;
  List Buyer;

  Selling(this.ProudctName, this.Buyer);

  @override
  _SellingState createState() => _SellingState();
}

class _SellingState extends State<Selling> {
  List sellers;
  bool loading = true;
  bool expanded = false;

  getSellers(String prodName) async {
    String queryProducts = r'''
    query ger_prod_sellers($name: String!){
      products(search: $name){
        id
        name
        alternativeName
        sales{
          id
          amount
          price
          unit{
            id
            name
            alternativeName
          }
          farm{
            id
            name
            owner{
              id
              uid
              fcmId
            }
          }
          county{
            id
            name
          }
        }
      }
    } ''';
    final HttpLink _htppLink =
        HttpLink(uri: "http://34.76.96.215:8000/graphql/");
    final GraphQLClient client =
        GraphQLClient(link: _htppLink, cache: InMemoryCache());
    final QueryOptions options =
        QueryOptions(document: queryProducts, variables: {"name": prodName});
    final response = await client.query(options);
    if (response.errors != null) {
      print("errors Found");
    }
    if (response.data == null) {
      print("Null data");
    } else {
      var Product = response.data["products"][0];
      sellers = Product["sales"];
      setState(() {
        loading = false;
      });
    }
  }

  String _randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });

    return new String.fromCharCodes(codeUnits);
  }

  @override
  void initState() {
    getSellers(widget.ProudctName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
            body: Center(
            child: CircularProgressIndicator(),
          ))
        : Scaffold(
            appBar: AppBar(
              title: Text("Sellers "),
            ),
            body: Center(
              child: ListView.builder(
                itemCount: sellers.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return SpecificSeller(sellers[index], widget.Buyer);
                },
              ),
            ),
          );
  }
}

class SpecificSeller extends StatefulWidget {
  Map seller;
  List Buyer;

  SpecificSeller(this.seller, this.Buyer);

  @override
  _SpecificSellerState createState() => _SpecificSellerState();
}

class _SpecificSellerState extends State<SpecificSeller> {
  Map seller;
  bool expanded = false;

  void _expand() {
    setState(() {
      expanded ? expanded = false : expanded = true;
    });
  }

  @override
  void initState() {
    seller = widget.seller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController counterController = TextEditingController();
    return GestureDetector(
      onTap: _expand,
      child: AnimatedCrossFade(
        duration: Duration(milliseconds: 250),
        crossFadeState:
            expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        firstChild: Card(
          child: ListTile(
            title: Text("Seller: ${seller["farm"]["name"]}"),
            subtitle: Text("Available: " +
                seller["amount"].toString() +
                " " +
                seller["unit"]["name"]),
            trailing: Column(
              children: <Widget>[
                Text("Price: ${seller["price"].toString()}"),
                Text("Per ${seller["unit"]["name"].toString()}")
              ],
            ),
          ),
        ),
        secondChild: Card(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text("Seller: ${seller["farm"]["name"]}"),
                subtitle: Text("Available: " +
                    seller["amount"].toString() +
                    " " +
                    seller["unit"]["name"]),
                trailing: Column(
                  children: <Widget>[
                    Text("Price: ${seller["price"].toString()}"),
                    Text("Per ${seller["unit"]["name"].toString()}")
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                      color: Colors.deepOrangeAccent,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Column(
                                  children: <Widget>[
                                    Text(
                                      "Offer a counter price to",
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "${seller["farm"]["name"]}".toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                content: TextField(
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  controller: counterController,
                                  decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: new BorderSide(
                                            color: Colors.blueGrey[700],
                                            width: 2,
                                            style: BorderStyle.solid)),
                                    hintText: "Your Counter Price",
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: new Text('SEND OFFER'),
                                    onPressed: () {
                                      print("Offer");
                                      print(counterController.text);
                                      fsSend(counterController.text,
                                          seller["farm"]);
                                    },
                                  ),
                                  FlatButton(
                                    child: new Text('CANCEL'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      },
                      child: Text("Negotiate Price")),
                  FlatButton(
                    color: Colors.greenAccent,
                    onPressed: () {},
                    child: Text("Accept and Buy"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showModal(Map<String, dynamic> seller) {
    String Price;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("Quote a counter price"),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: <Widget>[
              Flexible(
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 20,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: new Theme(
                        data: new ThemeData(
                          primaryColor: Colors.blueGrey[500],
                          primaryColorDark: Colors.blueGrey[700],
                        ),
                        child: new TextField(
                          style: TextStyle(height: 2.7),
                          onChanged: (val) {
                            setState(() {
                              print(val);
                              Price = val;
                            });
                          },
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: new BorderSide(
                                    color: Colors.blueGrey[700],
                                    width: 2,
                                    style: BorderStyle.solid)),
                            hintText: "Your Counter Price",
                          ),
                        ),
                      ))),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      print(Price);
//                      fsSend(Price, seller);
                    }),
              )
            ],
          ),
        )
      ],
    );
  }

  void fsSend(String price, seller) {
    print(price);
    String qR = r''' 
      mutation addChat($buyerId: Int!, $sellerId: Int!, $docRef: String!) {
      addChat(BuyerId: $buyerId, SellerId: $sellerId, DocId: $docRef) {
        chat{
          id
          partyA{
            name
          }
          partyB{
            name
          }
          docId
        }
      }
    }
    ''';

    final HttpLink _htppLink =
        HttpLink(uri: "http://34.76.96.215:8000/graphql/");
    final GraphQLClient client =
        GraphQLClient(link: _htppLink, cache: InMemoryCache());

    Firestore.instance.collection("chats").add(
        {"Party A": "Test", "Reciever B": seller["name"]}).then((docReference) {
      print(widget.Buyer[0]['id']);
      print(seller['id']);
      print(docReference.documentID);

      final QueryOptions options = QueryOptions(document: qR, variables: {
        "buyerId": widget.Buyer[0]['id'],
        "sellerId": seller["id"],
        "docRef": docReference.documentID
      });
      client.query(options).then((result) {
        if (result.errors != null) {
          print("Errors Occured");
        } else {
          if (result.data == null) {
            print("Error Posting");
          } else {
            docReference.collection("Messages").add({
              "Message": "Counter offer",
              "Price": price,
              "Status": "Open",
              "Sender": "Party A",
              "Time": DateTime.now()
            });
            Navigator.of(context).pop();
          }
        }
      });
    });
  }
}
