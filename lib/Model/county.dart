import 'Ward.dart';

class Place {
  int id;
  String name;
  List<Ward> wards;

  Place({this.id, this.name, this.wards});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        id: int.parse(json['id']),
        name: json['name'],
        wards: json['wards'].map<Ward>((json) => Ward.fromJson(json)).toList());
  }
}
