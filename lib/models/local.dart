class Local {
  String _email;
  String _password;

  Local(this._email, this._password);

  Local.map(dynamic obj) {
    this._email = obj["email"];
    this._password = obj["password"];
  }

  String get email => _email;
  String get password => _password;
}
