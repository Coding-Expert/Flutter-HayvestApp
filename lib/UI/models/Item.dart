abstract class Item {

  // Attributes
  int _id;
  String _title;
  String _urlToImage;
  String _desc;
  double _price;

  // Constructor
  Item(this._id, this._price, this._title, this._urlToImage, this._desc);

  // Mapping
  Item.fromJSON(Map<String, dynamic> data) {
    this._id = data["id"];
    this._title = data["title"];
    this._price = data["price"];
    this._urlToImage = data["urlToImage"];
    this._desc = data["desc"];
  }

  // Methods
  int get id => _id;

  String get title => _title;

  String get urlImage => _urlToImage;

  double get price => _price;

  String get desc => _desc;

  double calculatePrice();
}