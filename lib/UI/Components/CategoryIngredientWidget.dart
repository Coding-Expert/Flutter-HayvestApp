import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/UI/blocs/AddIngredientsBloc.dart';
import 'package:flutter_classifiedappclone/UI/models/CategoryIngredient.dart';

// Represents each category in ingredients (Cheese/ Vegetables/ Meat/ Sauce/ Bread)
class CategoryIngredientWidget extends StatefulWidget{
  final CategoryIngredient categoryIngredient;

  CategoryIngredientWidget({Key key, this.categoryIngredient}) : super(key:key);

  _IngredientWidget createState() => _IngredientWidget();
}

class _IngredientWidget extends State<CategoryIngredientWidget> {

  AddIngredientsBloc _addIngredientsBloc;

  initState(){

    // AddIngredientsBloc to get all the available categories
    _addIngredientsBloc = new AddIngredientsBloc();
    super.initState();
  }

  Widget build(BuildContext context) {
    return new StreamBuilder(stream: _addIngredientsBloc.currentCategory, builder: (context, AsyncSnapshot<CategoryIngredient> snapshot){
      
      // Make a red ring(circle) around the selected category
      if(snapshot.data == widget.categoryIngredient)
        return _buildWidget(Theme.of(context).primaryColor);

      // Dont make a red ring(circle) around the unselected categories
      return _buildWidget(Colors.transparent);
    });
  }

  Widget _buildWidget(Color color){
    return new GestureDetector(

        // onTapping a certain category, select it, in order to make a red ring(circle) around it
        onTap: (){
          _addIngredientsBloc.updateCurrentCategory(widget.categoryIngredient);
          },
        child: new Column(children: <Widget>[
          new Container(
            width: MediaQuery.of(context).size.height*0.1,
            height: MediaQuery.of(context).size.height*0.1,
            decoration: new BoxDecoration(
              color: const Color(0xff7c94b6),

              // Displaying the image of each category
              image: new DecorationImage(
                image: new AssetImage(widget.categoryIngredient.urlToImage),
                fit: BoxFit.cover,
              ),
              borderRadius: new BorderRadius.all(new Radius.circular(50.0)),

              // Color is either the theme primary color(red in our case) or transparent
              // Depending on it is selected or not
              border: new Border.all(
                color: color,
                width: 4.0,
              ),
            ),
          ),

          // Adding the name of each category beneath it
          new Center(child: new Padding(padding: EdgeInsets.only(top: 5), child: new Text(widget.categoryIngredient.name)))
        ])
    );
  }
}