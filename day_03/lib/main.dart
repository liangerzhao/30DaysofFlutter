import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(new Day03());

class Day03 extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('第三天，基本API请求'),
          ),
          body: new Center(
            child: new Container(
              padding: new EdgeInsets.all(10.0),
              child: new FutureBuilder<NovelType>(
                future: fetchNovelType('http://api.zhuishushenqi.com/cats/lv2/statistics'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return new Column(
                      children: <Widget>[
                        new Text('类型名称：${snapshot.data.name}'),
                        new Text('小说总数：${snapshot.data.bookCount}'),
                        new Text('monthlyCount：${snapshot.data.monthlyCount}'),
                        new Text('图标：${snapshot.data.icon}'),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return new Text('请求失败');
                  }

                  return new CircularProgressIndicator();
                },
              )
            )
          ),
        ),
      );
    }
}

class NovelType {
  String name;
  int bookCount;
  int monthlyCount;
  String icon;

  NovelType(this.name, this.bookCount, this.monthlyCount, this.icon);

  factory NovelType.fromJSON(Map<String, dynamic> json) {
    return new NovelType(
      json['name'],
      json['bookCount'],
      json['monthlyCount'],
      json['icon']
    );
  }
}

Future<NovelType> fetchNovelType(String url) async {
  final response = await http.get(url);
  final resJSON = json.decode(response.body);
  
  return new NovelType.fromJSON(resJSON['male'][0]);
}

