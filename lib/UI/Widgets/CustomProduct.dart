import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/Model/Categ.dart';
import 'package:flutter_classifiedappclone/Model/Farm.dart';
import 'package:flutter_classifiedappclone/Model/Product.dart';
import 'package:flutter_classifiedappclone/Model/productModel.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/FarmInput/ProductDetails.dart';

class CustomProdCard extends StatelessWidget {
  SelectedProduct product;
  Farm thiFarm;

  CustomProdCard(this.product, this.thiFarm);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return new ProductDetails(thiFarm, product);
        }));
      },
      child: Card(
        elevation: 3.0,
        child: Column(
          children: <Widget>[
            Image(
              image: NetworkImage(product.image),
              fit: BoxFit.fitWidth,
              height: 120,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
