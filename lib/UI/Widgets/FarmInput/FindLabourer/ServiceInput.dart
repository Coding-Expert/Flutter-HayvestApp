import 'package:flutter/material.dart';

class ServiceDetail extends StatefulWidget {
  Map<String, dynamic> service;

  ServiceDetail(this.service);

  @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  TextEditingController personController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController payController = TextEditingController();
  List<String> duration = ["Days", "Weeks", "Months"];
  String initValue = "Days";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Service Details"),
      ),
      body: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 8, right: 8, top: 20, bottom: 10),
              child: new Theme(
                data: new ThemeData(
                  primaryColor: Colors.blueGrey[500],
                  primaryColorDark: Colors.blueGrey[700],
                ),
                child: new TextField(
                  controller: personController,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: new BorderSide(
                            color: Colors.blueGrey[700],
                            width: 2,
                            style: BorderStyle.solid)),
                    hintText: "Number of People Required",
                    labelText: "Number of Laboures",
                    prefixIcon: Icon(
                      Icons.people,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Period of Work"),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
            child: Theme(
              data: new ThemeData(
                primaryColor: Colors.blueGrey[500],
                primaryColorDark: Colors.blueGrey[700],
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                elevation: 5,
                value: initValue,
                onChanged: (String val) {
                  this.setState(() {
                    initValue = val;
                  });
                },
                items: duration.map<DropdownMenuItem<String>>((String period) {
                  return DropdownMenuItem<String>(
                    key: Key("key${period}"),
                    value: period,
                    child: Text(" ${period}"),
                  );
                }).toList(),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[Divider()],
          ),
          Container(
              padding: EdgeInsets.only(left: 8, right: 8, top: 20, bottom: 10),
              child: new Theme(
                data: new ThemeData(
                  primaryColor: Colors.blueGrey[500],
                  primaryColorDark: Colors.blueGrey[700],
                ),
                child: new TextField(
                  controller: durationController,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: new BorderSide(
                            color: Colors.blueGrey[700],
                            width: 2,
                            style: BorderStyle.solid)),
                    hintText: "Number of ${initValue}",
                    labelText: "Number of ${initValue}",
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              )),
          Container(
              padding: EdgeInsets.only(left: 8, right: 8, top: 20, bottom: 10),
              child: new Theme(
                data: new ThemeData(
                  primaryColor: Colors.blueGrey[500],
                  primaryColorDark: Colors.blueGrey[700],
                ),
                child: new TextField(
                  controller: payController,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: new BorderSide(
                            color: Colors.blueGrey[700],
                            width: 2,
                            style: BorderStyle.solid)),
                    hintText:
                        "Pay per ${initValue.substring(0, initValue.length - 1)}",
                    labelText:
                        "Pay per ${initValue.substring(0, initValue.length - 1)}",
                    prefixIcon: Icon(
                      Icons.fiber_smart_record,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              )),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton.extended(
                backgroundColor: Colors.greenAccent,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  label: Text("Complete"))
            ],
          )
        ],
      ),
    );
  }
}
