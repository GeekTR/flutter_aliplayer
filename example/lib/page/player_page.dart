import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aliplayer/flutter_aliplayer.dart';
import 'package:flutter_aliplayer_example/config.dart';
import 'package:flutter_aliplayer_example/page/player_fragment/cache_config_fragment.dart';
import 'package:flutter_aliplayer_example/page/player_fragment/options_fragment.dart';
import 'package:flutter_aliplayer_example/page/player_fragment/play_config_fragment.dart';
import 'package:flutter_aliplayer_example/page/player_fragment/track_fragment.dart';

class PlayerPage extends StatefulWidget {
  final ModeType playMode;
  final Map<String, dynamic> dataSourceMap;

  PlayerPage({Key key, this.playMode, this.dataSourceMap})
      : assert(playMode != null),
        super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with WidgetsBindingObserver {
  FlutterAliplayer fAliplayer;
  int bottomIndex;
  List<Widget> mFramePage;
  ModeType _playMode;
  Map<String, dynamic> _dataSourceMap;
  bool _mEnablePlayBack = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    bottomIndex = 0;
    _playMode = widget.playMode;
    _dataSourceMap = widget.dataSourceMap;

    fAliplayer = FlutterAliplayer.init(0);
    OptionsFragment mOptionsFragment = OptionsFragment(fAliplayer);
    mFramePage = [
      mOptionsFragment,
      PlayConfigFragment(fAliplayer),
      CacheConfigFragment(fAliplayer),
      TrackFragment(),
    ];

    mOptionsFragment.setOnEnablePlayBackChanged((mEnablePlayBack) {
      this._mEnablePlayBack = mEnablePlayBack;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        fAliplayer.play();
        break;
      case AppLifecycleState.paused:
        if (!_mEnablePlayBack) {
          fAliplayer.pause();
        }
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    fAliplayer.stop();
    fAliplayer.destroy();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    var x = 0.0;
    var y = 0.0;
    var width = 400.0;
    var height = width * 9.0 / 16.0;
    AliPlayerView aliPlayerView = new AliPlayerView(
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
          Container(child: aliPlayerView, width: width, height: height),
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

  void onViewPlayerCreated() async {
    switch (_playMode) {
      case ModeType.URL:
        this.fAliplayer.setUrl(_dataSourceMap[DataSourceRelated.URL_KEY]);
        break;
      case ModeType.STS:
        this.fAliplayer.setVidSts(_dataSourceMap);
        break;
      case ModeType.AUTH:
        this.fAliplayer.setVidAuth(_dataSourceMap);
        break;
      case ModeType.MPS:
        this.fAliplayer.setVidMps(_dataSourceMap);
        break;
      default:
    }
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
                fAliplayer.prepare();
              }),
          InkWell(
              child: Text('播放'),
              onTap: () {
                fAliplayer.play();
              }),
          InkWell(
            child: Text('停止'),
            onTap: () {
              fAliplayer.stop();
            },
          ),
          InkWell(
              child: Text('暂停'),
              onTap: () {
                fAliplayer.pause();
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
