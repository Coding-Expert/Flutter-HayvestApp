var images = [
  "assets/image_01.png",
  "assets/image_01.png",
  "assets/image_02.png",
  "assets/image_03.png",
];

var title = ["Free","Bronze", "Silver", "Gold"];
var price = ["0", "99", "199", "299"];


class BuyerPackage{
  String Name;
  double Price;
  int itemsAllowed;
  int MonthlyBids;
  String CanBroadcast;

  BuyerPackage({this.Name, this.Price, this.itemsAllowed, this.MonthlyBids, this.CanBroadcast});

}

List<BuyerPackage> dummyData = [
  BuyerPackage(
    Name: "Free",
    Price: 0.00,
    itemsAllowed: 1,
    MonthlyBids: 0,
    CanBroadcast: "False"
  ),
  BuyerPackage(
      Name: "Premium",
      Price: 9999.0,
      itemsAllowed: 3,
      MonthlyBids: 2,
    CanBroadcast: "True"
  ),
];