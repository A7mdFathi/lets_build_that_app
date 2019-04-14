import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'views/VideoCell.dart';
import 'views/DetailPage.dart';

void main() => runApp(RealWorldApp());

class RealWorldApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RealWorldState();
  }
}

class RealWorldState extends State<RealWorldApp> {
  var __isLoading = true;
  var videos;
  __fetchData() async {
    print('attemping to fetch data');

    final url = "https://api.letsbuildthatapp.com/youtube/home_feed";

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // print(response.body);

      final map = json.decode(response.body);
      final videosJson = map['videos'];

      // videosJson.forEach((video) {});
      setState(() {
        __isLoading = false;
        this.videos = videosJson;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('hello world'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                print('reloading....');
                setState(() {
                  __isLoading = true;
                });
                __fetchData();
              },
            )
          ],
        ),
        body: Center(
          child: __isLoading
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: this.videos != null ? videos.length : 0,
                  itemBuilder: (context, i) {
                    final video = this.videos[i];
                    FlatButton(
                      child: VideoCell(video),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage()));
                      },
                    );
                    return VideoCell(video);
                  },
                ),
        ),
      ),
    );
  }
}
