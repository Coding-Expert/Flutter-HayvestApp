import 'Item.dart';

class Order {

  // Attributes
  Item _item;
  int _quantity;
  int id;

  // Constructor
  Order(this._item) {
    this._quantity = 1;
  }

  // Methods
  int get quantity => _quantity;

  set quantity(int value) {
    _quantity = value;
  }

  Item get item => _item;

  double get price => _item.calculatePrice() * _quantity;
}
