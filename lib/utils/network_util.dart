import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();
  var client = new http.Client();

  Future<dynamic> get(String url) {
    return http.get(url).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url,
      {Map<String, String> headers, Map body, encoding}) {
    return http
        .post(url, headers: headers, body: body, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> patch(String url,
      {Map<String, String> headers, Map body, encoding}) {
    return http
        .patch(url, headers: headers, body: body, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  // upload(File imageFile, String id) async {
  //   var stream =
  //       new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  //   var length = await imageFile.length();
  //   var uri = Uri.parse("http://172.16.1.35:6700/test/");
  //   var request = new http.MultipartRequest("POST", uri);
  //   var multipartFile = new http.MultipartFile('testImage', stream, length,
  //       filename: basename(imageFile.path));
  //   //request.fields['profile'] = 'nweiz@google.com';
  //   //request.files.add(new http.MultipartFile.fromBytes('profile', await imageFile.readAsBytes(), contentType: new MediaType('image', 'jpeg')));
  //   request.files.add(multipartFile);
  //   var response = await request.send();
  //   print(response.statusCode);
  //   response.stream.transform(utf8.decoder).listen((value) {
  //     print(value);
  //   });
  // }

  Future<bool> upload(File imageFile,String _name, String _mobile, String _address, String _bio, String id) async {
    Dio dio = new Dio();
    dio.options.baseUrl = "http://172.16.1.35:6700/test";
    FormData formData = new FormData.from({
      "imp":"$id",
      "testImage": new UploadFileInfo(imageFile, basename(imageFile.path), contentType: new ContentType('image', 'jpeg')),
      "name":"$_name",
      "mobile":"$_mobile",
      "address":"$_address",
      "bio":"$_bio"
    });
    Response response = await dio.post("/$id", data: formData);
    print(response.statusCode);
    if(response.statusCode == 201 || response.statusCode == 200){
      return true;
    }
    return false;
  }



}
