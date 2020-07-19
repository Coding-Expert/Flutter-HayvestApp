import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/UI/blocs/AddIngredientsBloc.dart';
import 'package:flutter_classifiedappclone/UI/components/CategoryIngredientWidget.dart';
import 'package:flutter_classifiedappclone/UI/components/IngredientWidget.dart';
import 'package:flutter_classifiedappclone/UI/models/CategoryIngredient.dart';
import 'package:flutter_classifiedappclone/UI/models/Ingredient.dart';

class AddIngredients extends StatefulWidget {
  _AddIngredients createState() => new _AddIngredients();
}

class _AddIngredients extends State<AddIngredients> {

  AddIngredientsBloc _addIngredientsBloc;

  initState(){
    _addIngredientsBloc = new AddIngredientsBloc();

    // Loading all available ingredients
    _addIngredientsBloc.fetchCategories();
    super.initState();
  }

  Widget build(BuildContext context){
      return new Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),height: 400, padding: EdgeInsets.symmetric(horizontal: 20), child:
          new Column(children: <Widget>[
            new Padding(padding: EdgeInsets.only(top: 20), child:
              new Stack(children: <Widget>[
                new Center(child: Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 30)),
                new Padding(padding: EdgeInsets.only(top: 10), child: new Text("Ingredients", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20))),
              ])
            ),
            new Container(height: MediaQuery.of(context).size.height*0.18, child:

              // Display all categories of ingredients
              new StreamBuilder(
                  stream: _addIngredientsBloc.allCategories,
                  builder: (context,  AsyncSnapshot<List<CategoryIngredient>> snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) 

                    // Showing CircularProgressIndicator for the loading process
                    return new Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));

                    if (snapshot.hasData) {
                      return _buildCategoryList(snapshot.data);
                    } else if (snapshot.hasError) {

                      // In case of error: diplay error message to the user
                      return Text(snapshot.error.toString());
                    }
                  }
              )
            ),

            // Display ingredients of each category
            new Container(height: 140, child:
              new StreamBuilder(
                  stream: _addIngredientsBloc.currentCategory,
                  builder: (context,  AsyncSnapshot<CategoryIngredient> snapshot) {
                    if(snapshot.data == null) return new Container();
                    return _buildIngredientList(snapshot.data.list);
                  }
              )
            ),
          ])
      );
  }

  // Display all categories of ingredients
  Widget _buildCategoryList(List<CategoryIngredient> list){
    return
      new ListView.builder(itemCount: list.length, scrollDirection: Axis.horizontal, itemBuilder: (context, position) {
        return Container(padding: EdgeInsets.only(right: 10, top: 10, bottom: 10), child:

          // Each category of ingredients is represented in a CategoryIngredientWidget component
          new CategoryIngredientWidget(categoryIngredient: list[position])
        );
      });
  }

  // Display ingredients of each category
  Widget _buildIngredientList(List<Ingredient> list){
    return
      new ListView.builder(itemCount: list.length, scrollDirection: Axis.vertical, itemBuilder: (context, position) {
        return Container(padding: EdgeInsets.only(right: 10, bottom: 20), child:

          // Each ingredient is represented in a IngredientWidget component
          new IngredientWidget(ingredient: list[position])
        );
      });
  }

  @override
  void dispose() {
    _addIngredientsBloc.dispose();
    super.dispose();
  }

}