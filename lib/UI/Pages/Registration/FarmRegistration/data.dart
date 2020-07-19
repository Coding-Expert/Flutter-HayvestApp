var images = [
  "assets/image_01.png",
  "assets/image_01.png",
  "assets/image_02.png",
  "assets/image_03.png",
];

var title = ["Free","Bronze", "Silver", "Gold"];
var price = ["0", "99", "199", "299"];


class Package{
  String Name;
  double Price;
  int itemsAllowed;
  int MonthlyBids;

  Package({this.Name, this.Price, this.itemsAllowed, this.MonthlyBids});

}

List<Package> dummyData = [
  Package(
    Name: "Free",
    Price: 0.00,
    itemsAllowed: 1,
    MonthlyBids: 0
  ),
  Package(
      Name: "Bronze",
      Price: 99.0,
      itemsAllowed: 3,
      MonthlyBids: 2
  ),
  Package(
      Name: "Silver",
      Price: 199.0,
      itemsAllowed: 5,
      MonthlyBids: 4
  ),
  Package(
      Name: "Gold",
      Price: 299.0,
      itemsAllowed: 10,
      MonthlyBids: 10
  ),
];