import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:allinone/data/database_helper.dart';
import 'package:allinone/screens/login/login_screen_presenter.dart';
import 'package:allinone/screens/home/home_screen.dart';
import 'package:allinone/utils/my_navigator.dart';
import 'package:allinone/models/user.dart';
import 'package:allinone/models/final.dart';
import 'package:allinone/screens/main/main_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginScreenState();
  }
}

enum Answer { YES, NO }

class LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract {
  String _message = '';
  String _answer = '';

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _email, _password;

  LoginScreenPresenter _presenter;

  LoginScreenState() {
    _presenter = new LoginScreenPresenter(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.doLogin(_email, _password);
    }
  }

  void setAnswer(String value) {
    setState(() {
      _answer = value;
    });
  }

  Future<Null> _askuser() async {
    switch (await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text("Please Do Not Waste Your Time"),
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
        setAnswer('Ab Yeh Galti Wapas Mat Karna');
        break;
    }
  }

  void _onPoo() async {
    var db = new DatabaseHelper();
    bool isLoggedIn = await db.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => new MainScreen()));
    } else {
      _askuser();
    }
  }

  void _signUpPressed() {
    MyNavigator.goToSignup(context);
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("LOGIN", style: new TextStyle(color: Colors.white)),
      color: Colors.red,
    );
    var signUpBtn = new RaisedButton(
      onPressed: _signUpPressed,
      child: new Text("SIGNUP", style: new TextStyle(color: Colors.white)),
      color: Colors.red,
    );
    var alreadyLoggedIn = new RaisedButton(
      onPressed: _onPoo,
      child: new Text("IF WERE ALREADY LOGGED IN PLEASE CLICK HERE",
          style: new TextStyle(color: Colors.white)),
      color: Colors.red,
    );
    var loginForm = new Column(
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
                padding:
                    const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                child: new TextFormField(
                  obscureText: true,
                  onSaved: (val) => _password = val,
                  decoration: new InputDecoration(labelText: "Password"),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30.0),
        ),
        _isLoading ? new CircularProgressIndicator() : loginBtn,
        Padding(
          padding: EdgeInsets.only(top: 30.0),
        ),
        signUpBtn,
        Padding(
          padding: EdgeInsets.only(top: 30.0),
        ),
        alreadyLoggedIn,
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: null,
      key: scaffoldKey,
      body: new Container(
        child: new Center(
          child: new ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
              child: new Container(
                child: loginForm,
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
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) async {
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
