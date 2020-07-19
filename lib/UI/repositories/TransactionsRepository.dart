import 'package:flutter_classifiedappclone/UI/models/Burger.dart';
import 'package:flutter_classifiedappclone/UI/models/Transaction.dart';

class TransactionsRepository {
  static List<Transaction> _list = new List();

  // Dummy data
  void _fillList() {
    _list.add(
      Transaction(
          1,
          "Mar 01",
          new Burger(1, 4.15, "Spicy Fire House", "Beef burger patty, Texas' sauce, lettuce, pickles, tomato, sauteed shrimp, sweet and chili sauce.", "https://portal.minervafoods.com/files/como_fazer_hamburguer_caseiro.jpg", new List(), new List()),
          49.9),
    );
    _list.add(
      Transaction(
          2,
          "Feb 17",
          new Burger(3, 6.25, "Double X Cheedar", "Blueberry jam, fried chicken, pineapple, cheese, coleslaw and BBQ sauce.", "https://i2.wp.com/www.bagagemdememorias.com/wp-content/uploads/2017/03/meal-fries-hamburger.jpg?fit=800%2C533&ssl=1", new List(), new List()),
          15.5),
    );
    _list.add(
      Transaction(
          2,
          "Dec 24",
          new Burger(2, 2.15, "Monster Chill", "Beef burger patty, pesto sauce, rocca leaves, tomato, grilled halloumi cheese.", "https://blog.grandchef.com.br/wp-content/uploads/2018/08/hamburgueria.jpg", new List(), new List()),
          15.5),
    );
  }
  
  // You should make your api call here
  Future<List<Transaction>> fetchTransactions() {

    // Simulate cache network request
    if (_list.isNotEmpty)
      return Future.delayed(Duration(milliseconds: 500), () {
        _list.clear();
        _fillList();
        return _list;
      });

    return Future.delayed(Duration(milliseconds: 500), () {
      _fillList();
      return _list;
    });
  }
}
