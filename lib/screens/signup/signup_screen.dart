import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:allinone/data/database_helper.dart';
import 'package:allinone/models/user.dart';
import 'package:allinone/models/final.dart';
import 'package:allinone/screens/signup/signup_screen_presenter.dart';
import 'package:allinone/screens/home/home_screen.dart';
import 'package:allinone/screens/main/main_screen.dart';


class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SignupScreenState();
  }
}

class SignupScreenState extends State<SignupScreen>
    implements SignupScreenContract {
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _email, _password;

  SignupScreenPresenter _presenter;

  SignupScreenState() {
    _presenter = new SignupScreenPresenter(this);
  }

  void _submited() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.doSignup(_email, _password);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    var signUpBtn = new RaisedButton(
      onPressed: _submited,
      child: new Text("SIGNUP", style: new TextStyle(color: Colors.white)),
      color: Colors.red,
    );
    var signupForm = new Column(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.red,
          radius: 40.0,
          child: Icon(
            Icons.shopping_cart,
            color: Colors.white,
            size: 40.0,
          ),
        ),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: new TextFormField(
                  onSaved: (val) => _email = val,
                  validator: _validateEmail,
                  decoration: new InputDecoration(labelText: "Email"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: new TextFormField(
                  obscureText: true,
                  onSaved: (val) => _password = val,
                  validator: (val) {
                    return val.length < 6
                        ? "Password must have atleast 6 chars"
                        : null;
                  },
                  decoration: new InputDecoration(labelText: "Password"),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40.0),
        ),
        _isLoading ? new CircularProgressIndicator() : signUpBtn
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: new Container(
        child: new Center(
          child: new ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
              child: new Container(
                child: signupForm,
                height: 500.0,
                width: 500.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onSignupError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onSignupSuccess(User user) async {
    _showSnackBar(user.toString());
    setState(() => _isLoading = false);
    String id, token, email, password;
    int active = 1;
    id = user.data.id;
    token = user.token;
    email = user.data.local.email;
    password = user.data.local.password;
    Final _final = new Final(active, id, token, email, password);
    var db = new DatabaseHelper();
    await db.saveUser(_final);
    _goToMain();
  }

  String _validateEmail(String value) {
    if (value.isEmpty) return 'Email is required.';
    final RegExp emailExp =
        new RegExp(r'(?!.*\.\.)(^[^\.][^@\s]+@[^@\s]+\.[^@\s\.]+$)');
    if (!emailExp.hasMatch(value)) return 'Please enter valid email';
    return null;
  }

  void _goToMain() {
    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new MainScreen()));
  }
}
