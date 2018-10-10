import 'package:allinone/models/photos.dart';
import 'package:allinone/models/item.dart';
import 'package:flutter/material.dart';
import 'package:allinone/screens/product/product_screen_presenter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ProductScreenState();
  }
}

class ProductScreenState extends State<ProductScreen>
    implements ProductScreenContract {
  ProductScreenPresenter _shark;
  int i;
  List<Item> p1 = [];
  void _maro() {
    _shark = new ProductScreenPresenter(this);
    _shark.doHeavy();
  }

  @override
  void initState() {
    _maro();
    super.initState();
    p1 = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
          child: new StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) => new Container(
            color: Colors.transparent,
            child: new Column(
              children: <Widget>[
                new Center(
                child:new Card(
                  color: Colors.yellow,
                  elevation: 15.0,
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      new Image(
                          width: 200.0,
                          height: 155.0,
                          image: new CachedNetworkImageProvider(
                              "http://172.16.1.35:6700/uploads/" +
                                  "${p1[index].productimage}")),
                      new Text('${p1[index].productname}',style: new TextStyle(color: Colors.white)),
                      new Text('${p1[index].productprice}',style: new TextStyle(color: Colors.white))
                    ],
                  ),
                ),
            ),
              ],
            )),
        staggeredTileBuilder: (int index) =>
            new StaggeredTile.count(2, index.isEven ? 2 : 2),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      )),
    );
  }

  @override
  void onGetPhotosError(String errorTxt) {
    // TODO: implement onGetPhotosError
  }

  @override
  void onGetPhotosSuccess(Photos photos) {
    setState(() {
      p1 = photos.photos;
    });
    print("$p1[0].productimage");
    print("${p1[0].productname}");
    print("${p1[0].productprice}");
    print("${p1[0]}");
  }
}
