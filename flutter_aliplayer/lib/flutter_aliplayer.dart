import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlutterAliplayer {
  // static const MethodChannel _channel =
  //     const MethodChannel('flutter_aliplayer');

  MethodChannel _channel;
  FlutterAliplayer.init(int id) {
    _channel = new MethodChannel('flutter_aliplayer_$id');
  }

  Future<void> setUrl(String url) async {
    assert(url != null);
    return _channel.invokeMethod('setUrl', url);
  }

  Future<void> prepare() async {
    return _channel.invokeMethod('prepare');
  }

  Future<void> play() async {
    return _channel.invokeMethod('play');
  }

  Future<void> pause() async {
    return _channel.invokeMethod('pause');
  }

  Future<void> stop() async {
    return _channel.invokeMethod('stop');
  }
}

typedef void AliVideoPlayerCreatedCallback(FlutterAliplayer fAliplayer);

class AliVideoPlayer extends StatefulWidget {
  final AliVideoPlayerCreatedCallback onCreated;
  final x;
  final y;
  final width;
  final height;

  AliVideoPlayer({
    Key key,
    @required this.onCreated,
    @required this.x,
    @required this.y,
    @required this.width,
    @required this.height,
  });

  @override
  State<StatefulWidget> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<AliVideoPlayer> {
  var _sliderCurrentValue = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          //renderView
          nativeView(),
          //顶部标题栏
          _buildTopController(),
          //底部控制栏
          _buildBottomController(),
        ],
      ),
      onHorizontalDragStart: (DragStartDetails details) {
        print("onHorizontalDragStart: ${details.globalPosition}");
        // if (!controller.value.initialized) {
        //   return;
        // }
        // _controllerWasPlaying = controller.value.isPlaying;
        // if (_controllerWasPlaying) {
        //   controller.pause();
        // }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        print("onHorizontalDragUpdate: ${details.globalPosition}");
        print(details.globalPosition);
        // if (!controller.value.initialized) {
        //   return;
        // }
        // seekToRelativePosition(details.globalPosition);
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        print("onHorizontalDragEnd");
        // if (_controllerWasPlaying) {
        //   controller.play();
        // }
      },
      onTapDown: (TapDownDetails details) {
        print("onTapDown: ${details.globalPosition}");
      },
    );
  }

  nativeView() {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'plugins.flutter_aliplayer',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: <String, dynamic>{
          "x": widget.x,
          "y": widget.y,
          "width": widget.width,
          "height": widget.height,
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return UiKitView(
        viewType: 'plugins.flutter_aliplayer',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: <String, dynamic>{
          "x": widget.x,
          "y": widget.y,
          "width": widget.width,
          "height": widget.height,
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
  }

  Future<void> _onPlatformViewCreated(id) async {
    print("abc : onPlatformViewCreated 1 $id");
    if (widget.onCreated == null) {
      return;
    }
    print("abc : onPlatformViewCreated 2 ");
    widget.onCreated(new FlutterAliplayer.init(id));
  }

  Widget _buildTopController() {
    return Row(
      children: [
        SizedBox(
          width: 5.0,
        ),
        Icon(Icons.arrow_back, color: Colors.white),
        SizedBox(
          width: 10.0,
        ),
        Text("我是标题", style: TextStyle(color: Colors.white))
      ],
    );
  }

  Widget _buildBottomController() {
    return Container(
      alignment: Alignment.bottomLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        verticalDirection: VerticalDirection.down,
        children: [
          SizedBox(
            width: 5.0,
          ),
          Icon(Icons.play_arrow, color: Colors.white),
          SizedBox(
            width: 5.0,
          ),
          Text("00:00", style: TextStyle(color: Colors.white)),
          Text("/", style: TextStyle(color: Colors.white)),
          Text("00:00", style: TextStyle(color: Colors.white)),
          Expanded(
              child: Container(
            height: 25.0,
            child: Slider(
              value: _sliderCurrentValue,
              max: 100,
              onChanged: (value) {
                setState(() {
                  _sliderCurrentValue = value;
                  print("onchange $_sliderCurrentValue");
                });
              },
              onChangeStart: (start) {
                print("start $start");
              },
              onChangeEnd: (end) {
                print("end $end");
              },
            ),
          )),
          Icon(Icons.pages, color: Colors.white),
          SizedBox(
            width: 5.0,
          ),
        ],
      ),
    );
  }
}
