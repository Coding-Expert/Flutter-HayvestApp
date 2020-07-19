class Ward{
  int id;
  String name;

  Ward({this.id, this.name});

  factory Ward.fromJson(Map<String, dynamic> json){
    return Ward(id: int.parse(json['id']), name: json['name']);
  }

}