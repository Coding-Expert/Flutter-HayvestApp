import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/Model/Farm.dart';
import 'package:flutter_classifiedappclone/Model/Unit.dart';
import 'package:flutter_classifiedappclone/Model/productModel.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ProductDetails extends StatefulWidget {
  Farm thisFarm;
  SelectedProduct product;

  ProductDetails(this.thisFarm, this.product);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final String query = r'''
          query get_prod_det($name: String!){
            products(search: $name){
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
      ''';
  Unit initUnit;
  TextEditingController itemPriceController = new TextEditingController();

  TextEditingController itemAmountController = new TextEditingController();

  static List<Unit> loadUnits(List Units) {
    return Units.map<Unit>((json) => Unit.fromJson(json)).toList();
  }

  submitProduct(int productId, Unit unit) async {
    final String createSaleMutation = r'''
    mutation createSale($amount: Float!, 
                        $county: Int!
                        $farm: Int!
                        $price: Float!
                        $product: Int!
                        $unit: Int!){
      createSale(amount: $amount,
                 countyId: $county, 
                 farmId: $farm, 
                 price: $price,
                 productId: $product, 
                 unitId: $unit)
      {
        sale{
          id
          amount
        }
        
      }
    }
    ''';
    final HttpLink _htppLink =
        HttpLink(uri: "http://34.76.96.215:8000/graphql/");
    final GraphQLClient client =
        GraphQLClient(link: _htppLink, cache: InMemoryCache());
    final QueryOptions options = QueryOptions(document: createSaleMutation, variables: {
      "amount": itemAmountController.text,
      "county": widget.thisFarm.county.id,
      "farm": widget.thisFarm.id,
      "price": itemPriceController.text,
      "product": productId,
      "unit": unit.id
    });
    final response = await client.query(options);
    if (response.errors != null) {
      print("errors Found");
      return false;
    }
    if (response.data == null) {
      print("Null data");
      return false;
    } else {
      print("Completed");
      return true;
    }
  }

  @override
  void initState() {
    initUnit = widget.product.unitsOfMeasure[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Unit> units = widget.product.unitsOfMeasure;
    return Scaffold(
//      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Specify your Details"),
      ),
      body: SingleChildScrollView(
        child:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    widget.product.image,
                    fit: BoxFit.fitWidth,
                    height: 200,
                  ),
                ],
              ),
              Text(
                "Item Name: ${widget.product.name}",
                style: TextStyle(fontSize: 20),
              ),
              Divider(),
              SizedBox(height: 10),
              Text("Specify your selling price"),
              Container(
                  padding: EdgeInsets.only(
                      left: 8, right: 8, top: 20, bottom: 10),
                  child: new Theme(
                    data: new ThemeData(
                      primaryColor: Colors.blueGrey[500],
                      primaryColorDark: Colors.blueGrey[700],
                    ),
                    child: new TextField(
                      controller: itemPriceController,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: new BorderSide(
                                color: Colors.blueGrey[700],
                                width: 2,
                                style: BorderStyle.solid)),
                        hintText: "Price you are selling",
                        prefixText: "KSh.",
                        labelText: "Item Price",
                        prefixIcon: Icon(
                          Icons.account_balance_wallet,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text("Unit of Sale"),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: 8, right: 8, top: 10, bottom: 10),
                child: Theme(
                  data: new ThemeData(
                    primaryColor: Colors.blueGrey[500],
                    primaryColorDark: Colors.blueGrey[700],
                  ),
                  child: DropdownButton<Unit>(
                    isExpanded: true,
                    elevation: 5,
                    value: initUnit,
                    onChanged: (Unit cunit) {
                      initUnit = cunit;
                      this.setState(() {
                        initUnit = cunit;
                      });
                      print(initUnit.name);
                    },
                    items:
                    units.map<DropdownMenuItem<Unit>>((Unit sunit) {
                      return DropdownMenuItem<Unit>(
                        key: Key("key${sunit.id}"),
                        value: sunit,
                        child: Text(" ${sunit.name}"),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(
                      left: 8, right: 8, top: 20, bottom: 10),
                  child: new Theme(
                    data: new ThemeData(
                      primaryColor: Colors.blueGrey[500],
                      primaryColorDark: Colors.blueGrey[700],
                    ),
                    child: new TextField(
                      controller: itemAmountController,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: new BorderSide(
                                color: Colors.blueGrey[700],
                                width: 2,
                                style: BorderStyle.solid)),
                        hintText: "Quantity you are selling",
                        labelText: "Quantity Selling",
                        prefixIcon: Icon(
                          Icons.store,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton.extended(
                      backgroundColor: Colors.greenAccent,
                      onPressed: () {
                        submitProduct(widget.product.id, initUnit);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      label: Text("Complete"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
