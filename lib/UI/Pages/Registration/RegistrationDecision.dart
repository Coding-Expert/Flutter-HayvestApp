import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/Model/county.dart';
import 'package:flutter_classifiedappclone/UI/Pages/Registration/BuyerRegistration/BuyerRegHolder.dart';
import 'package:flutter_classifiedappclone/UI/Pages/Registration/FarmRegistration/FarmRegHolder.dart';
import 'package:flutter_classifiedappclone/UI/Pages/Registration/RegDecisionData.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class RegDecision extends StatelessWidget {
  int _currentIndex = 0;
  List<Place> counties = List<Place>();

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

  void getCounty() async {
    final HttpLink _htppLink =
        HttpLink(uri: "http://34.76.96.215:8000/graphql/");
    final GraphQLClient client =
        GraphQLClient(link: _htppLink, cache: InMemoryCache());
    final String query = r'''
          query{
            counties{
              id
              name
              wards{
                id
                name
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
      counties = loadCounties(response.data["counties"]);
    }
  }

  static List<Place> loadCounties(List counties) {
    return counties.map<Place>((json) => Place.fromJson(json)).toList();
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
          Text("Choose your Profile",
              style: TextStyle(fontSize: 28.0, fontFamily: "Montserrat-Bold")),
          Text("How would you like to use the platform",
              style: TextStyle(fontSize: 16.0, fontFamily: "Montserrat-Medium"))
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    getCounty();
    return Scaffold(
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
                    itemCount: dummyData.length,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(left: 35.0, bottom: 60.0),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                        Text(dummyData[index].Name,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: "Montserrat-Bold",
                                                color: (index % 2 == 0)
                                                    ? Color(0xFF2a2d3f)
                                                    : Colors.white)),
                                        SizedBox(
                                          height: 80.0,
                                        ),
                                        Text("${dummyData[index].Description}",
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontFamily: "Montserrat-Medium",
                                                color: (index % 2 == 0)
                                                    ? Color(0xFF2a2d3f)
                                                    : Colors.white)),
                                        SizedBox(
                                          height: 100.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            new RaisedButton(
                                                child: new Text("Continue"),
                                                color: Color(0xFFFF9945),
                                                onPressed: () {
                                                  if (dummyData[index].Name ==
                                                      "Farmer") {
                                                    print(counties);
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return FarmRegHolder(counties);
                                                    }));
                                                  }
                                                  if (dummyData[index].Name ==
                                                      "Buyer") {
                                                    print("Buyer Here");
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return BuyerRegHolder();
                                                    }));
                                                  }
                                                },
                                                shape:
                                                    new RoundedRectangleBorder(
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
}
