import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/Model/Categ.dart';
import 'package:flutter_classifiedappclone/Model/Product.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/Buying/Sellers.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/FarmInput/ProductDetails.dart';

class ProductCard extends StatelessWidget {
  Product product;
  List Buyer;
  ProductCard(this.Buyer, this.product);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return new Selling(product.name, Buyer);
        }));
      },
      child: Card(
        elevation: 3.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image(
              image: NetworkImage(product.image),
              fit: BoxFit.fitWidth,
              height: MediaQuery.of(context).size.height/6,
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(product.name),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
