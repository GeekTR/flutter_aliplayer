import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aliplayer/flutter_aliplayer.dart';
import 'package:flutter_aliplayer_example/framepage/cache_cfg_frame_page.dart';
import 'package:flutter_aliplayer_example/framepage/options_frame_page.dart';
import 'package:flutter_aliplayer_example/framepage/play_cfg_frame_page.dart';
import 'package:flutter_aliplayer_example/framepage/track_frame_page.dart';

class PlayPage extends StatefulWidget {
  String urlPath;

  PlayPage([
    this.urlPath,
  ]) : assert(urlPath != null);

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  var viewPlayerController;
  int bottom_currentIndex;
  List<Widget> mFramePage;
  String urlPath;

  @override
  void initState() {
    super.initState();
    bottom_currentIndex = 0;
    urlPath = widget.urlPath;

    mFramePage = [
      OptionsFramePage(),
      PlayConfigFramePage(),
      CacheConfigFramePage(),
      TrackFramePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var x = 0.0;
    var y = 0.0;
    var width = 400.0;
    var height = width * 9.0 / 16.0;
    AliVideoPlayer videoPlayer = new AliVideoPlayer(
        onCreated: onViewPlayerCreated,
        x: x,
        y: y,
        width: width,
        height: height);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin for aliplayer'),
        ),
        body: Column(
          children: [
            Container(child: videoPlayer, width: width, height: height),
            _buildControlBtns(),
            mFramePage[bottom_currentIndex],
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                title: Text('options'), icon: Icon(Icons.control_point)),
            BottomNavigationBarItem(
                title: Text('play_cfg'), icon: Icon(Icons.control_point)),
            BottomNavigationBarItem(
                title: Text('cache_cfg'), icon: Icon(Icons.control_point)),
            BottomNavigationBarItem(
                title: Text('track'), icon: Icon(Icons.control_point)),
          ],
          currentIndex: bottom_currentIndex,
          onTap: (index) {
            if (index != bottom_currentIndex) {
              setState(() {
                bottom_currentIndex = index;
              });
            }
          },
        ),
      ),
    );
  }

  void onViewPlayerCreated(viewPlayerController) async {
    this.viewPlayerController = viewPlayerController;
    // this.viewPlayerController.setUrl(
    //     "https://alivc-demo-vod.aliyuncs.com/6b357371ef3c45f4a06e2536fd534380/eb3f139a4b437d1e9b623ee1b671115b-ld.mp4");
    this.viewPlayerController.setUrl(urlPath);
  }

  /// MARK: 私有方法
  _buildControlBtns() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
              child: Text('准备'),
              onTap: () {
                viewPlayerController.prepare();
              }),
          InkWell(
              child: Text('播放'),
              onTap: () {
                viewPlayerController.play();
              }),
          InkWell(
            child: Text('停止'),
            onTap: () {
              viewPlayerController.stop();
            },
          ),
          InkWell(
              child: Text('暂停'),
              onTap: () {
                viewPlayerController.pause();
              }),
          InkWell(
              child: Text('截图'),
              onTap: () {
                //TODO
              }),
        ],
      ),
    );
  }
}
