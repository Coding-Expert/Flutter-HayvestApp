
class PhoneModel{
  int _phoneNumber = 0;
  String _countryCode = "";

  options(){
    print("Model");
  }

  String get countryCode => _countryCode;

  int get phoneNumber => _phoneNumber;

  set countryCode(String value) {
    _countryCode = value;
  }

  set phoneNumber(int value) {
    _phoneNumber = value;
  }


}