import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewLogin extends StatefulWidget {
  @override
  _NewLoginState createState() => _NewLoginState();
}

class _NewLoginState extends State<NewLogin> {
  String PhoneNumber = "";
  String CountryCode = '+254';
  String FullNumber = "";
  String SMSCode = "";
  String VerificationID = "";
  bool Verifying = false;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController SMSCodeController = TextEditingController();

  Future<void> verifyPhone(BuildContext context) async {
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      this.VerificationID = verId;
    };

    final PhoneCodeSent phoneCodeSent = (String verId, [int forceCodeResend]) {
      this.VerificationID = verId;
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

  signIn() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: this.VerificationID, smsCode: this.SMSCode);
    final AuthResult result =
        await FirebaseAuth.instance.signInWithCredential(credential);
    FirebaseUser user = result.user;
    Navigator.of(context).pushReplacementNamed('/homepage');
  }

  @override
  Widget build(BuildContext context) {
    Size ScreenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/farm.jpg'))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: ScreenSize.height / 14,
                  ),
                  Container(
                    height: ScreenSize.height / 5,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/Hayvest.png'))),
                  ),
                  SizedBox(
                    height: ScreenSize.height / 15,
                  ),
                  Container(
                    child: Card(
                      color: Color.fromRGBO(255, 255, 255, 0.8),
                      child: AnimatedCrossFade(
                          firstChild: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(
                                    "Login",
                                    style: TextStyle(fontSize: 23),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  onChanged: (number) {
                                    setState(() {
                                      this.PhoneNumber = number;
                                    });
                                  },
                                  controller: phoneNumberController,
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
                                      border: new OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: new BorderSide(
                                              color: Colors.blueGrey[700],
                                              width: 2,
                                              style: BorderStyle.solid)),
                                      hintText: "0712345678",
                                      hintStyle: TextStyle(
                                          color: Color(0xFFE1E1E1),
                                          fontSize: 14)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: RaisedButton(
                                    onPressed: (this.PhoneNumber.isEmpty)
                                        ? null
                                        : () {
                                            setState(() {
                                              this.Verifying = true;
                                            });
                                            String intnlPhone =
                                                this.CountryCode +
                                                    phoneNumberController.text
                                                        .substring(1);
                                            this.FullNumber = intnlPhone;
                                            verifyPhone(context);
                                          },
                                    child: Text("Login"),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                          secondChild: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(
                                    "Login",
                                    style: TextStyle(fontSize: 23),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  onChanged: (number) {
                                    this.PhoneNumber = number;
                                  },
                                  controller: phoneNumberController,
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
                                      border: new OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: new BorderSide(
                                              color: Colors.blueGrey[700],
                                              width: 2,
                                              style: BorderStyle.solid)),
                                      hintText: phoneNumberController.text,
                                      enabled: false,
                                      hintStyle: TextStyle(
                                          color: Color(0xFFE1E1E1),
                                          fontSize: 14)),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          this.Verifying = false;
                                        });
                                      },
                                      child: Text(
                                        "Change Number?",
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                      ))
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  onChanged: (number) {
                                    setState(() {
                                      this.SMSCode = number;
                                    });
                                  },
                                  controller: SMSCodeController,
                                  decoration: InputDecoration(
                                      border: new OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: new BorderSide(
                                              color: Colors.blueGrey[700],
                                              width: 2,
                                              style: BorderStyle.solid)),
                                      hintText: "Verification Code",
                                      hintStyle: TextStyle(
                                          color: Color(0xFFE1E1E1),
                                          fontSize: 14)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: RaisedButton(
                                    onPressed: this.SMSCode.isEmpty
                                        ? null
                                        : () {
                                            FirebaseAuth.instance
                                                .currentUser()
                                                .then((user) {
                                              if (user != null) {
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        '/homepage');
                                              } else {
                                                signIn();
                                              }
                                            });
                                          },
                                    child: Text("Verify"),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                          crossFadeState: this.Verifying
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: Duration(milliseconds: 230)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
