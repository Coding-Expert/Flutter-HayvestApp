import 'package:flutter_classifiedappclone/UI/models/OrderState.dart';
import 'package:flutter_classifiedappclone/UI/repositories/OrderDetailsRepository.dart';
import 'package:rxdart/rxdart.dart';

class OrderDetailsBloc {

  // Repo
  OrderDetailsRepository _orderDetailsRepository = new OrderDetailsRepository();

  // PublishSubject to provide stream
  PublishSubject<List<OrderState>> _publishSubject = new PublishSubject<List<OrderState>>();

  // List
  List<OrderState> _currentOrderDetails;
  List<OrderState> _currentDummyOrderDetails;

  // Stream
  Observable<List<OrderState>> get allOrderDetails => _publishSubject.stream;

  // Methods
  void fetchOrderDetails() async {
    _currentOrderDetails = await _orderDetailsRepository.fetchOrderDetails();
    _publishSubject.sink.add(_currentOrderDetails);
  }

  void fetchDummyOrderDetails() {
    _currentDummyOrderDetails = _orderDetailsRepository.fetchDummyOrderDetails();
    _publishSubject.sink.add(_currentOrderDetails);
  }

  List<OrderState> get currentDummyOrderDetails => _orderDetailsRepository.dummyOrderDetails;
  
  dispose(){
    _orderDetailsRepository = null;
    _publishSubject.close();
  }
}