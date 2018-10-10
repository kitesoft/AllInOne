import 'package:allinone/models/item.dart';

class Photos{

  List<Item> _photos = [];
  var i;

  Photos(this._photos);

  Photos.map(dynamic obj) {
    for( i=0 ; i<10 ; i++ ) {
      this._photos.add(Item.map(obj[i]));
      print(_photos[i]);
    }
  }

  List<Item> get photos => _photos;
}