import 'package:flutter_classifiedappclone/Model/Period.dart';

class BuyerPackages {
  int id;
  String name;
  bool Searches;
  int totalBidsPlaced;
  bool broadCastAbility;
  int price;
  Period period;


  BuyerPackages({this.id, this.name, this.Searches, this.totalBidsPlaced,
      this.broadCastAbility, this.price, this.period});

  factory BuyerPackages.fromJson(Map<String, dynamic> json){
    return BuyerPackages(
      id: int.parse(json["id"]),
      name: json["name"],
      Searches: json["searches"],
      totalBidsPlaced: json["totalBidPlaced"],
      broadCastAbility: json["broadCastAbility"],
      price: json["price"],
      period: Period.fromJson(json["period"])
    );
  }

}