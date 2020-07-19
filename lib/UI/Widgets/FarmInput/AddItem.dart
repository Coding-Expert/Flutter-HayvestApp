import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/Model/Categ.dart';
import 'package:flutter_classifiedappclone/Model/Farm.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/CustomCategory.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AddItem extends StatefulWidget {
  Farm thiFarm;


  AddItem(this.thiFarm);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final String query = r'''
          query{
            categories{
              id
              name
              image
            }
          }
      ''';

  static List<Categ> categories = new List<Categ>();

  static List<Categ> loadCategories(List counties) {
    return counties.map<Categ>((json) => Categ.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.black,
          child: Text("Choose a category"),
        ),
      ),
      body: Query(
          options: QueryOptions(document: query),
          builder: (QueryResult result,
              {VoidCallback refetch, FetchMore fetchMore}) {
            if (result.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (result.data == null) {
              return Center(
                child: Text("Check Internet Connection"),
              );
            } else {
              print(result.data.data["categories"]);
              categories = loadCategories(result.data.data["categories"]);
              print(categories.length);
              return SingleChildScrollView(
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  children: categories.map((category){
                    return CustomCategCard(category, widget.thiFarm);
                  }).toList(),
                ),
              );
            }
          }),
    );
  }
}
