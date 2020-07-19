import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/UI/blocs/ItemBloc.dart';
import 'package:flutter_classifiedappclone/UI/models/Burger.dart';
import 'package:flutter_classifiedappclone/UI/models/Ingredient.dart';
import 'package:flutter_classifiedappclone/UI/models/Item.dart';

// Displaying the ingredients in each category
class IngredientWidget extends StatefulWidget {
  final Ingredient ingredient;

  IngredientWidget({Key key, this.ingredient}) : super(key: key);
  _IngredientWidget createState() => _IngredientWidget();
}

class _IngredientWidget extends State<IngredientWidget> {
  ItemBloc _itemBloc;

  initState() {
    _itemBloc = new ItemBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                // Adding the name of each ingredient
                new Text(widget.ingredient.name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

                // Adding the price of each ingredient
                new Text("\$ ${widget.ingredient.price}")
              ]),
          new Column(children: <Widget>[
            new Row(children: <Widget>[

              // Remove (-1) of this ingredient
              new SizedBox(
                  width: 40,
                  height: 40,
                  child: new FlatButton(
                      onPressed: () {
                        _itemBloc.removeExtraIngredient(widget.ingredient);
                      },
                      child: new Icon(Icons.remove, size: 10),
                      color: Colors.black12)),

              // Displaying the chosen count of this ingredient
              new Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: new StreamBuilder(
                      initialData: _itemBloc.item,
                      stream: _itemBloc.currentItem,
                      builder: (context, AsyncSnapshot<Item> snapshot) {
                        var b = snapshot.data as Burger;
                        return new Text(
                            "${b.ingredientCount(widget.ingredient)}");
                      })),

              // Add (+1) of this ingredient
              new SizedBox(
                  width: 40,
                  height: 40,
                  child: new FlatButton(
                      onPressed: () async {
                        _itemBloc.addExtraIngredient(widget.ingredient);
                      },
                      child: new Icon(Icons.add, size: 10),
                      color: Colors.black12)),
            ])
          ]),
        ]);
  }
}
