import 'package:flutter_classifiedappclone/UI/models/Burger.dart';


class SpecialOffersRepository {

  static List<Burger> _list = new List();

  // Dummy data
  void _fillList(){
    _list.add(new Burger(1, 4.15, "Spicy Fire House", "Beef burger patty, Texas' sauce, lettuce, pickles, tomato, sauteed shrimp, sweet and chili sauce.", "assets/images/sandwich1.jpg", new List(), new List()));
    _list.add(new Burger(2, 6.25, "Monster Chill", "Beef burger patty, pesto sauce, rocca leaves, tomato, grilled halloumi cheese.", "assets/images/sandwich2.jpg", new List(), new List()));
    _list.add(new Burger(3, 7.0, "Double X Cheedar", "Blueberry jam, fried chicken, pineapple, cheese, coleslaw and BBQ sauce.", "assets/images/sandwich3.jpg", new List(), new List()));
    _list.add(new Burger(4, 2.15, "Gladiator", "Grilled marinated chicken , Swiss cheese, pesto sauce, local rocca leaves, pickles, tomato, rocca sauce.", "assets/images/sandwich4.jpg", new List(), new List()));
  }

  // You should make your api call here
  Future<List<Burger>> fetchSpecialOffers(){

    // Simulate cache network request
    if(_list.isNotEmpty) return Future.delayed(Duration(seconds: 0), (){
      _list.clear();
      _fillList();
      return _list;
    });

    return Future.delayed(Duration(seconds: 0), (){
      _fillList();
      return _list;
    });
  }

}
