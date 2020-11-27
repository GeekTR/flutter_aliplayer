import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'flutter_avpdef.dart';

class FlutterAliplayer {
  MethodChannel channel;
  FlutterAliplayer.init(int id) {
    channel = new MethodChannel('flutter_aliplayer');
  }

  Future<void> setUrl(String url) async {
    assert(url != null);
    return channel.invokeMethod('setUrl', url);
  }

  Future<void> prepare() async {
    return channel.invokeMethod('prepare');
  }

  Future<void> play() async {
    return channel.invokeMethod('play');
  }

  Future<void> pause() async {
    return channel.invokeMethod('pause');
  }

  Future<void> stop() async {
    return channel.invokeMethod('stop');
  }

  Future<void> destroy() async {
    return channel.invokeMethod('destroy');
  }

  Future<bool> isLoop() async {
    return channel.invokeMethod('isLoop');
  }

  Future<void> setLoop(bool isloop) async {
    return channel.invokeMethod('setLoop', isloop);
  }

  Future<bool> isAutoPlay() async {
    return channel.invokeMethod('isAutoPlay');
  }

  Future<void> setAutoPlay(bool isAutoPlay) async {
    return channel.invokeMethod('setAutoPlay', isAutoPlay);
  }

  Future<bool> isMuted() async {
    return channel.invokeMethod('isMuted');
  }

  Future<void> setMuted(bool isMuted) async {
    return channel.invokeMethod('setMuted', isMuted);
  }

  Future<bool> enableHardwareDecoder() async {
    return channel.invokeMethod('enableHardwareDecoder');
  }

  Future<void> setEnableHardwareDecoder(bool isHardWare) async {
    return channel.invokeMethod('setEnableHardwareDecoder', isHardWare);
  }

  Future<void> setVidSts(Map<String, String> stsInfo) async {
    return channel.invokeMethod("setVidSts", stsInfo);
  }

  Future<void> setVidAuth(Map<String, String> authInfo) async {
    return channel.invokeMethod("setVidAuth", authInfo);
  }

  Future<void> setVidMps(Map<String, String> mpsInfo) async {
    return channel.invokeMethod("setVidMps", mpsInfo);
  }

  Future<int> getRotateMode() async {
    return channel.invokeMethod('getRotateMode');
  }

  Future<void> setRotateMode(int mode) async {
    return channel.invokeMethod('setRotateMode', mode);
  }

  Future<int> getScalingMode() async {
    return channel.invokeMethod('getScalingMode');
  }

  Future<void> setScalingMode(int mode) async {
    return channel.invokeMethod('setScalingMode', mode);
  }

  Future<int> getMirrorMode() async {
    return channel.invokeMethod('getMirrorMode');
  }

  Future<void> setMirrorMode(int mode) async {
    return channel.invokeMethod('setMirrorMode', mode);
  }

  Future<double> getRate() async {
    return channel.invokeMethod('getRate');
  }

  Future<void> setRate(double mode) async {
    return channel.invokeMethod('setRate', mode);
  }

  Future<void> setVideoBackgroundColor(var color) async {
    return channel.invokeMethod('setVideoBackgroundColor', color);
  }

  Future<void> setVolume(double volume) async {
    return channel.invokeMethod('setVolume', volume);
  }

  Future<dynamic> getConfig() async {
    return channel.invokeMethod("getConfig");
  }

  Future<void> setConfig(Map map) async {
    return channel.invokeMethod("setConfig", map);
  }

  Future<dynamic> getCacheConfig() async {
    return channel.invokeMethod("getCacheConfig");
  }

  Future<void> setCacheConfig(Map map) async {
    return channel.invokeMethod("setCacheConfig", map);
  }

  Future<String> getSDKVersion() async {
    return channel.invokeMethod("getSDKVersion");
  }

  Future<void> enableConsoleLog(bool enable) {
    return channel.invokeMethod("enableConsoleLog", enable);
  }

  Future<void> setLogLevel(int level) async {
    return channel.invokeMethod("setLogLevel", level);
  }

  Future<int> getLogLevel() {
    return channel.invokeMethod("getLogLevel");
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
