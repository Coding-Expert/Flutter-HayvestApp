import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/Model/Ward.dart';
import 'package:flutter_classifiedappclone/Model/county.dart';
import 'package:flutter_classifiedappclone/UI/Pages/MapSelect.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql/client.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class FarmRegistration extends StatefulWidget {
  final TabController controller;
  List<Place> counties = List<Place>();
  Map<String, dynamic> farm_details = Map<String, dynamic>();

  FarmRegistration(this.controller, this.counties, this.farm_details);

  @override
  _FarmRegistrationState createState() => _FarmRegistrationState();
}

class _FarmRegistrationState extends State<FarmRegistration> {
  String Name;
  int County;
  int Price;
  Position position;
  Position FarmPosition;
  AutoCompleteTextField countySearch;
  TextEditingController FarmNameController = new TextEditingController();
  TextEditingController CountyNameController = new TextEditingController();
  bool countyEmpty = false;
  bool nameEmpty = false;
  GlobalKey<AutoCompleteTextFieldState<Place>> Ckey = GlobalKey();
  Place SelectedCounty = null;

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
      var counties = loadCounties(response.data["counties"]);
    }
  }

  static List<Place> loadCounties(List counties) {
    return counties.map<Place>((json) => Place.fromJson(json)).toList();
  }

  Future<void> getCurrentLocation() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    print(position.longitude);
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getCounty();
  }

  @override
  Widget build(BuildContext context) {
    List<Place> counties = widget.counties;
    return Scaffold(
      appBar: AppBar(
        elevation: null,
        backgroundColor: Colors.white,
        title: Text("Register Your Farm"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
            child: Text(
              "Register Your Farm",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
              child: new Theme(
                data: new ThemeData(
                  primaryColor: Colors.blueGrey[500],
                  primaryColorDark: Colors.blueGrey[700],
                ),
                child: new TextField(
                  controller: FarmNameController,
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: new BorderSide(
                              color: Colors.blueGrey[700],
                              width: 2,
                              style: BorderStyle.solid)),
                      hintText: "Name",
                      labelText: "Farm Name",
                      errorText: nameEmpty ? "Input Farm Name" : null,
                      prefixIcon: Icon(
                        Icons.label,
                        color: Colors.blueGrey,
                      )),
                ),
              )),
          CountyAutoCOmplete(counties),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                child: (SelectedCounty == null)
                    ? null
                    : DropdownButton<Ward>(
                        value: SelectedCounty.wards[0],
                        items: SelectedCounty.wards.map<DropdownMenuItem<Ward>>((ward) {
                          return DropdownMenuItem(
                            child: Text(ward.name),
                            value: ward,
                          );
                        }).toList(),
                        onChanged: (w){
                          print(w.name);
                        })),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FlatButton(
                    color: Colors.orangeAccent,
                    onPressed: () {
                      if (checkFilled()) {
                        widget.controller.animateTo(widget.controller.index + 1,
                            duration: Duration(seconds: 1));
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        Text("Continue"),
                        Icon(Icons.arrow_forward)
                      ],
                    )),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget CountyAutoCOmplete(List<Place> counties) {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
        child: new Theme(
            data: new ThemeData(
              primaryColor: Colors.blueGrey[500],
              primaryColorDark: Colors.blueGrey[700],
            ),
            child: countySearch = AutoCompleteTextField<Place>(
              key: Ckey,
              clearOnSubmit: false,
              suggestions: counties,
              controller: CountyNameController,
              style: TextStyle(color: Colors.black87, fontSize: 16.0),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: new BorderSide(
                          color: Colors.blueGrey[700],
                          width: 2,
                          style: BorderStyle.solid)),
                  hintText: "County Eg Kiambu County",
                  labelText: "County",
                  errorText: countyEmpty ? "Choose your County" : null,
                  prefixIcon: Icon(
                    Icons.room,
                    color: Colors.blueGrey,
                  )),
              itemFilter: (item, query) {
                return item.name.toLowerCase().startsWith(query.toLowerCase());
              },
              itemSorter: (a, b) {
                return a.name.compareTo(b.name);
              },
              itemSubmitted: (item) {
                this.setState(() {
                  countySearch.textField.controller.text = item.name;
                  setState(() {
                    SelectedCounty = item;
                  });
                });
              },
              itemBuilder: (context, county) {
                return Row(
                  children: <Widget>[Text(county.name), Divider()],
                );
              },
            )));
  }

  bool checkFilled() {
    if (FarmNameController.text.isEmpty ||
        countySearch.textField.controller.text.isEmpty) {
      if (FarmNameController.text.isEmpty) {
        setState(() {
          nameEmpty = true;
        });
      }
      if (countySearch.textField.controller.text.isEmpty) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please Fill in the snackbar"),
          duration: Duration(seconds: 3),
          elevation: 5.0,
        ));
        setState(() {
          countyEmpty = true;
        });
      }
      return false;
    } else {
      Place county = widget.counties.firstWhere(
          (place) => place.name == countySearch.textField.controller.text);
      widget.farm_details["county_id"] = county.id;
      widget.farm_details["name"] = FarmNameController.text;
      widget.farm_details['lat'] = position.latitude;
      widget.farm_details['lon'] = position.longitude;
      print(widget.farm_details);
      return true;
    }
  }
}
