class Ingredient {
  
  // Attributes
  String _name;
  double _price;

  // Constructor
  Ingredient(this._price, this._name);

  // Mapping
  Ingredient.fromJSON(Map<String, dynamic> data) {
    this._name = data["name"];
    this._price = data["price"];
  }

  // Methods
  String get name => _name;

  double get price => _price;
}