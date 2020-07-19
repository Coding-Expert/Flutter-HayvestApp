import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/Model/Categ.dart';
import 'package:flutter_classifiedappclone/Model/Farm.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/FarmInput/SelectProduct.dart';

class CustomCategCard extends StatelessWidget {
  Categ category;
  Farm thiFarm;

  CustomCategCard(this.category, this.thiFarm);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return SelectProduct(category.name, thiFarm);
        }));
      },
      child: Card(
        elevation: 3.0,
        child:Column(
          children: <Widget>[
            Image(image: NetworkImage(category.image), fit: BoxFit.fitWidth, height: 120, ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.only(left: 10,right: 10,top: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(category.name),
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
