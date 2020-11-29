import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aliplayer/flutter_avpdef.dart';

import 'flutter_avpdef.dart';

export 'flutter_avpdef.dart';

typedef OnPrepared = void Function();
typedef OnRenderingStart = void Function();
typedef OnVideoSizeChanged = void Function(int width, int height);
typedef OnSnapShot = void Function(); //TODO

// typedef OnTrackChangedListener = void Function(); //TODO
typedef OnChangedSuccess = void Function();
typedef OnChangedFail = void Function();

typedef OnSeekComplete = void Function();
typedef OnSeiData = void Function(); //TODO

typedef OnLoadingBegin = void Function();
typedef OnLoadingProgress = void Function(int percent, double netSpeed);
typedef OnLoadingEnd = void Function();

typedef OnStateChanged = void Function(int newState);

// typedef OnSubtitleDisplayListener = void Function(); //TODO
typedef OnSubtitleExtAdded = void Function(); //TODO
typedef OnSubtitleShow = void Function(); //TODO
typedef OnSubtitleHide = void Function(); //TODO
typedef OnTrackReady = void Function();

typedef OnInfo = void Function(int infoCode, int extraValue, String extraMsg);
typedef OnError = void Function(); //
typedef OnCompletion = void Function();

class FlutterAliplayer {
  OnLoadingBegin onLoadingBegin;
  OnLoadingProgress onLoadingProgress;
  OnLoadingEnd onLoadingEnd;
  OnPrepared onPrepared;
  OnRenderingStart onRenderingStart;
  OnVideoSizeChanged onVideoSizeChanged;
  OnSeekComplete onSeekComplete;
  OnStateChanged onStateChanged;
  OnInfo onInfo;
  OnCompletion onCompletion;
  OnTrackReady onTrackReady;

  MethodChannel channel;
  EventChannel eventChannel;

  FlutterAliplayer.init(int id) {
    channel = new MethodChannel('flutter_aliplayer');
    eventChannel = EventChannel("flutter_aliplayer_event");
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  void setOnPrepard(OnPrepared prepared) {
    this.onPrepared = prepared;
  }

  void setOnRenderingStart(OnRenderingStart renderingStart) {
    this.onRenderingStart = renderingStart;
  }

  void setOnVideoSizeChanged(OnVideoSizeChanged videoSizeChanged) {
    this.onVideoSizeChanged = videoSizeChanged;
  }

  void setOnSeekComplete(OnSeekComplete seekComplete) {
    this.onSeekComplete = seekComplete;
  }

  void setOnLoadingStatusListener(
      {OnLoadingBegin loadingBegin,
      OnLoadingProgress loadingProgress,
      OnLoadingEnd loadingEnd}) {
    this.onLoadingBegin = loadingBegin;
    this.onLoadingProgress = loadingProgress;
    this.onLoadingEnd = loadingEnd;
  }

  void setOnStateChanged(OnStateChanged stateChanged) {
    this.onStateChanged = stateChanged;
  }

  void setOnInfo(OnInfo info) {
    this.onInfo = info;
  }

  void setOnCompletion(OnCompletion completion) {
    this.onCompletion = completion;
  }

  void setOnTrackReady(OnTrackReady onTrackReady) {
    this.onTrackReady = onTrackReady;
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

  Future<void> snapshot() async {
    return channel.invokeMethod('snapshot');
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

  ///return deviceInfo
  Future<String> createDeviceInfo() async {
    return channel.invokeMethod("createDeviceInfo");
  }

  ///type : {FlutterAvpdef.BLACK_DEVICES_H264 / FlutterAvpdef.BLACK_DEVICES_HEVC}
  Future<void> addBlackDevice(String type, String model) async {
    var map = {
      'black_type': type,
      'black_device': model,
    };
    return channel.invokeMethod("addBlackDevice", map);
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

  Future<dynamic> getMediaInfo() {
    return channel.invokeMethod("getMediaInfo");
  }

  void _onEvent(dynamic event) {
    String method = event[EventChanneldef.TYPE_KEY];
    switch (method) {
      case "onPrepared":
        if (onPrepared != null) {
          onPrepared();
        }
        break;
      case "onRenderingStart":
        if (onRenderingStart != null) {
          onRenderingStart();
        }
        break;
      case "onVideoSizeChanged":
        if (onVideoSizeChanged != null) {
          int width = event['width'];
          int height = event['height'];
          onVideoSizeChanged(width, height);
        }
        break;
      case "onSnapShot":
        break;
      case "onChangedSuccess":
        break;
      case "onChangedFail":
        break;
      case "onSeekComplete":
        if (onSeekComplete != null) {
          onSeekComplete();
        }
        break;
      case "onSeiData":
        break;
      case "onLoadingBegin":
        if (onLoadingBegin != null) {
          onLoadingBegin();
        }
        break;
      case "onLoadingProgress":
        int percent = event['percent'];
        double netSpeed = event['netSpeed'];
        if (onLoadingProgress != null) {
          onLoadingProgress(percent, netSpeed);
        }
        break;
      case "onLoadingEnd":
        if (onLoadingEnd != null) {
          onLoadingEnd();
        }
        break;
      case "onStateChanged":
        if (onStateChanged != null) {
          int newState = event['newState'];
          onStateChanged(newState);
        }
        break;
      case "onSubtitleExtAdded":
        break;
      case "onSubtitleShow":
        break;
      case "onSubtitleHide":
        break;
      case "onInfo":
        if (onInfo != null) {
          int infoCode = event['infoCode'];
          int extraValue = event['extraValue'];
          String extraMsg = event['extraMsg'];
          onInfo(infoCode, extraValue, extraMsg);
        }
        break;
      case "onError":
        break;
      case "onCompletion":
        if (onCompletion != null) {
          onCompletion();
        }
        break;
      case "onTrackReady":
        if (onTrackReady != null) {
          this.onTrackReady();
        }
        break;
    }
  }

  void _onError(dynamic error) {}
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
