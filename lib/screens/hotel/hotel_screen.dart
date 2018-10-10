import 'package:allinone/models/king.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:allinone/screens/hotel/hotel_screen_presenter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HotelScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HotelScreenState();
  }
}

class HotelScreenState extends State<HotelScreen>
    implements HotelScreenContract {
  String textValue = 'Hello World !';
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  HotelScreenPresenter _fish;

  @override
  void initState() {
    _hallabol();
    super.initState();
  }

  _hallabol() {
    _fish = new HotelScreenPresenter(this);
    _fish.doRocky(
        "f7GH4H_xBAM:APA91bGv_LTUmckBQL6w1Y35YQxbbKHiQ3tSsjw_opyXcJa1TA3c5u9SgjsSr8NGIVXg-bFmbovlkjyQMDTX8TFQ31P9O17yygxssGNOxHEn2-nbpewvZIurYGtFdV6q3lIJ1YjNfVWM");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child:new Text("Hey! You will get some notification", style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Colors.blue),
      ),
      ),
    );
  }

  @override
  void onGetNotificationError(String errorTxt) {}

  @override
  void onGetNotificationSuccess(King king) {
    if (king.note) {
      var android = new AndroidInitializationSettings('mipmap/ic_launcher');
      var ios = new IOSInitializationSettings();
      var platform = new InitializationSettings(android, ios);
      flutterLocalNotificationsPlugin.initialize(platform);

      firebaseMessaging.configure(
        onLaunch: (Map<String, dynamic> msg) {
          print(" onLaunch called ${(msg)}");
        },
        onResume: (Map<String, dynamic> msg) {
          print(" onResume called ${(msg)}");
        },
        onMessage: (Map<String, dynamic> msg) {
          showNotification(msg);
          print(" onMessage called ${(msg)}");
        },
      );
      firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, alert: true, badge: true));
      firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings setting) {
        print('IOS Setting Registed');
      });
      firebaseMessaging.getToken().then((token) {
        print(token);
      });

      // _firebaseMessaging.configure(
      //   onMessage: (Map<String, dynamic> message) {
      //     print('on message $message');
      //   },
      //   onResume: (Map<String, dynamic> message) {
      //     print('on resume $message');
      //   },
      //   onLaunch: (Map<String, dynamic> message) {
      //     print('on launch $message');
      //   },
      // );
      // _firebaseMessaging.requestNotificationPermissions(
      //     const IosNotificationSettings(sound: true, badge: true, alert: true));
      // _firebaseMessaging.getToken().then((token) {
      //   print(token);
      // });

    }
  }

  showNotification(Map<String, dynamic> msg) async {
    print(msg);
    var android = new AndroidNotificationDetails(
      'sdffds dsffds',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, msg["ayush"], "Welcome", platform);
  }

  // update(String token) {
  //   print(token);
  //   DatabaseReference databaseReference = new FirebaseDatabase().reference();
  //   databaseReference.child('fcm-token/${token}').set({"token": token});
  //   textValue = token;
  //   setState(() {});
  // }
}
