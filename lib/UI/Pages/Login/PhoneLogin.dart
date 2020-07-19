import 'package:flutter/material.dart';
import 'Components/background.dart';
import 'Components/loginUi.dart';

class PhoneLoginPage extends StatefulWidget {
  PhoneLoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PhoneLoginPageState createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Background(),
            Login(),
          ],
        ));
  }
}