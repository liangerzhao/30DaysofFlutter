import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(new Day01());

class Day01 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: new TimerBox(),
    );
  }
}

class TimerBox extends StatefulWidget {
  _TimerBoxState createState() => new _TimerBoxState();
}

class _TimerBoxState extends State<TimerBox> {
  int _num = 0;
  bool _isStart = false;
  Timer _t;

  void timerHandle(Timer t) {
    setState(() {
      this._num += 1;
    });
  }

  void handleClick() {
    setState(() {
      if (this._isStart) {
        this._t.cancel();
      } else {
        this._t =
            new Timer.periodic(const Duration(seconds: 1), this.timerHandle);
      }

      this._isStart = !this._isStart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Day01'),
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.all(10.0),
              child: new Text(
                this._num.toString(),
                style: new TextStyle(fontSize: 28.0),
              ),
            ),
            new Container(
              padding: new EdgeInsets.all(10.0),
              child: new RaisedButton(
                child: new Text(this._isStart ? '暂停计时' : '开始计时'),
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: this.handleClick,
              ),
            )
          ],
        ),
      ),
    );
  }
}
