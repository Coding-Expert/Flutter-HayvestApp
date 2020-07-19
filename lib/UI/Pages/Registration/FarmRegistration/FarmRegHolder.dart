import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/Model/county.dart';
import 'package:flutter_classifiedappclone/UI/Pages/Registration/FarmRegistration/FarmRegistrationForm.dart';
import 'package:flutter_classifiedappclone/UI/Pages/Registration/FarmRegistration/FarmRegistrationPackages.dart';
import 'package:graphql/client.dart';

class FarmRegHolder extends StatefulWidget {
  List<Place> counties =List<Place>();
  Map<String, dynamic> farmDetail = Map<String, dynamic>();
  FarmRegHolder(this.counties);

  @override
  _FarmRegHolderState createState() => _FarmRegHolderState();
}



class _FarmRegHolderState extends State<FarmRegHolder>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<Place> counties = List<Place>();

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
    return Scaffold(
      body: TabBarView(
        children: <Widget>[FarmRegistration(tabController, widget.counties, widget.farmDetail), FarmRegPackage(widget.farmDetail)],
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
