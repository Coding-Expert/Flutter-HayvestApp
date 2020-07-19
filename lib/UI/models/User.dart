class User {
  
  // Attributes
  String _name;
  String _email;
  String _address;
  String _tel;
  String _urlToImage;
  String _ccNumber;
  String _ccExpDate;
  bool _getNotifications;

  // Constructor
  User(this._name, this._email, this._urlToImage, this._tel, this._address, this._ccNumber, this._ccExpDate, this._getNotifications);

  // Mapping
  User.fromJSON(Map<String, dynamic> data) {
    this._name = data["name"];
    this._email = data["email"];
    this._tel = data["tel"];
    this._urlToImage = data["urlToImage"];
    this._address = data["address"];
    this._ccNumber = data["ccNumber"];
    this._ccExpDate = data["ccExpDate"];
    this._getNotifications = data["getNotifications"];
  }

  // Methods
  String get name => _name;

  String get urlImage => _urlToImage;

  String get tel => _tel;

  String get email => _email;

  String get address => _address;

  String get ccNumber => _ccNumber;

  String get ccExpDate => _ccExpDate;

  bool get getNotifications => _getNotifications;

  setName(String value){ _name = value;}

  setUrlImage(String value){ _urlToImage = value;}

  setTel(String value){ _tel = value;}

  setEmail(String value){ _email = value;}

  setAddress(String value){ _address = value;}

  setCCNumber(String value){ _ccNumber = value;}

  setCCExpDate(String value){ _ccExpDate = value;}

  setNotifications(bool value){ _getNotifications = value;}
}
