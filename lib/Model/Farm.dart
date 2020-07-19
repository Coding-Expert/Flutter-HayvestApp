import 'package:flutter_classifiedappclone/Model/FarmPackage.dart';
import 'package:flutter_classifiedappclone/Model/SaleProduct.dart';
import 'package:flutter_classifiedappclone/Model/county.dart';

class Farm {
  int id;
  String name;
  double lat;
  double lon;
  FarmPackage package;
  Place county;
  DateTime packageUpdateDate;
  List selling;
  List chats;

  Farm(
      {this.id,
      this.name,
      this.lat,
      this.lon,
      this.county,
      this.package,
      this.packageUpdateDate,
      this.selling,
      this.chats});

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
        id: int.parse(json["id"]),
        name: json["name"],
        lat: json["latitude"],
        lon: json["longitude"],
        county: Place.fromJson(json["county"]),
        package: FarmPackage.fromJson(json['package']),
        packageUpdateDate: DateTime.parse(json["packageUpdateDate"]),
        selling: json["sales"],
        chats: json["farmChats"]);
  }
}
