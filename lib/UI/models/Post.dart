// The Notification model
class Post {
  
  // Attributes
  int _id;
  String _title;
  String _desc;
  String _imageUrl;

  // Constructor
  Post(this._id, this._title, this._desc, this._imageUrl);

  // Mapping
  Post.fromJSON(Map<String, dynamic> data) {
    this._id = data["id"];
    this._title = data["title"];
    this._desc = data["desc"];
    this._imageUrl = data["imageUrl"];
  }

  // Methods
  int get id => _id;

  String get title => _title;

  String get desc => _desc;

  String get imageUrl => _imageUrl;
}
