class RegDecision {
  String Name;
  String Description;
  String Image;

  RegDecision({this.Name, this.Description, this.Image});
}

List<RegDecision> dummyData = [
  RegDecision(
      Name: "Farmer",
      Description: "Continue as a Farmer and Sell Farm Produce",
      Image:
      'assets/images/farmers.png'),
  RegDecision(
      Name: "Buyer",
      Description: "Continue as a Buyer",
      Image:
          "assets/images/handshake.png"),
];
