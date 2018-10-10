class King{
  bool _note;
  King(this._note);

  King.map(dynamic obj) {
    this._note = obj["success"];
  }

  bool get note => _note;
}