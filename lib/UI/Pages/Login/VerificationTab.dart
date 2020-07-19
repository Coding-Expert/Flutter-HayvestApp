import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Components/AuthVerification.dart';
import 'Components/background.dart';

class VerificationTab extends StatefulWidget {
  VerificationTab({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _VerificationTabState createState() => _VerificationTabState();
}

class _VerificationTabState extends State<VerificationTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Background(),
            AuthVerification(),
          ],
        ));
  }
}