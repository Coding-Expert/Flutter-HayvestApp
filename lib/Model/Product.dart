import 'package:flutter_classifiedappclone/Model/Unit.dart';

class Product {
  int id;
  String name;
  String image;
  List<Unit> units;

  Product({this.id, this.name, this.image, this.units});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: int.parse(json["id"]),
        name: json["name"],
        image: "http://34.76.96.215:8000/media/${json['image']}",
        units: json["unitsOfMeasure"] == null
            ? null
            : json["unitsOfMeasure"]
                .map<Unit>((json) => Unit.fromJson(json))
                .toList());
  }
}
