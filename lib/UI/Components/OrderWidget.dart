import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/UI/blocs/OrderBloc.dart';
import 'package:flutter_classifiedappclone/UI/models/Order.dart';

// Appears on tapping "add to cart"
class OrderWidget extends StatefulWidget {
  final double size;
  OrderWidget({Key key, this.size}) : super(key: key);
  _OrderWidget createState() => _OrderWidget();
}

class _OrderWidget extends State<OrderWidget> {
  OrderBloc _orderBloc = new OrderBloc();

  Widget build(BuildContext context) {
    return new Container(
        height: widget.size,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),

        // Getting the current order
        child: new StreamBuilder(
            stream: _orderBloc.currentOrder,
            builder: (context, AsyncSnapshot<Order> snapshot) {
              if (snapshot.data == null)
                return new Container(width: 0, height: 0);
              return new Padding(
                  padding: EdgeInsets.all(20),
                  child: new Center(
                    child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Flexible(
                              flex: 3,
                              child: new Padding(
                                  padding: EdgeInsets.only(right: 20),

                                  // Displaying sandwich title
                                  child: new Text("${snapshot.data.item.title}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color:
                                              Theme.of(context).accentColor)))),
                          new Flexible(
                              flex: 3,
                              child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[

                                    // Displaying sandwich price
                                    new Text(
                                        "\$${snapshot.data.price.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color:
                                                Theme.of(context).accentColor)),

                                    // To decrease the number of sandwiches by one
                                    new Container(
                                        padding: EdgeInsets.only(top: 10),
                                        child: new Row(children: <Widget>[
                                          new SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: new FlatButton(
                                                  onPressed:
                                                      _orderBloc.decrement,
                                                  child: new Icon(Icons.remove,
                                                      size: 10),
                                                  color: Colors.white)),

                                          // To display the quantity of the chosen sandwich
                                          new Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: new Text(
                                                  "${snapshot.data.quantity}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .accentColor))),

                                          // To increase the number of sandwiches by one
                                          new SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: new FlatButton(
                                                  onPressed:
                                                      _orderBloc.increment,
                                                  child: new Icon(Icons.add,
                                                      size: 10),
                                                  color: Colors.white)),
                                        ]))
                                  ]))
                        ]),
                  ));
            }));
  }
}
