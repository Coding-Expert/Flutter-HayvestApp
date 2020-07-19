import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/Model/phoneDetails.dart';
import 'package:flutter_classifiedappclone/UI/Pages/Login/PhoneLogin.dart';
import 'package:flutter_classifiedappclone/UI/Pages/Login/VerificationTab.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  TabController controller;
  PhoneModel phoneModel;

  @override
  void initState() {
    controller = new TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PhoneModel>.value(value: phoneModel,)
      ],
          child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new TabBarView(controller: controller,
            children: <Widget>[
              PhoneLoginPage(),
             VerificationTab(),
            ]),
      ),
    );
  }
}
