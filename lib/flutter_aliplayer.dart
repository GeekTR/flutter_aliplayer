import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'flutter_avpdef.dart';

class FlutterAliplayer {
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

  Future<bool> isLoop() async {
    return _channel.invokeMethod('isLoop');
  }

  Future<void> setLoop(bool isloop) async {
    print("abc : setLoop $isLoop");
    return _channel.invokeMethod('setLoop', isloop);
  }

  Future<bool> isAutoPlay() async {
    return _channel.invokeMethod('isAutoPlay');
  }

  Future<void> setAutoPlay(bool isAutoPlay) async {
    return _channel.invokeMethod('setAutoPlay', isAutoPlay);
  }

  Future<bool> isMuted() async {
    return _channel.invokeMethod('isMuted');
  }

  Future<void> setMuted(bool isMuted) async {
    return _channel.invokeMethod('setMuted', isMuted);
  }

  Future<bool> enableHardwareDecoder() async {
    return _channel.invokeMethod('enableHardwareDecoder');
  }

  Future<void> setEnableHardwareDecoder(bool isHardWare) async {
    return _channel.invokeMethod('setEnableHardwareDecoder', isHardWare);
  }

  Future<void> setVidSts(Map<String, String> stsInfo) async {
    return _channel.invokeMethod("setVidSts", stsInfo);
  }

  Future<void> setVidAuth(Map<String, String> authInfo) async {
    return _channel.invokeMethod("setVidAuth", authInfo);
  }

  Future<void> setVidMps(Map<String, String> mpsInfo) async {
    return _channel.invokeMethod("setVidMps", mpsInfo);
  }

  Future<int> getRotateMode() async {
    return _channel.invokeMethod('getRotateMode');
  }

  Future<void> setRotateMode(int mode) async {
    return _channel.invokeMethod('setRotateMode', mode);
  }

  Future<int> getScalingMode() async {
    return _channel.invokeMethod('getScalingMode');
  }

  Future<void> setScalingMode(int mode) async {
    return _channel.invokeMethod('setScalingMode', mode);
  }

  Future<int> getMirrorMode() async {
    return _channel.invokeMethod('getMirrorMode');
  }

  Future<void> setMirrorMode(int mode) async {
    return _channel.invokeMethod('setMirrorMode', mode);
  }

  Future<double> getRate() async {
    return _channel.invokeMethod('getRate');
  }

  Future<void> setRate(double mode) async {
    return _channel.invokeMethod('setRate', mode);
  }
}

typedef void AliPlayerViewCreatedCallback();

class AliPlayerView extends StatefulWidget {
  final AliPlayerViewCreatedCallback onCreated;
  final x;
  final y;
  final width;
  final height;

  AliPlayerView({
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

class _VideoPlayerState extends State<AliPlayerView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return nativeView();
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
    if (widget.onCreated != null) {
      widget.onCreated();
    }
  }
}
