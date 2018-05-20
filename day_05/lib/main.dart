import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'dart:async';
import 'dart:convert';

void main() => runApp(new Day05());

class Day05 extends StatelessWidget {

  final NovelList _novelList = new NovelList();
  String _keyword;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '第五天-小说搜索',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Container(
            padding: new EdgeInsets.fromLTRB(NavigationToolbar.kMiddleSpacing, 0.0, 0.0, 0.0),
            child: new TextField(
              decoration: const InputDecoration(
                border: const UnderlineInputBorder(
                  borderRadius: const BorderRadius.all(const Radius.circular(5.0))
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: '书名、作者、分类'
              ),
              onChanged: (content) {
                this._keyword = content;
              },
            ),
          ),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.search),
              onPressed: () {
                this._novelList.searchNovel(this._keyword);
              },
            )
          ],
          titleSpacing: 0.0,
        ),
        body: this._novelList,
      ),
    );
  }
}

class NovelList extends StatefulWidget {
  final NovelListState state = new NovelListState();

  @override
  State<NovelList> createState() => this.state;

  void searchNovel(String keyword) {
    this.state.searchNovel(keyword);
  }
}

class NovelListState extends State<NovelList> {
  List<dynamic> resultList = [];

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: this.resultList.map((item) {
          return new ListTile(
            title: new Text(item['title']),
            leading: new Image.network('http://statics.zhuishushenqi.com${item['cover']}'),
            subtitle: new Text(item['author']),
            onTap: () {},
          );
        })
      ).toList()
    );
  }

  void searchNovel(String keyword) async {
    final response = await http.get('http://api.zhuishushenqi.com/book/fuzzy-search?query=$keyword&start=0&limit=25');
    final resJSON = json.decode(response.body);

    setState(() {
      this.resultList = resJSON['books'];      
    });
  }
}