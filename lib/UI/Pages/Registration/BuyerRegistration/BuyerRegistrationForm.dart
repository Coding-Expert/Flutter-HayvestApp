import 'dart:async';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/Model/county.dart';
import 'package:flutter_classifiedappclone/UI/Pages/MapSelect.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql/client.dart';

class BuyerRegistration extends StatefulWidget {
  final TabController controller;
  List<Place> counties = List<Place>();
  Map<String, dynamic> buyerDetails;

  BuyerRegistration(this.controller, this.counties, this.buyerDetails);

  @override
  _BuyerRegistrationState createState() => _BuyerRegistrationState();
}

class _BuyerRegistrationState extends State<BuyerRegistration> {
  String Name;
  int County;
  int Price;
  Position position;
  Position FarmPosition;
  AutoCompleteTextField countySearch;
  TextEditingController BuyerNameController = new TextEditingController();
  TextEditingController CountyNameController = new TextEditingController();
  bool countyEmpty = false;
  bool nameEmpty = false;
  GlobalKey<AutoCompleteTextFieldState<Place>> Ckey = GlobalKey();

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
  }

  @override
  Widget build(BuildContext context) {
    List<Place> counties = widget.counties;
    print("Here are the Counties");
    print(counties.length);
    return Scaffold(
      appBar: AppBar(
        elevation: null,
        backgroundColor: Colors.white,
        title: Text("Setup your Buyer Profile"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
            child: Text(
              "Setup your Buyer Profile",
              style: TextStyle(
                fontSize: 20,
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
                  controller: BuyerNameController,
                  onChanged: (String name) {
                    Name = name;
                    print(Name);
                  },
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: new BorderSide(
                              color: Colors.blueGrey[700],
                              width: 2,
                              style: BorderStyle.solid)),
                      hintText: "Name",
                      labelText: "Buyer Name(s)",
                      errorText: nameEmpty? "This field cannot be null" : null,
                      prefixIcon: Icon(
                        Icons.label,
                        color: Colors.blueGrey,
                      )),
                ),
              )),
          Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
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
                      return item.name
                          .toLowerCase()
                          .startsWith(query.toLowerCase());
                    },
                    itemSorter: (a, b) {
                      return a.name.compareTo(b.name);
                    },
                    itemSubmitted: (item) {
                      this.setState(() {
                        countySearch.textField.controller.text = item.name;
                      });
                    },
                    itemBuilder: (context, county) {
                      return Row(
                        children: <Widget>[Text(county.name), Divider()],
                      );
                    },
                  ))),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.orangeAccent[200],
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return SelectMap(position);
                      },
                      fullscreenDialog: true));
                },
                child: Row(
                  children: <Widget>[Icon(Icons.room), Text("Select Location")],
                ),
              ),
            ),
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

  bool checkFilled() {
    if (BuyerNameController.text.isEmpty ||
        countySearch.textField.controller.text.isEmpty) {
      if (BuyerNameController.text.isEmpty) {
        setState(() {
          nameEmpty = true;
        });
      }
      if (countySearch.textField.controller.text.isEmpty) {
        print("null");
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please Fill in your county"),
          duration: Duration(seconds: 3),
          elevation: 5.0,
        ));
        setState(() {
          countyEmpty = true;
        });
      }
      return false;
    } else {
      nameEmpty = false;
      print(countySearch.textField.controller.text);
      Place county = widget.counties.firstWhere(
          (place) => place.name == countySearch.textField.controller.text);
      widget.buyerDetails["county_id"] = county.id;
      widget.buyerDetails["name"] = BuyerNameController.text;
      widget.buyerDetails['lat'] = position.latitude;
      widget.buyerDetails['lon'] = position.longitude;
      return true;
    }
  }
}
