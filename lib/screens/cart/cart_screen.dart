import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:allinone/models/cart_item.dart';
import 'package:allinone/redux/reducers.dart';
import 'package:allinone/screens/wallet/shooping_cart.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';

class ShoppingApp extends StatelessWidget {
  
  final DevToolsStore<List<CartItem>> store;

  ShoppingApp(this.store);

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData.dark(),
        home: new ShoppingCart(store: store),
      ),
    );
  }
}