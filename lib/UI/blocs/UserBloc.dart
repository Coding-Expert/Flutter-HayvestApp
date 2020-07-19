import 'package:flutter_classifiedappclone/UI/models/User.dart';
import 'package:flutter_classifiedappclone/UI/repositories/UserData.dart';

class UserBloc {

  // Repo
  UserData _userData = new UserData();
  User _user;

  // Methods
  User get user => _user;

  void fetchUser() {
    _user = _userData.fetchUser();
  }

  dispose() {
    _userData = null;
  }
}
