import 'package:agents/holders/UserRegView.dart';
import 'package:flutter/material.dart';
import 'package:agents/models/Users.dart';

class ViewPage extends StatefulWidget {
  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  @override
  Widget build(BuildContext context) {
    Size ScreenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Agent Summary"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: ScreenSize.height / 4.0,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromRGBO(17, 153, 142, 1),
              Color.fromRGBO(56, 239, 125, 1)
            ])),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: ScreenSize.height / 18.2,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Agent Code:",
                          style: TextStyle(color: Colors.white, fontSize: 29),
                        ),
                        Text(
                          "0123",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.height / 15.2,
                  ),
                  Container(
                    height: 100,
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Users Registered:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                  Text(
                                    "45",
                                    style: TextStyle(fontSize: 24),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Amount Payable:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17)),
                                  Text("900", style: TextStyle(fontSize: 24))
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: DummyUsers.length,
                      itemBuilder: (context, index) {
                        return UsersRegListItem(DummyUsers[index]);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
