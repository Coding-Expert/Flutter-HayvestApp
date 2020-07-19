import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_classifiedappclone/Model/Categ.dart';
import 'package:flutter_classifiedappclone/Model/categoryModel.dart';
import 'package:flutter_classifiedappclone/Model/Product.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/Buying/ShowProducts.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/custom_shape.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vibrate/vibrate.dart';

import 'Widgets/FarmInput/ViewChat.dart';

class BuyerUI extends StatefulWidget {
  List BuyerDetails;

  BuyerUI(this.BuyerDetails);

  @override
  _BuyerUIState createState() => _BuyerUIState();
}

class _BuyerUIState extends State<BuyerUI> with SingleTickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool isExpanded = false;
  List<Category> categoryItems;
  List<Product> trendingListItems;
  List<Product> recommendListItems;
  List<Product> dealsListItems;
  TabController tabController;
  double _height;
  double _width;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    print(widget.BuyerDetails[0]["id"]);
    super.initState();

    trendingListItems = [];
    recommendListItems = [];
    dealsListItems = [];
    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      print("From Buyer");
      print("Message: $message");
      final snackBarz = SnackBar(
        content: Text(message['notification']['title']),
        action: SnackBarAction(
            label: "View",
            onPressed: () {
            }),
      );
      final Iterable<Duration> pauses = [
        const Duration(milliseconds: 200),
      ];
      Vibrate.vibrateWithPauses(pauses);
      Scaffold.of(context).showSnackBar(snackBarz);
    });
  }

  void _expand() {
    setState(() {
      isExpanded ? isExpanded = false : isExpanded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery
        .of(context)
        .size
        .height;
    _width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      bottomNavigationBar: _bottomNavBar(),
      key: scaffoldKey,
      drawer: _drawer(),
//      floatingActionButton: FloatingActionButton.extended(
//        elevation: 3,
//        onPressed: () {},
//        backgroundColor: Colors.orange[200],
//        icon: Icon(Icons.camera_alt),
//        label: Text(
//          "Post AD",
//          textAlign: TextAlign.center,
//          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//        ),
//      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          Container(
            height: _height,
            width: _width,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  clipShape(),
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Shop for', style: TextStyle(fontSize: 16)),
                        GestureDetector(
                            onTap: _expand,
                            child: Text(
                              isExpanded ? "Show less" : "Show all",
                              style: TextStyle(
                                color: Colors.orange[200],
                              ),
                            )),
                        //IconButton(icon: isExpanded? Icon(Icons.arrow_drop_up, color: Colors.orange[200],) : Icon(Icons.arrow_drop_down, color: Colors.orange[200],), onPressed: _expand)
                      ],
                    ),
                  ),
                  expandList(),
                  Divider(),
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Trending", style: TextStyle(fontSize: 16)),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return ShowProduct(widget.BuyerDetails);
                                  }));
                            },
                            child: Text(
                              'Show all',
                              style: TextStyle(
                                color: Colors.orange[300],
                              ),
                            ))
                      ],
                    ),
                  ),
                  trendingProducts(),
                ],
              ),
            ),
          ),
          Scaffold(
              appBar: AppBar(
                title: Text("Chats"),
              ),
              body: ListView.builder(
                itemCount: widget.BuyerDetails[0]["buyerChats"].length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 70,
                    color: Colors.grey[50],
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return ViewChat(
                                widget.BuyerDetails[0]["buyerChats"][index]
                                ["partyB"],
                                widget.BuyerDetails[0]["buyerChats"][index]
                                ["docId"],
                              );
                            }));
                          },
                          dense: true,
                          title: Text(widget.BuyerDetails[0]["buyerChats"]
                          [index]["partyB"]["name"]),
                        ),
                        Divider(),
                      ],
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Opacity(
            opacity: 0.75,
            child: Container(
              height: _height / 6,
              padding: EdgeInsets.only(top: _height / 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.black,
                  ),
                  radius: 30,
                  backgroundColor: Colors.white,
                ),
                title: Text("FlutterDevs"),
                subtitle: Text(
                  "flutterDevs@aeologic.com",
                  style: TextStyle(fontSize: 13),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders & Payments"),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavBar() {
    return new Material(
      child: new TabBar(
        controller: tabController,
        tabs: <Widget>[
          new Tab(icon: Icon(Icons.home)),
          new Tab(icon: Icon(Icons.message))
        ],
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _height / 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _height / 3.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.25,
          child: ClipPath(
            clipper: CustomShapeClipper3(),
            child: Container(
              height: _height / 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 40, right: 40, top: _height / 3.75),
          child: Material(
            borderRadius: BorderRadius.circular(30.0),
            elevation: 8,
            child: Container(
              child: TextFormField(
                cursorColor: Colors.orange[200],
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  prefixIcon:
                  Icon(Icons.search, color: Colors.orange[200], size: 30),
                  hintText: "What're you looking for?",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
        ),
        Container(
          //color: Colors.blue,
            margin: EdgeInsets.only(left: 20, right: 20, top: _height / 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Opacity(
                  opacity: 0.5,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: GestureDetector(
                        onTap: () {
                          scaffoldKey.currentState.openDrawer();
                        },
                        child: Image.asset(
                          'assets/images/menubutton.png',
                          height: _height / 40,
                        )),
                  ),
                ),
                Flexible(
                  child: Container(
                    height: _height / 20,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            print('Editing location');
                          },
                          child: Icon(
                            Icons.edit_location,
                            color: Colors.white,
                            size: _height / 40,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: Text('Nairobi',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: _height / 50),
                                // overflow: TextOverflow.fade,
                                softWrap: false)),
                      ],
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.5,
                  child: GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.notifications,
                        color: Colors.black,
                        size: _height / 30,
                      )),
                ),
              ],
            )),
      ],
    );
  }

  Widget expandList() {
    final String query = r'''
          query{
            categories{
              id
              name
              image
            }
          }
      ''';
    List<Categ> categories = new List<Categ>();

    List<Categ> loadCategories(List counties) {
      return counties.map<Categ>((json) => Categ.fromJson(json)).toList();
    }

    return Query(
        options: QueryOptions(document: query),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (result.data == null) {
            return Center(
              child: Text("Check Internet Connection"),
            );
          } else {
//            print(result.data.data["categories"]);
            categories = loadCategories(result.data.data["categories"]);
//            print(categories.length);
            return AnimatedCrossFade(
                firstChild: GridView.count(
                  crossAxisCount: 2,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: categories.take(6).map((Categ categ) {
                    return Card(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                                return ShowProduct(widget.BuyerDetails,
                                    name: categ.name);
                              }));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.network(
                              "${categ.image}",
                              height: _height / 6,
                              fit: BoxFit.fitWidth,
                            ),
                            Flexible(child: Text(categ.name))
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                secondChild: GridView.count(
                  crossAxisCount: 2,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: categories.map((Categ categ) {
                    return Card(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                                return ShowProduct(widget.BuyerDetails,
                                    name: categ.name);
                              }));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.network(
                              "${categ.image}",
                              height: _height / 6,
                              fit: BoxFit.fitWidth,
                            ),
                            Flexible(child: Text(categ.name))
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: kThemeAnimationDuration);
          }
        });
  }

  Widget trendingProducts() {
    final String query = r'''
          query{
              products(first: 20){
              id
              name
              image
            }
          }
      ''';
    List<Product> products = List<Product>();
    List<Product> loadProducts(List prods) {
      return prods.map<Product>((json) => Product.fromJson(json)).toList();
    }

    return Query(
      options: QueryOptions(document: query),
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (result.data == null) {
          return Center(
            child: Text("No Data Found "),
          );
        } else {
          List Fproducts = result.data.data["products"];
          Fproducts.sort((a, b) => a["name"].compareTo(b["name"]));
          print(Fproducts.length);
          return Container(
            height: _height / 5,
            child: ListView.builder(
              itemCount: Fproducts.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, index) {
                Product product = Product.fromJson(Fproducts[index]);
                return Container(
                  width: _width / 2.50,
                  child: Card(
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.network(
                              "${product.image}",
                              height: _height / 8.5,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(product.name)
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
