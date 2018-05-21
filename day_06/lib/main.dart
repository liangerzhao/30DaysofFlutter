import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(new Day06());

class Day06 extends StatelessWidget {
  bool _isFull = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('第六天-全屏显示'),
        ),
        body: new Center(
          child: new RaisedButton(
            onPressed: () {
              if (this._isFull) {
                SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
              } else {
                SystemChrome.setEnabledSystemUIOverlays([]);
              }

              this._isFull = !this._isFull;
            },
            child: new Text('切换显示'),
          ),
        ),
      ),
    );
  }
}

