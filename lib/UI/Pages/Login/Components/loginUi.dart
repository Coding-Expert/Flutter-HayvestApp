import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/Model/phoneDetails.dart';
import 'package:flutter_classifiedappclone/UI/Pages/Login/Components/inputWidget.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  String PhoneNumber;
  String CountryCode = '+254';
  String FullNumber;
  String SMSCode;
  String VerificationID;

  Future<void> verifyPhone(BuildContext context) async {
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      this.VerificationID = verId;
    };

    final PhoneCodeSent phoneCodeSent = (String verId, [int forceCodeResend]) {
      this.VerificationID = verId;
      smsCodeDialog(context).then((value) => print("Signed In"));
    };

    final PhoneVerificationCompleted phoneVerificationCompleted =
        (AuthCredential credential) async {
      AuthResult result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("Success");
    };

    final PhoneVerificationFailed phoneVerificationFailed =
        (AuthException exception) {
      print("${exception.message}");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.FullNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter Code"),
            content: TextField(
              onChanged: (value) {
                this.SMSCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              FlatButton(
                child: Text("Verify"),
                onPressed: () {
                  FirebaseAuth.instance.currentUser().then((user) {
                    if (user != null) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/homepage');
                    } else {
                      Navigator.of(context).pop();
                      signIn();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  signIn() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: this.VerificationID, smsCode: this.SMSCode);
    final AuthResult result =
        await FirebaseAuth.instance.signInWithCredential(credential);

    FirebaseUser user = result.user;
  }

  @override
  Widget build(BuildContext context) {
    var phoneModel = Provider.of<PhoneModel>(context);
    return Column(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.3),
        ),
        Column(
          children: <Widget>[
            ///holds email header and inputField
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 40, bottom: 10),
                  child: Text(
                    "Phone Number",
                    style: TextStyle(fontSize: 16, color: Color(0xFF999A9A)),
                  ),
                ),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 40, bottom: 30),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        child: Material(
                          elevation: 10,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(30.0),
                                  topRight: Radius.circular(10.0))),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 20, top: 10, bottom: 10),
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              onChanged: (number) {
                                this.PhoneNumber = number;
                              },
                              decoration: InputDecoration(
                                  icon: CountryCodePicker(
                                    onChanged: (code) {
                                      this.CountryCode = code.dialCode;
                                    },
                                    initialSelection: "KE",
                                    favorite: [
                                      "KE",
                                      "TZ",
                                      "SS",
                                      "BI",
                                      "SS",
                                      "RW"
                                    ],
                                  ),
                                  border: InputBorder.none,
                                  hintText: "0712345678",
                                  hintStyle: TextStyle(
                                      color: Color(0xFFE1E1E1), fontSize: 14)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(right: 50),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Text(
                                'Enter your phone number to continue...',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Color(0xFFA0A0A0), fontSize: 12),
                              ),
                            )),
                            GestureDetector(
                              onTap: () {
                                String intnlPhone =
                                    this.CountryCode + this.PhoneNumber.substring(1);
                                this.FullNumber = intnlPhone;
                                verifyPhone(context);
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: ShapeDecoration(
                                    shape: CircleBorder(),
                                    gradient: LinearGradient(
                                        colors: signInGradients,
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: 40,
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ))
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 50),
            ),
          ],
        )
      ],
    );
  }
}

Widget roundedRectButton(
    String title, List<Color> gradient, bool isEndIconVisible) {
  return Builder(builder: (BuildContext mContext) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Stack(
        alignment: Alignment(1.0, 0.0),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(mContext).size.width / 1.7,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            padding: EdgeInsets.only(top: 16, bottom: 16),
          ),
          Visibility(
            visible: isEndIconVisible,
            child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: ImageIcon(
                  AssetImage("assets/ic_forward.png"),
                  size: 30,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  });
}

const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];

const List<Color> signUpGradients = [
  Color(0xFFFF9945),
  Color(0xFFFc6076),
];
