import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {

  final double price;
  PriceTag({Key key, this.price}) : super(key: key);

  Widget build(BuildContext context) {

    // Small box having the theme primary color and contains the price of each sandwich
    return new Container(decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.all(Radius.circular(5))), padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10), child:
      new Text("\$ $price", style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold))
    );
  }

}