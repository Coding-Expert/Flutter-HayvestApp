import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/Model/Farm.dart';
import 'package:flutter_classifiedappclone/Model/SaleProduct.dart';
import 'package:flutter_classifiedappclone/Model/itemModel.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/FarmInput/EditItem.dart';

class CustomItemCard extends StatelessWidget {
  Sales item;
  CustomItemCard(this.item,);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() => Navigator.of(context).push(MaterialPageRoute(builder: (context){
        return EditItem(item, );
      })),
      child: Card(
        elevation: 3.0,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image(image: NetworkImage(item.product.image), fit: BoxFit.fitWidth, height: 100, ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.only(left: 10,right: 10,top: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(item.product.name),
                      Text("Ksh. ${item.price}", style: TextStyle(fontSize: 11.0),)
                    ],
                  ),
                ],
              ),
            ),
//          Padding(
//            padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
//            child: Row(
//              children: <Widget>[
//                Text(item.location, style: TextStyle(fontSize: 10.0,))
//              ],
//            ),
//          ),
          ],
        ),
      ),
    );
  }
}
