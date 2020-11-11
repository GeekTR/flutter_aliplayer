import 'package:flutter/material.dart';
import 'package:flutter_aliplayer_example/common/common_utils.dart';
import 'package:flutter_aliplayer_example/page/auth_page.dart';
import 'package:flutter_aliplayer_example/page/mps_page.dart';
import 'package:flutter_aliplayer_example/page/sts_page.dart';
import 'package:flutter_aliplayer_example/page/url_page.dart';

class HomePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<HomePage> {
  List titleArr = [
    'URL播放',
    'STS播放',
    'AUTH播放',
    'MPS播放',
    '本地视频播放',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin for aliplayer'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemExtent: 50.0,
        itemCount: titleArr.length,
        itemBuilder: (BuildContext context, int index) {
          return FlatButton(
            child: Text(titleArr[index]),
            onPressed: () {
              switch (index) {
                case 0:
                  CommomUtils.pushPage(context, UrlPage());
                  break;
                case 1:
                  CommomUtils.pushPage(context, StsPage());
                  break;
                case 2:
                  CommomUtils.pushPage(context, AuthPage());
                  break;
                case 3:
                  CommomUtils.pushPage(context, MpsPage());
                  break;
                default:
              }
            },
          );
        },
      ),
    );
  }
}
