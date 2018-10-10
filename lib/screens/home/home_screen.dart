import 'package:allinone/models/user.dart';
import 'package:allinone/models/people.dart';
import 'package:allinone/models/detail.dart';
import 'package:allinone/screens/home/home_screen_presenter.dart';
import 'package:flutter/material.dart';
import 'package:allinone/data/database_helper.dart';
import 'package:allinone/screens/login/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:allinone/utils/ensure_visible_when_focused.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:allinone/utils/network_util.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _HomeScreenState extends State<HomeScreen> implements HomeScreenContract {
  final fKey = new GlobalKey<FormState>();
  final sKey = new GlobalKey<ScaffoldState>();
  String _name, _gender, _mobile, _address, _bio;
  String _ee="";
  DateTime _dob;
  List<CameraDescription> cameras;
  CameraController controller;
  AppState state;
  File imageFile;
  FocusNode _focusNodeName = new FocusNode();
  FocusNode _focusNodeEmail = new FocusNode();
  FocusNode _focusNodeMobile = new FocusNode();
  FocusNode _focusNodeAddress = new FocusNode();
  FocusNode _focusNodeBio = new FocusNode();
  BuildContext _ctx;
  String dateSlug = '01-01-1995';

  DateTime _date = new DateTime.now();

  bool isVideo = false;
  VoidCallback listener;
  final TextEditingController _currencyController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController mobileController = new TextEditingController();
  final TextEditingController addressController = new TextEditingController();
  final TextEditingController bioController = new TextEditingController();
  int _radioValue = 0;

  static const EURO_MUL = 0.86;
  static const POUND_MUL = 0.75;
  static const YEN_MUL = 110.63;
  bool jack;
  double _result = 0.0;
  String _textResult = '';

  HomeScreenPresenter _whale;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _result = _currencyCalculate(_currencyController.text, EURO_MUL);
          if (_result > -1.0) {
            _textResult =
                '${_currencyController.text} USD = ${_result.toStringAsFixed(3)} Euro';
          } else {
            _textResult =
                'Cannot convert USD to Euro\nPlease check the Amount!';
          }
          break;
        case 1:
          _result = _currencyCalculate(_currencyController.text, POUND_MUL);
          if (_result > -1.0) {
            _textResult =
                '${_currencyController.text} USD = ${_result.toStringAsFixed(3)} Pound';
          } else {
            _textResult =
                'Cannot convert USD to Pound\nPlease check the Amount!';
          }
          break;
        case 2:
          _result = _currencyCalculate(_currencyController.text, YEN_MUL);
          if (_result > -1.0) {
            _textResult =
                '${_currencyController.text} USD = ${_result.toStringAsFixed(3)} Yen';
          } else {
            _textResult = 'Cannot convert USD to Yen\nPlease check the Amount!';
          }
          break;
      }
    });
  }

  Future<Null> _selectdate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(1901),
        lastDate: new DateTime(2090));
    if (picked != null && picked != _date) {
      print('Date Selected : ${_date.toString()}');
      setState(() {
        _date = picked;
        dateSlug =
            "${_date.year.toString()}-${_date.month.toString().padLeft(2,'0')}-${_date.day.toString().padLeft(2,'0')}";
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    controller?.dispose();
    emailController.dispose();
    nameController.dispose();
    mobileController.dispose();
    addressController.dispose();
    bioController.dispose();
    super.dispose();

  }

  @override
  void initState(){
    _goo();
    super.initState();
    state = AppState.free;
    _ee = _ee ?? "";

    // nameController.addListener(_printLatestValue(people));
    // mobileController.addListener(_printLatestValue);
    // addressController.addListener(_printLatestValue);
    // bioController.addListener(_printLatestValue);
  }

_printLatestValue(People people) async{
    var db = new DatabaseHelper();
    Detail detail;
    detail = await db.getDetailOfActiveUser();
    String _abcd = detail.email;
    emailController.text = _abcd;
    nameController.text = people.a;
    mobileController.text = people.b;
    addressController.text = people.c;
    bioController.text = people.d;
  }

_ayush(People people){
  setState(() {
      _ee = people.e;
    });
}

  Future<Null> _pickImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<Null> _pickCamera() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        ratioX: 1.0,
        ratioY: 1.0,
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.blue);
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }

  void _logout() async {
    var db = new DatabaseHelper();
    await db.deleteUser();
    _completeLogin();
  }

  void _goo() async {
    _whale = new HomeScreenPresenter(this);
    var db = new DatabaseHelper();
    Detail detail;
    detail = await db.getDetailOfActiveUser();
    String _isId = detail.id;
    //String _name = "Nishant";
    _whale.doHard(_isId);
    
  }

  void _updateProfile() async {
    final form = fKey.currentState;
    form.save();
      NetworkUtil _networkUtil = new NetworkUtil();
    var db = new DatabaseHelper();
    Detail detail;
    detail = await db.getDetailOfActiveUser();
    String _isId = detail.id;
    bool success = await _networkUtil.upload(imageFile,_name, _mobile, _address, _bio, _isId);
    if(success){
      _telluser();
    }
  }

  @override
  Widget build(BuildContext context) {
    var Logout = new ButtonTheme(
        minWidth: 350.0,
        height: 50.0,
        child: new RaisedButton(
          onPressed: _logout,
          child: new Text("Logout", style: new TextStyle(color: Colors.white)),
          color: Colors.red,
        ));

    var UpdateProfile = new ButtonTheme(
        minWidth: 350.0,
        height: 50.0,
        child: new RaisedButton(
          onPressed: _updateProfile,
          child: new Text("Update Profile",
              style: new TextStyle(color: Colors.white)),
          color: Colors.green,
        ));

        var GetUserDetails = new ButtonTheme(
        minWidth: 350.0,
        height: 50.0,
        child: new RaisedButton(
          onPressed: _goo,
          child: new Text("Make Details Filled",
              style: new TextStyle(color: Colors.white)),
          color: Colors.green,
        ));

    return Scaffold(
      resizeToAvoidBottomPadding: false,
        body: new ListView(
      children: <Widget>[
        new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 30.0),
            ),
            new PhysicalModel(
              color: Colors.deepOrange,
              borderRadius: new BorderRadius.circular(100.0),
              child: Container(
                child: imageFile != null ? Image.file(imageFile) : Container(child: new Image(
                   image: new CachedNetworkImageProvider("http://172.16.1.35:6700/uploads/"+"$_ee")
                ),),
                width: 200.0,
                height: 200.0,
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: 30.0),
            // ),
            // new PhysicalModel(
            //   color: Colors.deepOrange,
            //   borderRadius: new BorderRadius.circular(100.0),
            //   child: Container(
            //     //child: imageFile != null ? Image.file(imageFile) : Container(),
            //     child: new Image(
            //        image: new CachedNetworkImageProvider("http://172.16.1.35:6700/uploads/"+"$_ee")
            //     ),
            //     width: 200.0,
            //     height: 200.0,
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: FloatingActionButton(
                    onPressed: () {
                      if (state == AppState.picked) _cropImage();
                    },
                    heroTag: 'image0',
                    tooltip: 'Pick Image from gallery',
                    child: const Icon(Icons.crop_square),
                  ),
                ),
                new Expanded(
                  child: FloatingActionButton(
                    onPressed: () {
                      if (state == AppState.free) _pickImage();
                      if (state == AppState.cropped) _pickImage();
                      if (state == AppState.picked) _pickImage();
                    },
                    heroTag: 'image1',
                    tooltip: 'Take a Photo',
                    child: const Icon(Icons.photo),
                  ),
                ),
                new Expanded(
                  child: FloatingActionButton(
                    onPressed: () {
                      if (state == AppState.picked) _pickCamera();
                      if (state == AppState.free) _pickCamera();
                      if (state == AppState.cropped) _pickCamera();
                    },
                    heroTag: 'image1',
                    tooltip: 'Take a Photo',
                    child: const Icon(Icons.camera),
                  ),
                ),
              ],
            ),
            new Form(
              key: fKey,
              child: new Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 50.0),
                  ),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Text('Name',
                            textAlign: TextAlign.center,
                            style: new TextStyle(fontSize: 18.0)),
                      ),
                      new Expanded(
                        flex: 2,
                        child: new Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: new EnsureVisibleWhenFocused(
                            focusNode: _focusNodeName,
                            child: new TextFormField(
                              controller: nameController,
                              onSaved: (val) => _name = val,
                              focusNode: _focusNodeName,
                              decoration: InputDecoration(
                                hintText: 'Enter Name Here',
                                border: OutlineInputBorder(),
                              ),
                              maxLength: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Text('Email',
                            textAlign: TextAlign.center,
                            style: new TextStyle(fontSize: 18.0)),
                      ),
                      new Expanded(
                        flex: 2,
                        child: new Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: new EnsureVisibleWhenFocused(
                            focusNode: _focusNodeEmail,
                            child: new TextFormField(
                              enabled: false,
                              controller: emailController,
                                focusNode: _focusNodeEmail,
                                decoration: InputDecoration(
                                  hintText: 'Enter Email Here',
                                  border: OutlineInputBorder(),
                                ),
                                maxLength: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  // new Row(
                  //   children: <Widget>[
                  //     new Expanded(
                  //       child: new Text('DOB',
                  //           textAlign: TextAlign.center,
                  //           style: new TextStyle(fontSize: 18.0)),
                  //     ),
                  //     new Expanded(
                  //       flex: 1,
                  //       child: new Padding(
                  //         padding: const EdgeInsets.only(right: 30.0),
                  //         child: new Text(
                  //           '${dateSlug.toString()}',
                  //           style: new TextStyle(fontSize: 18.0),
                  //         ),
                  //       ),
                  //     ),
                  //     new Expanded(
                  //       flex: 0,
                  //       child: new ButtonTheme(
                  //           height: 50.0,
                  //           child: new RaisedButton(
                  //             onPressed: () {
                  //               _selectdate(context);
                  //             },
                  //             child: const Icon(Icons.cake),
                  //             color: Colors.green,
                  //           )),
                  //     ),
                  //     Padding(
                  //       padding: EdgeInsets.only(right: 30.0),
                  //     ),
                  //   ],
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 30.0),
                  // ),
                  // new Row(
                  //   children: <Widget>[
                  //     new Expanded(
                  //       child: new Text('Gender',
                  //           textAlign: TextAlign.center,
                  //           style: new TextStyle(fontSize: 18.0)),
                  //     ),
                  //     new Expanded(
                  //       flex: 2,
                  //       child: new Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: <Widget>[
                  //           new Radio(
                  //             value: 0,
                  //             groupValue: _radioValue,
                  //             onChanged: _handleRadioValueChange,
                  //           ),
                  //           new Text('Male', textAlign: TextAlign.left),
                  //           new Radio(
                  //             value: 1,
                  //             groupValue: _radioValue,
                  //             onChanged: _handleRadioValueChange,
                  //           ),
                  //           new Text('Female', textAlign: TextAlign.left),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 30.0),
                  // ),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        flex: 2,
                        child: new Text('Mobile',
                            textAlign: TextAlign.center,
                            style: new TextStyle(fontSize: 18.0)),
                      ),
                      new Expanded(
                        flex: 0,
                        child: new Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: new Text('+91', textAlign: TextAlign.right),
                        ),
                      ),
                      new Expanded(
                        flex: 3,
                        child: new Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: new EnsureVisibleWhenFocused(
                            focusNode: _focusNodeMobile,
                            child: new TextFormField(
                              controller: mobileController,
                              onSaved: (val) => _mobile = val,
                              focusNode: _focusNodeMobile,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Enter Phone Here',
                                border: OutlineInputBorder(),
                              ),
                              maxLength: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Text('Address',
                            textAlign: TextAlign.center,
                            style: new TextStyle(fontSize: 18.0)),
                      ),
                      new Expanded(
                        flex: 2,
                        child: new Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: new EnsureVisibleWhenFocused(
                            focusNode: _focusNodeAddress,
                            child: new TextFormField(
                              controller: addressController,
                              onSaved: (val) => _address = val,
                              focusNode: _focusNodeAddress,
                              decoration: InputDecoration(
                                hintText: 'Enter Address Here',
                                border: OutlineInputBorder(),
                              ),
                              maxLength: 100,
                              maxLines: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Text('Bio',
                            textAlign: TextAlign.center,
                            style: new TextStyle(fontSize: 18.0)),
                      ),
                      new Expanded(
                        flex: 2,
                        child: new Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: new EnsureVisibleWhenFocused(
                            focusNode: _focusNodeBio,
                            child: new TextFormField(
                              controller: bioController,
                              onSaved: (val) => _bio = val,
                              focusNode: _focusNodeBio,
                              decoration: InputDecoration(
                                  hintText: 'Enter Bio Here',
                                  border: OutlineInputBorder()),
                              maxLength: 1000,
                              maxLines: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
                  ),
                  UpdateProfile,
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  Logout,
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  // GetUserDetails,
                  // Padding(
                  //   padding: EdgeInsets.only(top: 30.0),
                  // ),
                ],
              ),
            ),
          ],
        )
      ],
    ));
  }

  void _completeLogin() {
    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new LoginScreen()));
  }

  double _currencyCalculate(String amount, double multiplier) {
    double _amount = amount.isNotEmpty ? double.parse(amount) : 0.0;

    if (_amount.toString().isNotEmpty && _amount > 0) {
      return _amount * multiplier;
    } else {
      return -1.0;
    }
  }

  Future<Null> _telluser() async {
    switch (await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text("User Has Been Updated Successfully"),
          children: <Widget>[
            new SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Answer.YES);
              },
              child: const Text("Chalo Jaldi Dabao"),
            )
          ],
        ))) {
      case Answer.YES:
        break;
    }
  }

  @override
  void onGetError(String errorTxt) {
    // TODO: implement onGetError
  }

  @override
  void onGetSuccess(People people) {
  
    _printLatestValue(people);
    _ayush(people);
  }


}

class SemiRoundedBorderClipper extends CustomClipper<Rect> {
  final double borderStrokeWidth;

  const SemiRoundedBorderClipper(this.borderStrokeWidth);

  @override
  Rect getClip(Size size) {
    return new Rect.fromLTRB(
        0.0, 0.0, size.width, size.height - borderStrokeWidth);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    if (oldClipper.runtimeType != SemiRoundedBorderClipper) return true;
    return (oldClipper as SemiRoundedBorderClipper).borderStrokeWidth !=
        borderStrokeWidth;
  }
}
