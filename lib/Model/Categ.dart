class Categ {
  int id;
  String name;
  String image;

  Categ({this.id, this.name, this.image});

  factory Categ.fromJson(Map<String, dynamic> json) {
    return Categ(
        id: int.parse(json['id']),
        name: json['name'],
        image: "http://34.76.96.215:8000/media/${json['image']}");
  }
}
