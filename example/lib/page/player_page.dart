import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aliplayer/flutter_aliplayer.dart';
import 'package:flutter_aliplayer_example/config.dart';
import 'package:flutter_aliplayer_example/page/player_fragment/cache_config_fragment.dart';
import 'package:flutter_aliplayer_example/page/player_fragment/options_fragment.dart';
import 'package:flutter_aliplayer_example/page/player_fragment/play_config_fragment.dart';
import 'package:flutter_aliplayer_example/page/player_fragment/track_fragment.dart';
import 'package:flutter_aliplayer_example/util/formatter_utils.dart';

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
  //是否允许后台播放
  bool _mEnablePlayBack = false;
  //当前播放进度
  int _currentPosition = 0;
  //当前buffer进度
  int _buffering;
  //是否展示loading
  bool _showLoading = false;
  //loading进度
  int _loadingPercent;

  ///seek中
  bool _inSeek = false;

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

    _initListener();
  }

  _initListener() {
    fAliplayer.setOnPrepard(() {
      print("abc : onPrepared");
    });
    fAliplayer.setOnRenderingStart(() {
      print("abc : onRenderingStart");
    });
    fAliplayer.setOnVideoSizeChanged((width, height) {
      print("abc : onVideoSizeChanged $width    $height");
    });
    fAliplayer.setOnStateChanged((newState) {
      print("abc : onStateChanged $newState");
    });
    fAliplayer.setOnLoadingStatusListener(loadingBegin: () {
      _showLoading = true;
    }, loadingProgress: (percent, netSpeed) {
      _loadingPercent = percent;
      setState(() {});
      print("abc : onLoadingProgress $percent");
    }, loadingEnd: () {
      _showLoading = false;
    });
    fAliplayer.setOnSeekComplete(() {
      print("abc : onSeekComplete");
    });
    fAliplayer.setOnInfo((infoCode, extraValue, extraMsg) {
      if (infoCode == FlutterAvpdef.CURRENTPOSITION) {
        _currentPosition = extraValue;
        setState(() {});
      } else if (infoCode == FlutterAvpdef.BUFFEREDPOSITION) {
        _buffering = extraValue;
        setState(() {});
      }
    });
    fAliplayer.setOnCompletion(() {
      print("abc : setOnCompletion");
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
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
    fAliplayer.stop();
    fAliplayer.destroy();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    var x = 0.0;
    var y = 0.0;
    Orientation orientation = MediaQuery.of(context).orientation;
    var width = MediaQuery.of(context).size.width;

    var height;
    if (orientation == Orientation.portrait) {
      height = width * 9.0 / 16.0;
    } else {
      height = MediaQuery.of(context).size.height;
    }
    AliPlayerView aliPlayerView = new AliPlayerView(
        onCreated: onViewPlayerCreated,
        x: x,
        y: y,
        width: width,
        height: height);
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Scaffold(
          appBar: _buildAppBar(orientation),
          body: Column(
            children: [
              Stack(
                children: [
                  Container(child: aliPlayerView, width: width, height: height),
                  Align(
                      child: _buildContentWidget(orientation),
                      alignment: FractionalOffset.bottomCenter,
                      heightFactor: 3.3),
                  Align(
                      child: _buildProgressBar(),
                      heightFactor: 2.0,
                      alignment: FractionalOffset.bottomCenter),
                ],
              ),
              _buildControlBtns(orientation),
              _buildFragmentPage(orientation),
            ],
          ),
          // _buildBottomNavigationBar(orientation),
          bottomNavigationBar: _buildBottomNavigationBar(orientation),
        );
      },
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

  _buildAppBar(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return AppBar(
        title: const Text('Plugin for aliplayer'),
      );
    }
  }

  /// MARK: 私有方法
  _buildControlBtns(Orientation orientation) {
    if (orientation == Orientation.portrait) {
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
                  fAliplayer.snapshot();
                }),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  _buildFragmentPage(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return mFramePage[bottomIndex];
    } else {
      return Container();
    }
  }

  _buildProgressBar() {
    if (_showLoading) {
      return Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 3.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "$_loadingPercent%",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  ///播放进度和buffer
  _buildContentWidget(Orientation orientation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            "buffer : ${FormatterUtils.getTimeformatByMs(_buffering)}",
            style: TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 10.0,
            ),
            Text(
              "${FormatterUtils.getTimeformatByMs(_currentPosition)}/123",
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  inactiveTickMarkColor: Colors.red,
                  activeTickMarkColor: Colors.blue,
                  inactiveTrackColor: Colors.white,
                ),
                child: CupertinoSlider(
                  max: 114180,
                  value: double.parse(_currentPosition.toString()),
                  onChangeStart: (value) {
                    _inSeek = true;
                    print("abc : onnChangeStart   ");
                  },
                  onChangeEnd: (value) {
                    _inSeek = false;
                    //TODO  123123123   seekTo
                    print("abc : onChangeEnd");
                  },
                  onChanged: (value) {
                    setState(() {
                      _currentPosition = value.ceil();
                    });
                  },
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                orientation == Orientation.portrait
                    ? Icons.fullscreen
                    : Icons.fullscreen_exit,
                color: Colors.white,
              ),
              onPressed: () {
                if (orientation == Orientation.portrait) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight
                  ]);
                } else {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown
                  ]);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  //底部tab
  _buildBottomNavigationBar(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return BottomNavigationBar(
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
      );
    }
  }
}
