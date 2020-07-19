import 'package:flutter_classifiedappclone/UI/models/Item.dart';
import 'package:flutter_classifiedappclone/UI/models/Order.dart';
import 'package:rxdart/rxdart.dart';

class OrderBloc{
  Order _currentOrder;

  // PublishSubject to provide stream
  PublishSubject<Order> _publishSubjectOrder;

  static OrderBloc _orderBloc;
  factory OrderBloc(){
    if(_orderBloc == null)
      _orderBloc = new OrderBloc._();

    return _orderBloc;
  }

  OrderBloc._(){
    _publishSubjectOrder = new PublishSubject<Order>();
  }

  // Stream
  Observable<Order> get currentOrder => _publishSubjectOrder.stream;

  // Methods
  void createOrder(Item item){
    _currentOrder = new Order(item);
    _publishSubjectOrder.sink.add(_currentOrder);
  }

  void increment(){
    _currentOrder.quantity++;
    _publishSubjectOrder.sink.add(_currentOrder);
  }

  void decrement(){
    if(_currentOrder.quantity>1){
      _currentOrder.quantity--;
      _publishSubjectOrder.sink.add(_currentOrder);
    }
  }

  dispose(){
    _orderBloc = null;
    _publishSubjectOrder.close();
  }

}