class Period {
  int id;
  String name;
  int numberOfDays;

  Period({this.id, this.name, this.numberOfDays});

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
        id: int.parse(json['id']),
        name: json["name"],
        numberOfDays: json['numberOfDays']);
  }
}
