import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/Model/Farm.dart';
import 'package:flutter_classifiedappclone/Model/SaleProduct.dart';
import 'package:flutter_classifiedappclone/Model/categoryModel.dart';
import 'package:flutter_classifiedappclone/Model/productModel.dart';
import 'package:flutter_classifiedappclone/Model/itemModel.dart';
import 'package:flutter_classifiedappclone/UI/Deciders/BusinessDecider.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/FarmInput/AddItem.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/FarmInput/FindLabourer/SelectFarmService.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/FarmInput/ViewChat.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/customItemUI.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/custom_shape.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/mainui_customcard.dart';
import 'package:graphql/client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vibrate/vibrate.dart';

class FarmUI extends StatefulWidget {
  String uid;

  FarmUI(this.uid);

  @override
  _FarmUIState createState() => _FarmUIState();
}

class _FarmUIState extends State<FarmUI> with SingleTickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseUser User;
  bool isExpanded = false;
  List<Category> categoryItems;
  List<Item> farmItems;
  List<Sales> farmsales;
  double _height;
  double _width;
  Farm thiFarm;
  bool loading = true;
  TabController tabController;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future getUserFarm() async {
    String uid = widget.uid;
    print("****************************");
    print(uid);
    print("****************************");
    final String query = r""" 
                query get_user($phone: String!){
                   members(phone: $phone){
                      id
                      uid
                      farms{
                        id
                        name
                        latitude
                        longitude
                        packageUpdateDate
                        county{
                          id
                          name
                          wards{
                            id
                            name
                          }
                        }
                        farmChats{
                          id
                          partyA{
                            id
                            name
                          }
                          partyB{
                            id
                            name
                          }
                          docId
                        }
                        sales{
                          id
                          price
                          amount
                          unit{
                            id
                            name
                            alternativeName
                          }
                          product{
                            id
                            name
                            alternativeName
                            image
                            unitsOfMeasure{
                              id
                              name
                              alternativeName
                            }
                          }
                        }
                        package{
                          id
                          name
                          period{
                            id
                            name
                            numberOfDays
                          }
                        }
                      }
                   }
                } """;

    final HttpLink _htppLink =
        HttpLink(uri: "http://34.76.96.215:8000/graphql/");
    final GraphQLClient client =
        GraphQLClient(link: _htppLink, cache: InMemoryCache());
    final QueryOptions options =
        QueryOptions(document: query, variables: {"phone": uid});
    final response = await client.query(options);
    if (response.errors != null) {
      print("errors Found");
    }
    if (response.data == null) {
      print("Null data");
    } else {
      var member = response.data["members"][0];
      print("the sales");
      print(member["farms"][0]["sales"]);
      thiFarm = Farm.fromJson(member["farms"][0]);
      farmsales = member["farms"][0]["sales"]
          .map<Sales>((json) => Sales.fromJson(json))
          .toList();
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserFarm();
    tabController = TabController(length: 2, vsync: this);
    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      getUserFarm();
      print("Message: $message");
      final snackBar = SnackBar(
        content: Text(message['notification']['title']),
        action: SnackBarAction(
            label: "View",
            onPressed: () {
              print("Pressed");
              tabController.animateTo(1, duration: Duration(milliseconds: 300));
            }),
      );
      final Iterable<Duration> pauses = [
        const Duration(milliseconds: 200),
      ];
      Vibrate.vibrateWithPauses(pauses);
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _expand() {
    setState(() {
      isExpanded ? isExpanded = false : isExpanded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            bottomNavigationBar: _bottomNavBar(),
            key: scaffoldKey,
            drawer: _drawer(),
            body: TabBarView(
              controller: tabController,
              children: <Widget>[
                Scaffold(
                  floatingActionButton: new Builder(
                    builder: (BuildContext context) {
                      return FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return AddItem(thiFarm);
                          }));
                        },
                        backgroundColor: Colors.orange[200],
                        child: Icon(Icons.add),
                      );
                    },
                  ),
                  body: RefreshIndicator(
                    onRefresh: getUserFarm,
                    child: Container(
                      height: _height,
                      width: _width,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            clipShape(),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 30, right: 30, top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Products you are Selling",
                                      style: TextStyle(fontSize: 16)),
                                  GestureDetector(
                                      onTap: () {
                                        //Navigator.of(context).pushNamed(DEALS_UI);
                                        setState(() {
                                          getUserFarm();
                                        });
                                      },
                                      child: Icon(
                                        Icons.refresh,
                                        color: Theme.of(context).primaryColor,
                                      ))
                                ],
                              ),
                            ),
                            expandList()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Scaffold(
                    appBar: AppBar(
                      title: Text("Chats"),
                    ),
                    body: ListView.builder(
                      itemCount: thiFarm.chats.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 70,
                          color: Colors.grey[50],
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return ViewChat(
                                      thiFarm.chats[index]["partyA"],
                                      thiFarm.chats[index]["docId"],
                                      farm: true,
                                    );
                                  }));
                                },
                                dense: true,
                                title: Text(
                                    thiFarm.chats[index]["partyA"]["name"]),
                              ),
                              Divider(),
                            ],
                          ),
                        );
                      },
                    ))
              ],
            ),
          );
  }

  Widget _drawer() {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
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
                    title: Text("${thiFarm.name}"),
                    subtitle: Text(
                      "${thiFarm.county.name}",
                      style: TextStyle(fontSize: 13),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              ExpansionTile(
                initiallyExpanded: true,
                title: Text("Find Services"),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.assignment_ind),
                    title: Text("Find Labour"),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return SelectFarmService();
                      }));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.assignment_turned_in),
                    title: Text("Find Services"),
                    onTap: () {},
                  )
                ],
              ),
              ExpansionTile(
                title: Text("Profiles"),
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.domain,
                    ),
                    title: Text("Buyer Profile"),
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return new BusinessDecider();
                      }));
                    },
                  ),
                  ListTile(
                    title: Text("Labour Profile"),
                    leading: Icon(Icons.perm_identity),
                    onTap: () {},
                  )
                ],
              )
            ],
          ),
          ListTile(
            leading: Icon(Icons.power_settings_new),
            title: Text("Logout"),
            onTap: () => FirebaseAuth.instance.signOut(),
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
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  thiFarm.name,
                  style: TextStyle(fontSize: 25),
                ),
              ],
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
                            child: Text(thiFarm.county.name,
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
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: AnimatedCrossFade(
        firstChild: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            children: farmsales.map((item) {
              return CustomItemCard(item);
            }).toList()),
        secondChild: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 4,
          children: <Widget>[],
        ),
        crossFadeState:
            isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: kThemeAnimationDuration,
      ),
    );
  }
}
