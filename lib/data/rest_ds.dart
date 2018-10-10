import 'dart:async';

import 'package:allinone/utils/network_util.dart';
import 'package:allinone/models/user.dart';
import 'package:allinone/models/people.dart';
import 'package:allinone/models/photos.dart';
import 'package:allinone/models/king.dart';
import 'dart:io';


class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL_LOGIN = "http://172.16.1.35:6700/user/login";
  static final BASE_URL_SIGNUP = "http://172.16.1.35:6700/user/signup";
    static final BASE_URL_NOTIFICATION = "http://172.16.1.35:6700/user/sendNotification";
  static final BASE_URL_UPDATE = "http://172.16.1.35:6700/test/";
  static final BASE_URL_UPDATE_PHOTO = "http://172.16.1.35:6700/user/pic/";
  static final BASE_URL_GET_PHOTOS = "http://172.16.1.35:6700/products/";
  Future<User> login(String email, String password) {
    return _netUtil.post(BASE_URL_LOGIN,
        body: {"email": email, "password": password}).then((dynamic res) {
      print(res.toString());
      if (res["error"] != null) throw new Exception(res["error_msg"]);
      return new User.map(res);
    });
  }

  Future<User> signup(String email, String password) {
    return _netUtil.post(BASE_URL_SIGNUP, body: {
      "email": email,
      "password": password,
    }).then((dynamic res) {
      print(res.toString());
      if (res["error"] != null) throw new Exception(res["error_msg"]);
      return new User.map(res);
    });
  }

    Future<People> hard(String _id) {
    return _netUtil.get(BASE_URL_UPDATE+"$_id").then((dynamic res) {
      print(res.toString());
      if (res["error"] != null) throw new Exception(res["error_msg"]);
      return new People.map(res["critical"]);
    });
  }

      Future<Photos> heavy() {
    return _netUtil.get(BASE_URL_GET_PHOTOS).then((dynamic res) {
      print(res.toString());
      if (res["error"] != null) throw new Exception(res["error_msg"]);
      return new Photos.map(res["products"]);
    });
  }

    Future<King> rocky(String _fcmtoken) {
    return _netUtil.post(BASE_URL_NOTIFICATION, body: {
      "fcmtoken": _fcmtoken,
    }).then((dynamic res) {
      print(res.toString());
      if (res["error"] != null) throw new Exception(res["error_msg"]);
      return new King.map(res);
    });
  }

}
