import 'package:flutter_classifiedappclone/UI/models/Post.dart';

class NotificationsRepository {
  static List<Post> _list = new List();

  // Dummy data
  void _fillList() {
    _list.add(
      Post(
          1,
          "Double X Bacon is ready!",
          "Your sandwich is on its way",
          "assets/images/sandwich4.jpg"),
    );
    _list.add(
      Post(
          2,
          "Fries isn't ready yet!",
          "10mins to go",
          "assets/images/fries.png"),
    );
  }

  // You should make your api call here
  Future<List<Post>> fetchNotifications() {
    
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
