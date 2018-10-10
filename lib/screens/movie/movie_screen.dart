import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:chewie/chewie.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

String selectedUrl = 'https://flutter.io';

class MovieScreen extends StatefulWidget {
  final Color color;
  final double size;

  const MovieScreen({
    Key key,
    @required this.color,
    this.size = 50.0,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new MovieScreenState();
  }
}

class MovieScreenState extends State<MovieScreen>
    with SingleTickerProviderStateMixin {
  TargetPlatform _platform;
  VideoPlayerController _controllers;
  AnimationController _controller;
  Animation<double> _animation;

  // Instance of WebView plugin
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

  StreamSubscription<double> _onScrollYChanged;

  StreamSubscription<double> _onScrollXChanged;

  final _urlCtrl = new TextEditingController(text: selectedUrl);

  final _codeCtrl =
      new TextEditingController(text: 'window.navigator.userAgent');

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _history = [];

  @override
  void initState() {
    super.initState();
    _controllers = new VideoPlayerController.network(
      'https://github.com/flutter/assets-for-api-docs/blob/master/assets/videos/butterfly.mp4?raw=true',
    );
    _controller =
        new AnimationController(vsync: this, duration: Duration(seconds: 4));
    _animation = CurveTween(curve: Curves.easeIn).animate(_controller)
      ..addListener(
        () => setState(() => <String, void>{}),
      );

    _controller.repeat();
    flutterWebviewPlugin.close();

    _urlCtrl.addListener(() {
      selectedUrl = _urlCtrl.text;
    });

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        _scaffoldKey.currentState.showSnackBar(
            const SnackBar(content: const Text('Webview Destroyed')));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add('onUrlChanged: $url');
        });
      }
    });

    _onScrollYChanged =
        flutterWebviewPlugin.onScrollYChanged.listen((double y) {
      if (mounted) {
        setState(() {
          _history.add("Scroll in  Y Direction: $y");
        });
      }
    });

    _onScrollXChanged =
        flutterWebviewPlugin.onScrollXChanged.listen((double x) {
      if (mounted) {
        setState(() {
          _history.add("Scroll in  X Direction: $x");
        });
      }
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        setState(() {
          _history.add('onStateChanged: ${state.type} ${state.url}');
        });
      }
    });

    _onHttpError =
        flutterWebviewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        setState(() {
          _history.add('onHttpError: ${error.code} ${error.url}');
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();

    flutterWebviewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: new ListView(
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              new Center(
                child: new Chewie(
                  _controllers,
                  aspectRatio: 3 / 2,
                  autoPlay: false,
                  looping: false,

                  // Try playing around with some of these other options:

                  showControls: true,
                  materialProgressColors: new ChewieProgressColors(
                    playedColor: Colors.red,
                    handleColor: Colors.blue,
                    backgroundColor: Colors.grey,
                    bufferedColor: Colors.lightGreen,
                  ),
                  placeholder: new Container(
                    color: Colors.grey,
                  ),
                  autoInitialize: true,
                ),
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new FlatButton(
                      onPressed: () {
                        setState(() {
                          _controllers = new VideoPlayerController.network(
                            'https://flutter.github.io/assets-for-api-docs/videos/butterfly.mp4',
                          );
                        });
                      },
                      child: new Padding(
                        child: new Text("Video 1"),
                        padding: new EdgeInsets.symmetric(vertical: 16.0),
                      ),
                    ),
                  ),
                  new Expanded(
                    child: new FlatButton(
                      onPressed: () {
                        setState(() {
                          _controllers = new VideoPlayerController.network(
                            'http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_20mb.mp4',
                          );
                        });
                      },
                      child: new Padding(
                        padding: new EdgeInsets.symmetric(vertical: 16.0),
                        child: new Text("Video 2"),
                      ),
                    ),
                  )
                ],
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new FlatButton(
                      onPressed: () {
                        setState(() {
                          _platform = TargetPlatform.android;
                        });
                      },
                      child: new Padding(
                        child: new Text("Android controls"),
                        padding: new EdgeInsets.symmetric(vertical: 16.0),
                      ),
                    ),
                  ),
                  new Expanded(
                    child: new FlatButton(
                      onPressed: () {
                        setState(() {
                          _platform = TargetPlatform.iOS;
                        });
                      },
                      child: new Padding(
                        padding: new EdgeInsets.symmetric(vertical: 16.0),
                        child: new Text("iOS controls"),
                      ),
                    ),
                  )
                ],
              ),
              new ButtonTheme(
                minWidth: 350.0,
                height: 50.0,
                child: new RaisedButton(
                  color: Colors.green,
                  onPressed: () {
                    flutterWebviewPlugin.launch(selectedUrl,
                        rect: new Rect.fromLTWH(0.0, 150.0,
                            MediaQuery.of(context).size.width, 300.0),
                        userAgent: kAndroidUserAgent);
                  },
                  child: new Text('Open Webview (rect)',
                      style: new TextStyle(color: Colors.white)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0),
              ),
              new ButtonTheme(
                minWidth: 350.0,
                height: 50.0,
                child: new RaisedButton(
                  color: Colors.green,
                  onPressed: () {
                    flutterWebviewPlugin.launch(selectedUrl);
                  },
                  child: new Text('Open Fullscreen Webview',
                      style: new TextStyle(color: Colors.white)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0),
              ),
              new ButtonTheme(
                minWidth: 350.0,
                height: 50.0,
                child: new RaisedButton(
                  color: Colors.green,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/widget');
                  },
                  child: new Text('Open widget webview',
                      style: new TextStyle(color: Colors.white)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0),
              ),
              new Container(
                child: Opacity(
                  opacity: 1.0 - _animation.value,
                  child: new Transform.scale(
                    scale: _animation.value,
                    child: new ButtonTheme(
                      minWidth: 350.0,
                      height: 50.0,
                      child: new RaisedButton(
                        color: Colors.red,
                        onPressed: () {
                          setState(() {
                            _history.clear();
                          });
                          flutterWebviewPlugin.close();
                        },
                        child: new Text('Close',
                            style: new TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0),
              ),
              new Container(
                child: Opacity(
                  opacity: 1.0 - _animation.value,
                  child: new Transform.scale(
                    scale: _animation.value,
                    child: new Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
