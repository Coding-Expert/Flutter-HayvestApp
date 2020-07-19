import 'package:flutter_classifiedappclone/UI/models/CategoryIngredient.dart';
import 'package:flutter_classifiedappclone/UI/models/Ingredient.dart';


class CategoryIngredientsRepository {

  static List<CategoryIngredient> _list = new List();

  // Dummy data
  void _fillList(){
    _list.add(new CategoryIngredient("Cheese", "assets/images/cheese.jpg", [
      new Ingredient(1.5, "Cheddar"),
      new Ingredient(2, "Mozzarella"),
      new Ingredient(1.05, "Feta"),
    ].toList()));
    _list.add(new CategoryIngredient("Vegetables", "assets/images/vegetables.jpg", [
      new Ingredient(1.8, "Onion"),
      new Ingredient(1.2, "Tomato"),
      new Ingredient(0.86, "Lettuce"),
      new Ingredient(0.86, "Cuncumber"),
      new Ingredient(0.95, "Roasted Red Peppers"),
    ].toList()));
    _list.add(new CategoryIngredient("Meat", "assets/images/meat.jpg", [
      new Ingredient(0.86, "Turkey Breast"),
      new Ingredient(1.0, "Chicken Strips"),
      new Ingredient(0.95, "Roasted Chicken"),
      new Ingredient(2.8, "Pepperoni"),
      new Ingredient(1.2, "Salami")
    ].toList()));
    _list.add(new CategoryIngredient("Sauce", "assets/images/sauce.jpg", [
      new Ingredient(1.0, "jalapeno"),
      new Ingredient(1.2, "Honey Mustard"),
      new Ingredient(0.86, "Ranch"),
      new Ingredient(1.0, "Savoury Caesar"),
    ].toList()));
    _list.add(new CategoryIngredient("Bread", "assets/images/bread.jpg", [
      new Ingredient(1.1, "baguette"),
      new Ingredient(0.6, "French"),
      new Ingredient(0.35, "Toast"),
    ].toList()));
  }

  // You should make your api call here
  Future<List<CategoryIngredient>> fetchCategories(){
    
    // Simulate cache network request
    if(_list.isNotEmpty) return Future.delayed(Duration(seconds: 0), (){
      return _list;
    });

    return Future.delayed(Duration(seconds: 1), (){
      _fillList();
      return _list;
    });
  }

}
