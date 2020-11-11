import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aliplayer/flutter_aliplayer.dart';
import 'package:flutter_aliplayer_example/page/player_fragment/cache_config_fragment.dart';
import 'package:flutter_aliplayer_example/page/player_fragment/options_fragment.dart';
import 'package:flutter_aliplayer_example/page/player_fragment/play_config_fragment.dart';
import 'package:flutter_aliplayer_example/page/player_fragment/track_fragment.dart';

class PlayerPage extends StatefulWidget {
  final String urlPath;

  PlayerPage([
    this.urlPath,
  ]) : assert(urlPath != null);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  var viewPlayerController;
  int bottomIndex;
  List<Widget> mFramePage;
  String urlPath;

  @override
  void initState() {
    super.initState();
    bottomIndex = 0;
    urlPath = widget.urlPath;

    mFramePage = [
      OptionsFragment(),
      PlayConfigFragment(),
      CacheConfigFragment(),
      TrackFragment(),
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin for aliplayer'),
        ),
        body: Column(
          children: [
            Container(child: videoPlayer, width: width, height: height),
            _buildControlBtns(),
            mFramePage[bottomIndex],
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
          currentIndex: bottomIndex,
          onTap: (index) {
            if (index != bottomIndex) {
              setState(() {
                bottomIndex = index;
              });
            }
          },
        ),
    );
  }

  void onViewPlayerCreated(viewPlayerController) async {
    this.viewPlayerController = viewPlayerController;
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
                // TODO
              }),
        ],
      ),
    );
  }
}
