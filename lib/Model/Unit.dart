class Unit {
  int id;
  String name;
  String altName;

  Unit({this.id, this.name, this.altName});

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
        id: int.parse(json["id"]), name: json["name"], altName: json["alternativeName"]
    );
  }
}
