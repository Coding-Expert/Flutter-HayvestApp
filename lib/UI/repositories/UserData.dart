import 'package:flutter_classifiedappclone/UI/models/User.dart';

class UserData {

  static User _user;
  
  // You should make your api call here
  User fetchUser(){
    
    _user = new User("Abdelrahman ELGhamry","Ghamry98@hotmail.com","assets/images/profilepic.jpg",
     "01002123345", "18 Ahmed Saeed Street, Heliopolis", "5367 - 8312 - 1903 - 7124", "26/5", true);
    
   return _user;
  }
}