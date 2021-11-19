import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List? songs = [];

  getData() async {
    Directory dir = Directory('/storage/emulated/0/');
    String mp3Path = dir.toString();
    print(mp3Path);
    List<FileSystemEntity> _files;
    List<FileSystemEntity> _songs = [];
    _files = dir.listSync(recursive: true, followLinks: false);
    for (FileSystemEntity entity in _files) {
      String path = entity.path;
      if (path.endsWith('.mp3')) _songs.add(entity);
    }
    print(_songs);
    setState(() {
      songs = _songs;
    });
    print(_songs.length);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Rhythmbox",
      home: Scaffold(
        backgroundColor: Colors.white,
        body: (songs != null)
            ? ListView.builder(
                itemCount: songs!.length,
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(Icons.music_note),
                      trailing: IconButton(
                          onPressed: () async {
                            final player = AudioPlayer();
                            await player
                                .setFilePath(songs![index].path.toString());
                            player.play();
                          },
                          icon: Icon(Icons.play_arrow)),
                      tileColor: Colors.grey[200],
                      title: Text(songs![index]
                          .toString()
                          .split('/')
                          .last
                          .replaceAll('\'', ' ')),
                    ),
                  );
                },
              )
            : Center(
                child: CupertinoActivityIndicator(
                  radius: 30,
                ),
              ),
        appBar: AppBar(
          title: Text("Rhythm Box"),
        ),
      ),
    );
  }
}
