class Detail {
  String _id;
  String _token;
  String _email;
  String _password;

  Detail(this._id, this._token, this._email, this._password);

  Detail.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._token = map['token'];
    this._email = map['email'];
    this._password = map['password'];
  }

  String get id => _id;
  String get token => _token;
  String get email => _email;
  String get password => _password;
}
