import 'Ingredient.dart';

class CategoryIngredient {

  // Attributes
  String _name;
  String _urlToImage;
  List<Ingredient> _list;

  // Constructor
  CategoryIngredient(this._name, this._urlToImage, this._list);

  // Mapping
  CategoryIngredient.fromJSON(Map<String, dynamic> data) {
    var list = data["ingredients"] as List<Map<String, dynamic>>;

    this._name = data["name"];
    this._urlToImage = data["urlToImage"];
    this._list.addAll(list.map((i) => new Ingredient.fromJSON(i)).toList());
  }

  // Methods
  List<Ingredient> get list => _list;

  String get name => _name;

  String get urlToImage => _urlToImage;


}