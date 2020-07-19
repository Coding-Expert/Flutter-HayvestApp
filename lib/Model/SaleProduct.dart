import 'package:flutter_classifiedappclone/Model/Product.dart';

class Sales{
  int id;
  Product product;
  double price;
  double amount;

  Sales({this.id, this.product, this.price, this.amount});

  factory Sales.fromJson(Map<String, dynamic> Json){
    return Sales(
      id: int.parse(Json["id"]),
      price: Json['price'],
      product: Product.fromJson(Json['product']),
      amount: Json["amount"]
    );
  }


}