class Item{
  String _productname;
  String _productprice;
  String _productimage;
  Item(this._productname,this._productprice,this._productimage);

  Item.map(dynamic obj) {
    this._productname = obj["name"];
    this._productprice = obj["price"];
    this._productimage = obj["productImage"];
  }

  String get productname => _productname;
  String get productprice => _productprice;
  String get productimage => _productimage;
}