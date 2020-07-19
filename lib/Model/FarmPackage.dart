import 'package:flutter_classifiedappclone/Model/Period.dart';

class FarmPackage {
  int id;
  String name;
  int numberOfBids;
  int numberOfProducts;
  int price;
  Period period;

  FarmPackage(
      {this.id,
      this.name,
      this.numberOfBids,
      this.numberOfProducts,
      this.price, this.period});

  factory FarmPackage.fromJson(Map<String, dynamic> json) {
    return FarmPackage(
        id: int.parse(json["id"]),
        name: json["name"],
        numberOfBids: json["numberOfBids"],
        numberOfProducts: json["numberOfProducts"],
        price: json["price"],
        period: Period.fromJson(json['period'])
    );
  }
}
