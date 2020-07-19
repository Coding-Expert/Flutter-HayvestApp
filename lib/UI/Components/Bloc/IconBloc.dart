import 'package:rxdart/rxdart.dart';

class IconsBloc {

  static IconsBloc _iconsBloc;


  // PublishSubjects to provide streams
  PublishSubject<bool> _publishSubjectNotifyNotifications;
  PublishSubject<bool> _publishSubjectNotifyFavorites;
  PublishSubject<bool> _publishSubjectNotifyCart;
  PublishSubject<bool> _publishSubjectNotifyProfile;

  factory IconsBloc(){
    if(_iconsBloc == null)
      _iconsBloc = new IconsBloc._();

    return _iconsBloc;
  }

  IconsBloc._(){
    _publishSubjectNotifyNotifications = new PublishSubject<bool>();
    _publishSubjectNotifyFavorites = new PublishSubject<bool>();
    _publishSubjectNotifyCart = new PublishSubject<bool>();
    _publishSubjectNotifyProfile = new PublishSubject<bool>();
  }

  // Methods
  void notifyNotificationIcon(bool value){
    _publishSubjectNotifyNotifications.sink.add(value);
  }

  void notifyFavoriteIcon(bool value){
    _publishSubjectNotifyFavorites.sink.add(value);
  }

  void notifyProfileIcon(bool value){
    _publishSubjectNotifyProfile.sink.add(value);
  }

  void notifyCartIcon(bool value){
    _publishSubjectNotifyCart.sink.add(value);
  }

  Observable<bool> get notificationsNotification => _publishSubjectNotifyNotifications.stream;

  Observable<bool> get favoritesNotification => _publishSubjectNotifyFavorites.stream;

  Observable<bool> get cartNotification => _publishSubjectNotifyCart.stream;

  Observable<bool> get profileNotification => _publishSubjectNotifyProfile.stream;

  dispose(){
    _iconsBloc = null;
    _publishSubjectNotifyProfile.close();
    _publishSubjectNotifyNotifications.close();
    _publishSubjectNotifyFavorites.close();
    _publishSubjectNotifyCart.close();
  }

}