import 'package:allinone/models/data.dart';

class User {
  String _id;
  String _token;
  Data _data;
  User(this._id,this._token, this._data);

  User.map(dynamic obj) {
    this._id = obj["_id"];
    this._token = obj["token"];
    this._data = Data.map(obj["user"]);
  }

  String get id => _id;
  String get token => _token;
  Data get data => _data;
}
