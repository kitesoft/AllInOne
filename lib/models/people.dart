class People{
  String _a;
  String _b;
  String _c;
  String _d;
  String _e;
  People(this._a,this._b,this._c,this._d,this._e);

  People.map(dynamic obj) {
    this._a = obj["name"];
    this._b = obj["mobile"];
    this._c = obj["address"];
    this._d = obj["bio"];
    this._e = obj["testImage"];
  }

  String get a => _a;
  String get b => _b;
  String get c => _c;
  String get d => _d;
  String get e => _e;
}
