import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/UI/Widgets/FarmInput/FindLabourer/ServiceInput.dart';

class ServiceShowcase extends StatefulWidget {
  Map<String, dynamic> service;

  ServiceShowcase(this.service);

  @override
  _ServiceShowcaseState createState() => _ServiceShowcaseState();
}

class _ServiceShowcaseState extends State<ServiceShowcase> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          expanded ? expanded = false : expanded = true;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]))),
        child: AnimatedCrossFade(
            firstChild: ListTile(
              title: Text(widget.service["title"]),
              trailing: IconButton(
                  icon: Icon(Icons.navigate_next),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return (ServiceDetail(widget.service));
                        }));
                  }),
            ),
            secondChild: ListTile(
              title: Text(widget.service["title"]),
              subtitle: Text(widget.service["description"]),
              trailing: IconButton(
                  icon: Icon(Icons.navigate_next),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return (ServiceDetail(widget.service));
                        }));
                  }),
            ),
            crossFadeState:
                expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300)),
      ),
    );
  }
}
