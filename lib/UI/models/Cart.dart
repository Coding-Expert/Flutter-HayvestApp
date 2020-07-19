import 'Order.dart';

class Cart {


  // Attributes
  List<Order> _orders;

  // Constructor
  Cart(){
    _orders = new List();
  }

  // Methods
  void addOrder(Order order){
    order.id = _orders.length+1;
    _orders.add(order);
  }
  
  void removeOrder(Order order){
    _orders.remove(order);
  }
  
  void removeAll(){
    _orders.removeRange(0, _orders.length);
  }

  List<Order> get orders => _orders;
  
  double get totalPrice {
    double value = 0;
    _orders.forEach((order) => value += order.price);
    return value;
  }

}