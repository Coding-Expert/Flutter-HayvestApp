import 'package:flutter_classifiedappclone/UI/models/Post.dart';
import 'package:flutter_classifiedappclone/UI/repositories/NotificationsRepository.dart';
import 'package:rxdart/rxdart.dart';

class NotificationsBloc {

  // Repo
  NotificationsRepository _notificationsRepository = new NotificationsRepository();

  // PublishSubject to provide stream
  PublishSubject<List<Post>> _publishSubject = new PublishSubject<List<Post>>();

  // List
  List<Post> _currentNotifications;

  // Stream
  Observable<List<Post>> get allNotifications => _publishSubject.stream;

  // Methods
  void fetchNotifications() async {
    _currentNotifications = await _notificationsRepository.fetchNotifications();
    _publishSubject.sink.add(_currentNotifications);
  }

  void removeNotification(Post post){
    _currentNotifications.remove(post);
    _publishSubject.sink.add(_currentNotifications);
  }

  dispose(){
    _notificationsRepository = null;
    _publishSubject.close();
  }
}