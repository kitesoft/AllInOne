import 'package:allinone/models/local.dart';

class Data {
  String _id;
  Local _local;
  Data(this._id, this._local);

  Data.map(dynamic obj) {
    this._id = obj["_id"];
    this._local = Local.map(obj["local"]);
  }

  String get id => _id;
  Local get local => _local;
}
