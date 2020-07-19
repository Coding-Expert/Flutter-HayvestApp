import 'package:flutter_classifiedappclone/UI/models/Cart.dart';
import 'package:flutter_classifiedappclone/UI/models/Order.dart';
import 'package:rxdart/rxdart.dart';
import 'IconsBloc.dart';

class CartBloc {

  static CartBloc _cartBloc;

  Cart _currentCart;

  // PublishSubject to provide stream
  PublishSubject<Cart> _publishSubjectCart;
  IconsBloc _iconsBloc;

  factory CartBloc(){
    if(_cartBloc == null)
      _cartBloc = new CartBloc._();

    return _cartBloc;
  }

  CartBloc._(){
    _iconsBloc = new IconsBloc();
    _currentCart = new Cart();
    _publishSubjectCart = new PublishSubject<Cart>();
  }

  // Stream
  Observable<Cart> get getCart => _publishSubjectCart.stream;

  Cart get cart => _currentCart;

  // Methods
  void addOrderToCart(Order order){
    _iconsBloc.notifyCartIcon(true);
    _currentCart.addOrder(order);
    _publishSubjectCart.sink.add(_currentCart);
  }

  void removeOrderFromCart(Order order){
    _currentCart.removeOrder(order);
    _publishSubjectCart.sink.add(_currentCart);
  }

  void removeAllFromCart(){
    _currentCart.removeAll();
    _publishSubjectCart.sink.add(_currentCart);
  }

  dispose(){
    _cartBloc = null;
    _publishSubjectCart.close();
  }

}