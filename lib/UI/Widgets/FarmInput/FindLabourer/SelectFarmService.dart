import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/FarmInput/FindLabourer/ServiceShowCase.dart';
import 'package:graphql/client.dart';

class SelectFarmService extends StatefulWidget {
  @override
  _SelectFarmServiceState createState() => _SelectFarmServiceState();
}

class _SelectFarmServiceState extends State<SelectFarmService> {
  bool Loading = true;
  List services = [];

  void getLabourServices() async {
    String query = r"""
    {
      services{
        id
        title
        description
      }
    }
  """;

    final HttpLink _httplink =
        HttpLink(uri: "http://34.76.96.215:8000/graphql/");
    final Link _link = _httplink;
    final GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: _link,
    );
    var result = await _client.query(QueryOptions(document: query));
    if (result.errors != null) {
      print("Errors Occured");
    }
    if (result.data == null) {
      print("No data Fetched");
    } else {
      setState(() {
        services = result.data["services"];
        Loading = false;
      });
    }
  }

  void FindService(servName) async {
    String query = r'''
      query getService($name: String!){
        services(name: $name){
          id
          title
          description
        }
      }
    ''';
    final HttpLink _httplink =
        HttpLink(uri: "http://34.76.96.215:8000/graphql/");
    final Link _link = _httplink;
    final GraphQLClient _client = GraphQLClient(
      cache: InMemoryCache(),
      link: _link,
    );
    var result = await _client
        .query(QueryOptions(document: query, variables: {"name": servName}));
    if (result.errors != null) {
      print("Errors Occured");
    }
    if (result.data == null) {
      print("No data Fetched");
    } else {
      setState(() {
        services = result.data["services"];
        Loading = false;
      });
    }
  }

  @override
  void initState() {
    getLabourServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select Service"),
        ),
        body: Loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
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
                            onChanged: (value) {
                              FindService(value);
                            },
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
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        return ServiceShowcase(services[index]);
                      },
                    )
                  ],
                ),
              ));
  }
}
