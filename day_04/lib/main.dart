import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new Day04());

// 静态资源域名
const STATIC_RESOURCE = 'http://statics.zhuishushenqi.com';

// 分类接口
const NOVEL_TYPE_API = 'http://api.zhuishushenqi.com/cats/lv2/statistics';

class Day04 extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('第四天-小说分类列表'),
          ),
          body: new Center(
            child: new FutureBuilder(
              future: fetchNovelType(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return new ListView.builder(
                    itemCount: snapshot.data['male'].length,
                    itemBuilder: (context, i) {
                      final targetItem = snapshot.data['male'][i];

                      return new ListTile(
                        leading: new Image.network(STATIC_RESOURCE + targetItem['bookCover'][0]),
                        title: new Text(targetItem['name']),
                        onTap: () {},
                        subtitle: new Text(targetItem['bookCount'].toString() + '本'),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return new Text('接口请求出错~');
                }

                return new CircularProgressIndicator();
              },
            ),
          ),
        ),
      );
    }
}

class NovelType {
  String name;
  int bookCount;
  List<String> bookCover;

  NovelType(this.name, this.bookCount, this.bookCover) {
    this.bookCover = this.bookCover.map<String>((String coverLink) {
      return STATIC_RESOURCE + coverLink;
    });
  }

  factory NovelType.fromJSON(Map<String, dynamic> json) {
    return new NovelType(
      json['name'],
      json['bookCount'],
      json['booCover']
    );
  }
}

// class NovelTypeResponse {
//   List<NovelType> male;
//   // List<NovelType> female;
//   // List<NovelType> picture;
//   // List<NovelType> press;

//   NovelTypeResponse(this.male);

//   factory NovelTypeResponse.fromJSON(Map<String, dynamic> json) {
//     final male = (json['male'] as List<dynamic>).map<NovelType>((item) {
//       return new NovelType(item['name'], item['bookCount'], item['bookCover']);
//     });

//     return new NovelTypeResponse(
//       male.toList()
//     );
//   }
// }

Future<Map<String, dynamic>> fetchNovelType() async {
  final response = await http.get(NOVEL_TYPE_API);

  // print(response.body);
  final resJSON = jsonDecode(response.body);

  return resJSON;
}