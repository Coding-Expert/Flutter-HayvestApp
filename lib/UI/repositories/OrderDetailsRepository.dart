import 'package:flutter_classifiedappclone/UI/models/OrderState.dart';

class OrderDetailsRepository {
  static List<OrderState> _list = new List();

  // Dummy data
  void _fillList() {
    _list.add(
      OrderState("Payment", "JUN 20", "State", "Pending", "not yet - not yet")
    );
    _list.add(
      OrderState("Delivery", "JUN 20", "State", "Pending", "10:05 am - on way"),
    );
    _list.add(
      OrderState("Kitchen", "JUN 20", "State", "Ok", "9:45 am - 10:02 am"),
    );
    _list.add(
      OrderState("Ordering", "JUN 20", "State", "Ok", "9:26 am - 9:40 am"),
    );
  }

  // You should make your api call here
  Future<List<OrderState>> fetchOrderDetails() {
    
    // Simulate cache network request
    if (_list.isNotEmpty)
      return Future.delayed(Duration(seconds: 0), () {
        _list.clear();
        _fillList();
        return _list;
      });

    return Future.delayed(Duration(seconds: 0), () {
      _fillList();
      return _list;
    });
  }
  
  
  List<OrderState> get dummyOrderDetails => _list;

  List<OrderState> fetchDummyOrderDetails() {
    
    // Simulate cache network request
    if (_list.isNotEmpty){
        _list.clear();
        _fillList();
        return _list;
      }

      _fillList();
      return _list;
  }
}
