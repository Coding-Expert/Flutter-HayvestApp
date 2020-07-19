import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/Model/BuyerPackages.dart';
import 'package:flutter_classifiedappclone/UI/FarmUI.dart';
import 'package:flutter_classifiedappclone/UI/Pages/Registration/FarmRegistration/Custom_Icons.dart';
import 'package:flutter_classifiedappclone/UI/Pages/Registration/BuyerRegistration/data.dart';
import 'package:flutter_classifiedappclone/UI/main_ui.dart';
import 'package:graphql/client.dart';

class BuyerRegPackage extends StatefulWidget {
  Map<String, dynamic> buyerDetails;

  BuyerRegPackage(this.buyerDetails);

  @override
  _BuyerRegPackageState createState() => new _BuyerRegPackageState();
}

class _BuyerRegPackageState extends State<BuyerRegPackage> {
  int _currentIndex = 0;
  List<BuyerPackages> packages = List<BuyerPackages>();
  bool stillLoading = true;
  int id;
  String user_id;

  get_user_id() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user_id = user.uid;
    final String query = r""" 
                query get_user($uid: String!){
                  members(uid: $uid){
                    id
                    uid
                    phoneNumber
                    farms{
                      id
                    }
                    buyingProfile{
                      id
                    }
                  }
                } """;

    final HttpLink _htppLink =
    HttpLink(uri: "http://34.76.96.215:8000/graphql/");
    final GraphQLClient client =
    GraphQLClient(link: _htppLink, cache: InMemoryCache());
    final QueryOptions options =
    QueryOptions(document: query, variables: {"uid": user_id});
    final response = await client.query(options);
    if (response.errors != null) {
      print("errors Found");
    }
    if (response.data == null) {
      print("Null data");
    } else {
      id = int.parse(response.data["members"][0]["id"]);
      print("The id: $id");
    }
  }

  Future getPackages() async {
    final HttpLink _htppLink =
        HttpLink(uri: "http://34.76.96.215:8000/graphql/");
    final GraphQLClient client =
        GraphQLClient(link: _htppLink, cache: InMemoryCache());
    final String query = r'''
          query{
            buyerPackages{
              id
              name
              searches
              totalBidPlaced
              broadCastAbility
              price
              period{
                id
                name
                numberOfDays
              }
            }
          }
      ''';
    final QueryOptions options = QueryOptions(document: query);
    final response = await client.query(options);
    if (response.errors != null) {
      print("errors Found");
    }
    if (response.data == null) {
      print("Null data");
    } else {
      packages = loadPackages(response.data["buyerPackages"]);
      packages.sort((a, b) => a.price.compareTo(b.price));
      setState(() {
        stillLoading = false;
      });
    }
  }

  static List<BuyerPackages> loadPackages(List packages) {
    return packages
        .map<BuyerPackages>((json) => BuyerPackages.fromJson(json))
        .toList();
  }

  Widget _buildGradientContainer(double width, double height) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: width * .8,
        height: height / 2,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFfbfcfd), Color(0xFFf2f3f8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 1.0])),
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 40.0,
      left: 20.0,
      right: 20.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _buildTitle(double height) {
    return Positioned(
      top: height * .2,
      left: 30.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Buyer Packages",
              style: TextStyle(fontSize: 28.0, fontFamily: "Montserrat-Bold")),
          Text("Choose a package that suits your profile",
              style: TextStyle(fontSize: 16.0, fontFamily: "Montserrat-Medium"))
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    get_user_id();
    print("Buyer details");
    print(widget.buyerDetails);
    getPackages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return stillLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Color(0xFFf2f3f8),
            resizeToAvoidBottomPadding: false,
            body: LayoutBuilder(
              builder: (context, constraints) {
                var width = constraints.maxWidth;
                var height = constraints.maxHeight;

                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    _buildGradientContainer(width, height),
                    _buildAppBar(),
                    _buildTitle(height),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: height * .6,
                        child: ListView.builder(
                          itemCount: packages.length,
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(left: 35.0, bottom: 60.0),
                              child: SizedBox(
                                width: 200.0,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 45.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: (index % 2 == 0)
                                                ? Colors.white
                                                : Color(0xFF2a2d3f),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  offset: Offset(0.0, 10.0),
                                                  blurRadius: 10.0)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(12.0)),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 50,
                                              ),
                                              Text(packages[index].name,
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontFamily:
                                                          "Montserrat-Bold",
                                                      color: (index % 2 == 0)
                                                          ? Color(0xFF2a2d3f)
                                                          : Colors.white)),
                                              SizedBox(
                                                height: 12.0,
                                              ),
                                              Text("Features:",
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontFamily:
                                                          "Montserrat-Medium",
                                                      color: (index % 2 == 0)
                                                          ? Color(0xFF2a2d3f)
                                                          : Colors.white)),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                  "Search Items: ${packages[index].Searches.toString()}",
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontFamily:
                                                          "Montserrat-Medium",
                                                      color: (index % 2 == 0)
                                                          ? Color(0xFF2a2d3f)
                                                          : Colors.white)),
                                              Text(
                                                  "Bids Placed: ${packages[index].totalBidsPlaced}",
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontFamily:
                                                          "Montserrat-Medium",
                                                      color: (index % 2 == 0)
                                                          ? Color(0xFF2a2d3f)
                                                          : Colors.white)),
                                              Text(
                                                  "Able to BroadCast: ${packages[index].broadCastAbility.toString()}",
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontFamily:
                                                          "Montserrat-Medium",
                                                      color: (index % 2 == 0)
                                                          ? Color(0xFF2a2d3f)
                                                          : Colors.white)),
                                              Text(
                                                  "Valid for: ${packages[index].period.numberOfDays} days",
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontFamily:
                                                          "Montserrat-Medium",
                                                      color: (index % 2 == 0)
                                                          ? Color(0xFF2a2d3f)
                                                          : Colors.white)),
                                              SizedBox(
                                                height: 50.0,
                                              ),
                                              Text(
                                                  packages[
                                                              index]
                                                          .price
                                                          .toString() +
                                                      " KSh/Mnth",
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontFamily:
                                                          "Montserrat-Bold",
                                                      color: (index % 2 == 0)
                                                          ? Color(0xFF2a2d3f)
                                                          : Colors.white)),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  new RaisedButton(
                                                      child:
                                                          new Text("Join Now"),
                                                      color: Color(0xFFFF9945),
                                                      onPressed: () {
                                                        addBuyer(packages[index]);
                                                      },
                                                      shape: new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  30.0)))
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          );
  }

  void choicePayment(double Price, List Buyer) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 45,
                      child:
                          Image(image: AssetImage("assets/images/mpesa.jpg")),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text("Phone number to charge ${Price}: "),
                    SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 20,
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                    color: Colors.blueGrey,
                                    width: 10,
                                    style: BorderStyle.solid)),
                            hintText: "Mpesa phone number",
                            labelText: "Mpesa Number"),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                            color: Colors.orangeAccent[200],
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return BuyerUI(Buyer);
                              }));
                            },
                            child: Text("Complete Registration"))
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  void addBuyer(BuyerPackages package) async {
    final String mutateQuery = r'''mutation postFarm($county: Int!, 
                               $lat: Float!, 
                               $lon: Float!, 
                               $name: String!, 
                               $ownerId: Int!, 
                               $packageId: Int!) {
          createBuyer(countyId: $county,
                     latitude: $lat, 
                     longitude: $lon, 
                     name: $name, 
                     ownerId: $ownerId, 
                     packageId: $packageId) {
            buyer{
              id
              name
              latitude
              longitude
              name
              buyerChats{
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
              
            }
          }
        }''';
    final HttpLink _htppLink =
    HttpLink(uri: "http://34.76.96.215:8000/graphql/");
    final GraphQLClient client =
    GraphQLClient(link: _htppLink, cache: InMemoryCache());
    final QueryOptions options = QueryOptions(document: mutateQuery, variables:{
      "lat": widget.buyerDetails["lat"],
      "lon": widget.buyerDetails["lon"],
      "name": widget.buyerDetails["name"],
      "county": widget.buyerDetails["county_id"],
      "ownerId": this.id,
      "packageId": package.id
    });

    final response = await client.query(options);
    if(response.errors !=null){
      print("Sorry an Error occured");
    }
    if(response.data ==null){
      print("Posting failed");
    }else {
      if (package.price.toDouble() == 0.00) {
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return BuyerUI(response.data["buyer"]);
        }));
      } else {
        choicePayment(package.price.toDouble(), response.data["buyer"]);
      }
    }
  }
}
