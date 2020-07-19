import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/Model/county.dart';
import 'package:flutter_classifiedappclone/UI/Pages/Registration/BuyerRegistration/BuyerRegistrationForm.dart';
import 'package:flutter_classifiedappclone/UI/Pages/Registration/BuyerRegistration/BuyerRegistrationPackages.dart';
import 'package:graphql/client.dart';

class BuyerRegHolder extends StatefulWidget {
  Map<String, dynamic> buyerDetails = Map<String, dynamic>();

  @override
  _BuyerRegHolderState createState() => _BuyerRegHolderState();
}

class _BuyerRegHolderState extends State<BuyerRegHolder>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<Place> counties = List<Place>();
  bool loading = true;

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
      setState(() {
        loading = false;
      });
    }
  }

  static List<Place> loadCounties(List counties) {
    return counties.map<Place>((json) => Place.fromJson(json)).toList();
  }

  @override
  void initState() {

    tabController = new TabController(length: 2, vsync: this);
    getCounty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: TabBarView(
              children: <Widget>[
                BuyerRegistration(tabController, counties, widget.buyerDetails),
                BuyerRegPackage(widget.buyerDetails)
              ],
              controller: tabController,
            ),
          );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
