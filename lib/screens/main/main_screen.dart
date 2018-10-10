import 'package:flutter/material.dart';
import 'package:allinone/screens/home/home_screen.dart';
import 'package:allinone/screens/product/product_screen.dart';
import 'package:allinone/screens/hotel/hotel_screen.dart';
import 'package:allinone/screens/shop/shop_screen.dart';
import 'package:allinone/screens/movie/movie_screen.dart';



class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {

  int _currentIndex = 0;

  final List<Widget> _children = [
    new ProductScreen(),
    new HotelScreen(),
    new ShopScreen(),
    new MovieScreen(),
    new HomeScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ALL IN ONE', textAlign: TextAlign.center),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Ayush Mahajan",
                  style: new TextStyle(color: Colors.white)),
              accountEmail: new Text("ayush@gmail.com",
                  style: new TextStyle(color: Colors.white)),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.deepOrange,
              ),
              decoration: new BoxDecoration(color: Colors.deepPurple),
            ),
            new ListTile(
              title: new Text("Book Cab"),
              trailing: new Icon(Icons.drive_eta),
              onTap: () {},
            ),
            new Divider(),
            new ListTile(
              title: new Text("Shopping"),
              trailing: new Icon(Icons.shopping_basket)
            ),
            new Divider(),
            new ListTile(
              title: new Text("Movie"),
              trailing: new Icon(Icons.movie),
            ),
            new Divider(),
            new ListTile(
              title: new Text("Wallet"),
              trailing: new Icon(Icons.account_balance_wallet),
            ),
            new Divider(),
            new ListTile(
              title: new Text("Donate"),
              trailing: new Icon(Icons.help),
            ),
            new Divider(),
            new ListTile(
              title: new Text("Close"),
              trailing: new Icon(Icons.close),
              onTap: () => Navigator.of(context).pop(),
            ),
            new Divider(),
          ],
        ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.blue,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Colors.blue,
            textTheme: Theme.of(context).textTheme.copyWith(
                caption: new TextStyle(
                    color: Colors
                        .white))), // sets the inactive color of the `BottomNavigationBar`
        child: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            new BottomNavigationBarItem(
              icon: Icon(Icons.wb_sunny),
              title: Text('Products'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.hotel),
              title: Text('Hotels'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.map),
              title: Text('Shop'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.movie),
              title: Text('Movie'),
            ),
            new BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text('Profile'))
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
