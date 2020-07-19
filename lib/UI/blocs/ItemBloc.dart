import 'package:flutter_classifiedappclone/UI/models/Burger.dart';
import 'package:flutter_classifiedappclone/UI/models/Ingredient.dart';
import 'package:flutter_classifiedappclone/UI/models/Item.dart';
import 'package:rxdart/rxdart.dart';
class ItemBloc {

  static ItemBloc _itemBloc;

  // PublishSubject to provide stream
  PublishSubject<Item> _publishSubjectCurrentItem;
  Item _item;

  factory ItemBloc(){
    if(_itemBloc == null)
      _itemBloc = new ItemBloc._();

    return _itemBloc;
  }

  ItemBloc._(){
    _publishSubjectCurrentItem = new  PublishSubject<Item>();
  }

  // Stream
  Observable<Item> get currentItem => _publishSubjectCurrentItem.stream;

  Item get item => _item;

  // Methods
  updateItem(Item item){
    _item = item;
    _publishSubjectCurrentItem.sink.add(_item);
  }

  addExtraIngredient(Ingredient ingredient){
    Burger burger = _item as Burger;
    burger.addExtraIngredient(ingredient);
    updateItem(burger);
  }

  removeExtraIngredient(Ingredient ingredient){
    Burger burger = _item as Burger;
    burger.removeExtraIngredient(ingredient);
    updateItem(burger);
  }
  
  dispose(){
    _itemBloc = null;
    _publishSubjectCurrentItem.close();
  }

}