import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/Model/Farm.dart';
import 'package:flutter_classifiedappclone/Model/productModel.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/CustomCategory.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/CustomProduct.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SelectProduct extends StatefulWidget {
  String name;
  Farm thiFarm;

  SelectProduct(this.name, this.thiFarm);

  @override
  _SelectProductState createState() => _SelectProductState();
}

class _SelectProductState extends State<SelectProduct> {
  final String query = r'''
          query get_prod($name: String!){
            categories(search:$name){
              id
              name
              image
              products{
                id
                name
                image
                unitsOfMeasure{
                  id
                  name
                  alternativeName
                }
              }
            }
          }
        ''';

  static List<SelectedProduct> products = new List<SelectedProduct>();

  static List<SelectedProduct> loadProducts(List products) {
    return products.map<SelectedProduct>((json) => SelectedProduct.fromJson(json)).toList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.black,
          child: Text("Choose a Product"),
        ),
      ),
      body: Query(
          options: QueryOptions(
              document: query,
              variables: <String, dynamic>{"name": widget.name}),
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
              print(result.data.data["categories"][0]["products"]);
              products = loadProducts(result.data.data["categories"][0]["products"]);
              print(products.length);
              return SingleChildScrollView(
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  children: products.map((product) {
                    return CustomProdCard(product, widget.thiFarm);
                  }).toList(),
                ),
              );
            }
          }),
    );
  }
}
