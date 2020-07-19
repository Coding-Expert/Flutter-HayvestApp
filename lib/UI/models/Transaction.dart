
import 'package:flutter_classifiedappclone/UI/models/Burger.dart';

class Transaction {
  
  // Attributes
  int _id;
  String _date;
  Burger _burger;
  double _price;

  // Constructor
  Transaction(this._id, this._date, this._burger, this._price);

  // Mapping
  Transaction.fromJSON(Map<String, dynamic> data) {
    this._id = data["id"];
    this._date = data["date"];
    this._burger = data["burger"];
    this._price = data["price"];
  }

  // Methods
  int get id => _id;

  String get date => _date;

  Burger get burger => _burger;

  double get price => _price;
}
