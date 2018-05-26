import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:file/local.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:path/path.dart';
import 'package:audioplayer/audioplayer.dart';

void main() => runApp(new MaterialApp(
  home: new Day08(),
));

class Day08 extends StatefulWidget {
  State<Day08> createState() => new Day08State();
}

class Day08State extends State<Day08> {

  final AudioPlayer audioPlayer = new AudioPlayer();
  
  // 是否显示Loading
  bool isShowLoading = false;

  List<File> fileList = [];
  // 当前是否处于播放中
  bool isPlaying = false;

  // 当前播放文件路径
  String currentFile;

  Day08State() {
    // 监听播放完成事件，当音乐播放完毕，将播放中状态改为false
    this.audioPlayer.setCompletionHandler(() {
      setState(() {
        this.isPlaying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('第八天-播放本地音乐'),
        actions: <Widget>[
          // 当处于播放中，则暂停播放。当处于暂停中，则继续播放。
          new IconButton(
            onPressed: () {
              if (this.isPlaying) {
                this.audioPlayer.pause();

                setState(() {
                  this.isPlaying = false;                 
                });
              } else {
                if (this.currentFile != null) {
                  // 继续播放依旧需要传之前播放的音乐文件路径
                  this.audioPlayer.play(this.currentFile);

                  setState(() {
                    this.isPlaying = true;                 
                  });
                }
              }
            },
            icon: this.isPlaying ? new Icon(Icons.pause) : new Icon(Icons.play_arrow),
          ),
          // 全局搜索音乐文件
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: () {
              setState(() {
                this.isShowLoading = true;         
              });

              searchAudioFile()
                  .then((resultList) {
                    setState(() {
                      this.fileList = resultList;
                      this.isShowLoading = false;         
                    });
                  });     
            },
            tooltip: '全局搜索本地音乐',
          )
        ],
      ),
      body: new ListView.builder(
        itemCount: this.fileList.length == 0 ? 1 : this.fileList.length,
        itemBuilder: (BuildContext c, index) {
          if (this.fileList.length == 0) {
            if (this.isShowLoading) {
              return new Center(
                child: new Container(
                  padding: new EdgeInsets.all(20.0),
                  child: new CircularProgressIndicator(),
                )
              );
            }

            return null;
          }

          return new ListTile(
            leading: new Icon(Icons.music_note),
            title: new Text(basename(this.fileList[index].path)),
            trailing: new Text((this.fileList[index].lengthSync() ~/ 1024).toString() + 'kb'),
            // 如果处于播放中，则停止当前播放，然后播放当前选中文件
            onTap: () {
              if (this.isPlaying) {
                this.audioPlayer.stop();
              }

              setState(() {
                this.isPlaying = true;
                this.currentFile = this.fileList[index].path;
              });

              this.audioPlayer.play(this.fileList[index].path);
            },
          );
        },
      )
    );
  }
}

// 搜索本地音乐文件
Future<List<File>> searchAudioFile() async {
  // 判断是否有读写文件权限，如果没则像用户请求
  final bool hasPermission = await SimplePermissions.checkPermission(Permission.WriteExternalStorage);

  if (!hasPermission) {
    final bool isAllow = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);

    if (!isAllow) {
      throw '没有读写文件权限';
    }
  }

  const fs = const LocalFileSystem();
  Directory sdcard = fs.directory('/sdcard');

  return sdcard.list( recursive: true ).toList()
    .then((allFileList) {
      List<File> resultList = [];

      allFileList.forEach((item) {
        // 筛选出文件后缀为mp3和大于512kb的文件
        if (item is File) {
          if (item.path.endsWith('.mp3')) {
            if ((item.lengthSync() ~/ 1024) > 512) {
              resultList.add(item);
            }
          }
        }
      });

      return resultList;
    });
}
