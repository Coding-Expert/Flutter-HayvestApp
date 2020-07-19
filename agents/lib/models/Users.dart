class User{
  int id;
  String phoneNumber;
  String CountyName;
  String Profile;
  DateTime dateTime;

  User({this.id, this.phoneNumber, this.CountyName, this.Profile, this.dateTime});


}


// ignore: non_constant_identifier_names
List<User> DummyUsers = [
  User(id: 1, phoneNumber: "+254711223344", CountyName: "Kericho", Profile: "Buyer", dateTime: DateTime(2019, 06, 23)),
  User(id: 1, phoneNumber: "+254710323644", CountyName: "Kericho", Profile: "Seller", dateTime: DateTime(2019, 06, 24)),
  User(id: 1, phoneNumber: "+254711226655", CountyName: "Kericho", Profile: "Buyer", dateTime: DateTime(2019, 06, 25)),
  User(id: 1, phoneNumber: "+254722334455", CountyName: "Kericho", Profile: "Seller", dateTime: DateTime(2019, 06, 26)),
];