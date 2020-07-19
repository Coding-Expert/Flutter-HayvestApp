import 'package:flutter_classifiedappclone/UI/models/CategoryIngredient.dart';
import 'package:flutter_classifiedappclone/UI/repositories/CategoryIngredientsRepository.dart';
import 'package:rxdart/rxdart.dart';

class AddIngredientsBloc {

  static AddIngredientsBloc _addIngredientBloc;

  // Repo
  CategoryIngredientsRepository _categoryIngredientsRepository;

  // PublishSubjects to provide streams
  PublishSubject<List<CategoryIngredient>> _publishSubjectGetCategory;
  PublishSubject<CategoryIngredient> _publishSubjectCurrentCategory;


  factory AddIngredientsBloc(){
    if(_addIngredientBloc == null)
      _addIngredientBloc = new AddIngredientsBloc._();

    return _addIngredientBloc;
  }

  AddIngredientsBloc._(){
    _categoryIngredientsRepository = new CategoryIngredientsRepository();
    _publishSubjectGetCategory = new PublishSubject<List<CategoryIngredient>>();
    _publishSubjectCurrentCategory = new PublishSubject<CategoryIngredient>();
  }

  // Streams
  Observable<List<CategoryIngredient>> get allCategories => _publishSubjectGetCategory.stream;
  Observable<CategoryIngredient> get currentCategory => _publishSubjectCurrentCategory.stream;

  // Methods
  void fetchCategories() async {
    var data = await _categoryIngredientsRepository.fetchCategories();
    _publishSubjectGetCategory.sink.add(data);
  }

  void updateCurrentCategory(CategoryIngredient category){
    _publishSubjectCurrentCategory.sink.add(category);
  }

  dispose(){
    _addIngredientBloc = null;
    _publishSubjectGetCategory.close();
    _publishSubjectCurrentCategory.close();
  }
}