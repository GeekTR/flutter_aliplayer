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
  FlutterAliLiveShiftPlayer _flutterAliLiveShiftPlayer;

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
    _flutterAliLiveShiftPlayer.setAutoPlay(true);

    _initListener();
  }

  void _initListener(){

    _flutterAliLiveShiftPlayer.setOnPrepared((playerId) {
      Fluttertoast.showToast(msg: "prepare Success");
    });

    //时移时间更新监听事件
    _flutterAliLiveShiftPlayer.setOnTimeShiftUpdater((currentTime, shiftStartTime, shiftEndTime) {

    });

    //时移seek完成通知
    _flutterAliLiveShiftPlayer.setOnSeekLiveCompletion((playTime) {

    });

    _flutterAliLiveShiftPlayer.setOnLoadingStatusListener(loadingBegin: (playerId){

    }, loadingProgress: (percent, netSpeed, playerId){

    }, loadingEnd: (playerId){

    });

    _flutterAliLiveShiftPlayer.setOnError((errorCode, errorExtra, errorMsg, playerId) {

    });
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
        _buildPlayerOperator()
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
                  max: 100,
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
        InkWell(child: Text("准备"), onTap: () {}),
        InkWell(child: Text("播放"), onTap: () {}),
        InkWell(child: Text("暂停"), onTap: () {}),
        InkWell(child: Text("停止"), onTap: () {})
      ],
    );
  }

  void onViewPlayerCreated(int viewId) {
    this._flutterAliLiveShiftPlayer.setPlayerView(viewId);
    var time = new DateTime.now().millisecondsSinceEpoch;
    var timeLineUrl = "$_timeLineUrl&lhs_start_unix_s_0=${time - 5 * 60}&lhs_end_unix_s_0=${time + 5 * 60}";
    _flutterAliLiveShiftPlayer.setDataSource(timeLineUrl, _url);
    _flutterAliLiveShiftPlayer.prepare();
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
