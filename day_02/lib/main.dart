import 'package:flutter/material.dart';

void main() => runApp(new Day02());

class Day02 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: new HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('主页'),
      ),
      body: new Center(
        child: new RaisedButton(
            child: new Text('下一页'),
            onPressed: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (BuildContext build) {
                return new SecondPage('这段文字来自上一页');
              }));
            }),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final String content;

  SecondPage(this.content);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('第二页'),
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.all(10.0),
              child: new Text(this.content),
            ),
            new RaisedButton(
              child: new Text('上一页'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        )
      ),
    );
  }
}
