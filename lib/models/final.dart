class Final {
  String _id;
  String _token;
  String _email;
  String _password;
  int _info;

  Final(this._info, this._id, this._token, this._email, this._password);

  String get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["active"] = _info;
    map["token"] = _token;
    map["email"] = _email;
    map["password"] = _password;
    return map;
  }
}
