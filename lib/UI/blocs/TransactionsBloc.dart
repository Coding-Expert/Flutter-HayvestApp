import 'package:flutter_classifiedappclone/UI/models/Transaction.dart';
import 'package:flutter_classifiedappclone/UI/repositories/TransactionsRepository.dart';
import 'package:rxdart/rxdart.dart';

class TransactionsBloc {

  // Repo
  TransactionsRepository _transactionsRepository = new TransactionsRepository();

  // PublishSubject to provide stream
  PublishSubject<List<Transaction>> _publishSubject = new PublishSubject<List<Transaction>>();

  // List
  List<Transaction> _currentTransactions;

  // Stream
  Observable<List<Transaction>> get allTransaction => _publishSubject.stream;

  // Methods
  void fetchTransactions() async {
    _currentTransactions = await _transactionsRepository.fetchTransactions();
    _publishSubject.sink.add(_currentTransactions);
  }

  void removeTransaction(Transaction transaction){
    _currentTransactions.remove(transaction);
    _publishSubject.sink.add(_currentTransactions);
  }

  dispose(){
    _transactionsRepository = null;
    _publishSubject.close();
  }
}