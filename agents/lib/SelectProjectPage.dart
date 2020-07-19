import 'package:agents/ViewPage.dart';
import 'package:agents/holders/UserRegView.dart';
import 'package:agents/models/Projects.dart';
import 'package:flutter/material.dart';
import 'package:agents/models/Users.dart';

class SelectProjectPage extends StatefulWidget {
  String name;
  String email;


  SelectProjectPage(this.name, this.email);

  @override
  _SelectProjectPageState createState() => _SelectProjectPageState();
}

class _SelectProjectPageState extends State<SelectProjectPage> {
  @override
  Widget build(BuildContext context) {
    Size ScreenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Project Summary"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: ScreenSize.height / 9.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/farm.jpg'))),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: ScreenSize.height / 8.9,
                  ),
                  Container(
                    height: ScreenSize.height / 12.5,
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              "${widget.name}",
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${widget.email}",
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: ScreenSize.width,
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.grey[200]),
                            bottom: BorderSide(color: Colors.grey[200]))),
                    padding: EdgeInsets.all(10.0),
                    height: ScreenSize.height / 13,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "My Projects",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: projectsData.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return ViewPage();
                            }));
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(projectsData[index].name),
                              trailing: Icon(Icons.navigate_next),
                            ),
                          ),
                        );
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
