import 'package:flutter_classifiedappclone/UI/models/Burger.dart';
import 'package:flutter_classifiedappclone/UI/repositories/SpecialOffersRepository.dart';
import 'package:rxdart/rxdart.dart';

class SpecialOfferBloc {

  // Repo
  SpecialOffersRepository _offersRepository = new SpecialOffersRepository();

  // PublishSubject to provide stream
  PublishSubject<List<Burger>> _publishSubject = new PublishSubject<List<Burger>>();

  // Stream
  Observable<List<Burger>> get allOffers => _publishSubject.stream;

  // Methods
  void fetchOffers() async {
    var data = await _offersRepository.fetchSpecialOffers();
    _publishSubject.sink.add(data);
  }

  dispose(){
    _offersRepository = null;
    _publishSubject.close();
  }
}