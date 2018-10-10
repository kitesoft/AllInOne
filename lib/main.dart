import 'package:flutter/material.dart';
import 'package:allinone/screens/home/home_screen.dart';
import 'package:allinone/screens/login/login_screen.dart';
import 'package:allinone/screens/signup/signup_screen.dart';
import 'package:allinone/screens/main/main_screen.dart';
import 'package:map_view/map_view.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:allinone/models/cart_item.dart';
import 'package:allinone/redux/reducers.dart';
import 'package:allinone/screens/wallet/shooping_cart.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

String selectedUrl = 'https://flutter.io';


void main() {
    final store = new DevToolsStore<List<CartItem>>(cartItemsReducer,
      initialState: new List());
     MapView.setApiKey("AIzaSyBR4P3_68H4QDUqoa7Mx3tRXbQBf25vzkA");
     runApp(new AllInOne());
   }

class AllInOne extends StatelessWidget {
  var routes = <String, WidgetBuilder>{
    '/login': (BuildContext context) => new LoginScreen(),
    '/home': (BuildContext context) => new HomeScreen(),
    '/signup': (BuildContext context) => new SignupScreen(),
    '/main': (BuildContext context) => new MainScreen(),
    '/widget': (_) => new WebviewScaffold(
              url: selectedUrl,
              appBar: new AppBar(
                title: const Text('Widget webview'),
              ),
              withZoom: true,
              withLocalStorage: true,
            )
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'AllInOne',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.yellow,
      ),
      home: LoginScreen(),
      routes: routes,
    );
  }
}
