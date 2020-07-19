import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Responsible for displaying a filter list at the top of menu page
class FilterLst extends StatelessWidget {
  final list = ["Cheese", "Chicken", "Fish", "Vegetarian", "Bacon"];

  Widget build(BuildContext context) {
    return new Container(
        height: 60,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (context, position) {

              // For each item in filter list
              return new Container(
                  margin: EdgeInsets.all(10),
                  child: new RaisedButton(

                    // Adding the name of the filter
                    child: new Text(list[position],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor)),
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(10),

                    // You can add your filter logic here
                    onPressed: () {},
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                  ));
            }));
  }
}
