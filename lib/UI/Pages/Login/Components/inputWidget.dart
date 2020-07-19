import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_classifiedappclone/Model/phoneDetails.dart';

class InputWidget extends StatelessWidget {
  final double topRight;
  final double bottomRight;

  InputWidget(this.topRight, this.bottomRight);

  @override
  Widget build(BuildContext context) {
    var phoneModel = Provider.of<PhoneModel>(context);
    return Padding(
      padding: EdgeInsets.only(right: 40, bottom: 30),
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        child: Material(
          elevation: 10,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  bottomRight: Radius.circular(bottomRight),
                  topRight: Radius.circular(topRight))),
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
            child: TextField(
              keyboardType: TextInputType.phone,
              onChanged: (number){
                phoneModel.phoneNumber = int.parse(number);
                print(phoneModel.phoneNumber);
              },
              decoration: InputDecoration(
                  icon: CountryCodePicker(
                    onChanged: (code) {
                      phoneModel.countryCode = code.toString();
                      print(phoneModel.countryCode);
                    },
                    initialSelection: "KE",
                    favorite: ["KE", "TZ", "SS", "BI", "SS", "RW"],
                  ),
                  border: InputBorder.none,
                  hintText: "0712345678",
                  hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)),
            ),
          ),
        ),
      ),
    );
  }
}
