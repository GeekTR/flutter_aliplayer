import 'package:flutter/material.dart';
import 'package:flutter_aliplayer_example/url_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin for aliplayer'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                child: FlatButton(
                  child: Text("URL播放"),
                  onPressed: () {
                    _navigator_push(context, UrlPage());
                  },
                ),
              ),
              Container(
                width: double.infinity,
                child: FlatButton(
                  child: Text("STS播放"),
                  onPressed: () {},
                ),
              ),
              Container(
                width: double.infinity,
                child: FlatButton(
                  child: Text("AUTH播放"),
                  onPressed: () {},
                ),
              ),
              Container(
                width: double.infinity,
                child: FlatButton(
                  child: Text("MPS播放"),
                  onPressed: () {},
                ),
              ),
              Container(
                width: double.infinity,
                child: FlatButton(
                  child: Text("本地视频播放"),
                  onPressed: () {},
                ),
              ),
            ],
          )),
    );
  }

  _navigator_push(BuildContext context, Widget route) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => route));
  }
}
