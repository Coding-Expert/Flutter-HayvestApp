import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/Model/Product.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/Buying/ProductCard.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/CustomCategory.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/CustomProduct.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ShowProduct extends StatefulWidget {
  String name = null;
  List Buyer = null;

  ShowProduct(this.Buyer, {this.name});

  @override
  _ShowProductState createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  final String Categquery = r'''
          query get_prod($name: String!){
            categories(search:$name){
              id
              name
              image
              products{
                id
                name
                image
              }
            }
          }
        ''';

  final String prods = r'''
          query{
              products{
              id
              name
              image
            }
          }
      ''';

  static List<Product> products = new List<Product>();

  static List<Product> loadProducts(List products) {
    return products.map<Product>((json) => Product.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    QueryOptions categOpt = QueryOptions(
        document: Categquery,
        variables: <String, dynamic>{"name": widget.name});
    QueryOptions prodOption = QueryOptions(
      document: prods,
    );
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.black,
          child: Text("Choose a Product"),
        ),
      ),
      body: Query(
          options: widget.name == null ? prodOption : categOpt,
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
              if (widget.name == null) {
                print('Getting all the products');
                print(result.data.data);
                products = loadProducts(result.data.data["products"]);
              } else {
                print(result.data.data["categories"][0]["products"]);
                products =
                    loadProducts(result.data.data["categories"][0]["products"]);
              }
              products.sort((a, b) => a.name.compareTo(b.name));
              print(products.length);
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          left: 40, right: 40, bottom: 20, top: 20),
                      child: Material(
                          borderRadius: BorderRadius.circular(30.0),
                          elevation: 8,
                          child: TextFormField(
                            cursorColor: Colors.orange[200],
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              prefixIcon: Icon(Icons.search,
                                  color: Colors.orange[200], size: 30),
                              hintText: "What're you looking for?",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        children: products.map((product) {
                          return ProductCard(widget.Buyer, product);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
