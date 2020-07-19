import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/UI/models/Order.dart';

// Represents one row (one sandwich) in cart page
class CartItemList extends StatelessWidget {
  final Order order;
  CartItemList({Key key, this.order}) : super(key: key);

  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.only(right: 15),
        width: double.infinity,
        child: new Row(children: <Widget>[
          new SizedBox(
              height: 100,
              width: 30,
              child: new Stack(children: <Widget>[
                // Represents the line (flow) beside each sandwich
                new Container(
                    margin: EdgeInsets.only(left: 4),
                    height: 100,
                    width: 2,
                    color: Theme.of(context).primaryColor),

                // Represents the dot in each line
                new Container(
                    margin: EdgeInsets.only(top: 40),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor),
                    width: 10,
                    height: 10)
              ])),
          new Expanded(
              child: new Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        // Sandwich title
                        new Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: new Text("${order.item.title}".toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black))),

                        // Sandwich quantity
                        new Text("Quantity: ${order.quantity}".toUpperCase(),
                            style: TextStyle(fontSize: 10, color: Colors.black),
                            textAlign: TextAlign.left),

                        // Sandwich price
                        new Text(
                            "Cost: ${order.price.toStringAsFixed(2)}"
                                .toUpperCase(),
                            style: TextStyle(fontSize: 10, color: Colors.black),
                            textAlign: TextAlign.left),
                      ])))
        ]));
  }
}
