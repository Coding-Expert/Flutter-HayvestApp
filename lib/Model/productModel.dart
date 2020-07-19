import 'package:flutter_classifiedappclone/Model/Unit.dart';

class SelectedProduct {
  int id;
  String name;
  String image;
  List<Unit> unitsOfMeasure;

  SelectedProduct({this.id, this.name, this.image, this.unitsOfMeasure});

  factory SelectedProduct.fromJson(Map<String, dynamic> json) {
    return SelectedProduct(
        id: int.parse(json["id"]),
        name: json["name"],
        image: "http://34.76.96.215:8000/media/${json['image']}",
        unitsOfMeasure: json["unitsOfMeasure"]
            .map<Unit>((json) => Unit.fromJson(json))
            .toList());
  }
}
