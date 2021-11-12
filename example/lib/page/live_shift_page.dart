import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_aliplayer/flutter_aliliveshiftplayer.dart';
import 'package:flutter_aliplayer/flutter_aliplayer.dart';
import 'package:flutter_aliplayer/flutter_aliplayer_factory.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LiveShiftPage extends StatefulWidget {
  const LiveShiftPage({Key key}) : super(key: key);

  @override
  _LiveShiftPageState createState() => _LiveShiftPageState();
}

class _LiveShiftPageState extends State<LiveShiftPage> {
  var _url = "http://qt1.alivecdn.com/align/sla02.m3u8?lhs_start_human_s_8=20211102200011&aliyunols=on";
  var _timeLineUrl = "http://qt1.alivecdn.com/openapi/timeline/query?aliyunols=on&app=align&stream=sla02&format=ts";
  GlobalKey _sliderDividerContainerKey = GlobalKey();
  double _dividerHeight = 0.0;
  double _dividerWidth = 0.0;
  var _sliderDividerLeft = 0.0;
  var _sliderValue = 0.0;
  //是否展示提示内容
  bool _showTipsWidget = false;
  //提示内容
  String _tipsContent;
  FlutterAliLiveShiftPlayer _flutterAliLiveShiftPlayer;
  var _slider_max = 0.0;
  var endTime = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox containerRenderBox =
          _sliderDividerContainerKey.currentContext.findRenderObject();

      setState(() {
        _dividerHeight = containerRenderBox.size.height;
        _dividerWidth = containerRenderBox.size.width;
      });
    });

    _flutterAliLiveShiftPlayer =
        FlutterAliPlayerFactory.createAliLiveShiftPlayer();

    _initListener();
  }

  @override
  void dispose() {
    super.dispose();
    _flutterAliLiveShiftPlayer?.stop();
    _flutterAliLiveShiftPlayer?.destroy();
  }

  void _initListener(){

    _flutterAliLiveShiftPlayer.setOnPrepared((playerId) {
      Fluttertoast.showToast(msg: "OnPrepared");
    });

    //时移时间更新监听事件
    _flutterAliLiveShiftPlayer.setOnTimeShiftUpdater((currentTime, shiftStartTime, shiftEndTime, playerId) {
      int currentLiveTime = _flutterAliLiveShiftPlayer.getCurrentLiveTime() as int;
      int currentTime = _flutterAliLiveShiftPlayer.getCurrentTime() as int;
      var offsetTimeLen = shiftEndTime - shiftStartTime;
      if (endTime - currentLiveTime < offsetTimeLen * 0.05) {
        endTime = (currentLiveTime + offsetTimeLen * 0.1) as int;
      }
      // 123123123
      // if (mControlView != null) {
      //   mControlView.setPlayProgress(mCurrentTime);
      //   mControlView.setLiveTime(mCurrentLiveTime);
      //   mControlView.updateRange(mShiftStartTime, mEndTime);
      // }
      setState(() {
        _updateRange(shiftStartTime,endTime);
      });

    });

    //时移seek完成通知
    _flutterAliLiveShiftPlayer.setOnSeekLiveCompletion((playTime,playerId) {
      Fluttertoast.showToast(msg: "OnSeekLiveCompletion");
    });

    _flutterAliLiveShiftPlayer.setOnLoadingStatusListener(loadingBegin: (playerId){
      _tipsContent = "loadingBegin";
    }, loadingProgress: (percent, netSpeed, playerId){
      _tipsContent = "loading $percent";
    }, loadingEnd: (playerId){
      _tipsContent = "loadingEnd";
    });

    _flutterAliLiveShiftPlayer.setOnError((errorCode, errorExtra, errorMsg, playerId) {
      _tipsContent = "errorCode:$errorCode -- errorMsg:$errorMsg";
    });
  }

  void _updateRange(var startTime,var endTime){
    _slider_max = max(startTime * 1.0, endTime * 1.0);
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
    AliPlayerView aliPlayerView = AliPlayerView(
        onCreated: onViewPlayerCreated,
        x: x,
        y: y,
        width: width,
        height: height);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin for LiveShiftPlayer'),
      ),
      body: Column(children: [
        Container(
          width: width,
          height: height,
          child: aliPlayerView,
        ),
        SizedBox(width: 1, height: 30),
        _buildSlider(),
        SizedBox(width: 1, height: 30),
        _buildPlayerOperator(),
        SizedBox(width: 1, height: 30),
        _buildTipsView()
      ]),
    );
  }

  //进度条
  Widget _buildSlider() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackShape: CustomTrackShape(),
              ),
              child: Slider(
                  key: _sliderDividerContainerKey,
                  min: 0,
                  max: _slider_max as double,
                  value: _sliderValue,
                  onChanged: (value) {
                    _sliderValue = value;
                    setState(() {
                      if (value >= 100) {
                        _sliderDividerLeft = _dividerWidth * value / 100 - 5;
                      } else if (value <= 0) {
                        _sliderDividerLeft = _dividerWidth * value / 100 + 5;
                      } else {
                        _sliderDividerLeft = _dividerWidth * value / 100;
                      }
                    });
                  })),
          Positioned(
            left: _sliderDividerLeft - 5,
            child: SizedBox(
              width: 5,
              height: _dividerHeight / 2,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.blue),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlayerOperator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(child: Text("准备"), onTap: () {
          _flutterAliLiveShiftPlayer.prepare();
        }),
        InkWell(child: Text("播放"), onTap: () {
          _flutterAliLiveShiftPlayer.play();
        }),
        InkWell(child: Text("停止"), onTap: () {
          _flutterAliLiveShiftPlayer.stop();
        })
      ],
    );
  }

  Widget _buildTipsView(){
    if(_showTipsWidget){
      return Text(_tipsContent,style: TextStyle(fontSize: 20,color: Colors.red),);
    }else{
      return Container();
    }
  }

  void onViewPlayerCreated(int viewId) {
    this._flutterAliLiveShiftPlayer.setPlayerView(viewId);
    int time = (new DateTime.now().millisecondsSinceEpoch / 1000).round();
    var timeLineUrl = "$_timeLineUrl&lhs_start_unix_s_0=${time - 5 * 60}&lhs_end_unix_s_0=${time + 5 * 60}";
    _flutterAliLiveShiftPlayer.setDataSource(timeLineUrl, _url);
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx + 10;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - 10;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
