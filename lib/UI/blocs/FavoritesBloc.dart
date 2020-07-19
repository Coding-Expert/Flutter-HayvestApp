import 'package:flutter_classifiedappclone/UI/models/Burger.dart';
import 'package:flutter_classifiedappclone/UI/repositories/FavoritesRepository.dart';
import 'package:rxdart/rxdart.dart';

class FavoritesBloc {

  // Repo
  FavoritesRepository _favoritesRepository = new FavoritesRepository();

  // PublishSubject to provide stream
  PublishSubject<List<Burger>> _publishSubject = new PublishSubject<List<Burger>>();

  // List
  List<Burger> _currentFavorites;

  // Stream
  Observable<List<Burger>> get allFavorites => _publishSubject.stream;

  // Methods
  void fetchFavorites() async {
    _currentFavorites = await _favoritesRepository.fetchFavorites();
    _publishSubject.sink.add(_currentFavorites);
  }

  void removeFavorite(Burger burger){
    _currentFavorites.remove(burger);
    _publishSubject.sink.add(_currentFavorites);
  }

  dispose(){
    _favoritesRepository = null;
    _publishSubject.close();
  }
}