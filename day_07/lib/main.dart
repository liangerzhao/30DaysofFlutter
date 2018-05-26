import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file/local.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() => runApp(new Day07());

class Day07 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('第七天-文件系统'),
        ),
        body: new FutureBuilder(
          future: getSdcardFileList(),
          builder: (BuildContext c, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
            if (snapshot.hasData) {
              return new ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext subC, int index) {
                  return new ListTile(
                    leading: new Icon(Icons.code),
                    title: new Text(snapshot.data[index].path),
                    onTap: () {},
                  );
                },
              );
            } else if (snapshot.hasError) {
              new Text(snapshot.error.toString());
            }

            return new CircularProgressIndicator();
          },
        )
      ),
    );
  }
}

Future<List<FileSystemEntity>> getSdcardFileList() async {
  final bool hasPermission = await SimplePermissions.checkPermission(Permission.WriteExternalStorage);

  if (!hasPermission) {
    final bool isAllow = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);

    if (!isAllow) {
      throw '没有读写文件权限';
    }
  }

  const fs = const LocalFileSystem();
  Directory sdcard = fs.directory('/sdcard');

  return sdcard.list().toList();
}