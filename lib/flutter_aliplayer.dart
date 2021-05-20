import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aliplayer/flutter_avpdef.dart';

import 'flutter_avpdef.dart';

export 'flutter_avpdef.dart';

typedef OnPrepared = void Function(String playerId);
typedef OnRenderingStart = void Function(String playerId);
typedef OnVideoSizeChanged = void Function(int width, int height,String playerId);
typedef OnSnapShot = void Function(String path,String playerId);

typedef OnSeekComplete = void Function(String playerId);
typedef OnSeiData = void Function(String playerId); //TODO

typedef OnLoadingBegin = void Function(String playerId);
typedef OnLoadingProgress = void Function(int percent, double netSpeed,String playerId);
typedef OnLoadingEnd = void Function(String playerId);

typedef OnStateChanged = void Function(int newState,String playerId);

typedef OnSubtitleExtAdded = void Function(int trackIndex, String url,String playerId);
typedef OnSubtitleShow = void Function(
    int trackIndex, int subtitleID, String subtitle,String playerId);
typedef OnSubtitleHide = void Function(int trackIndex, int subtitleID,String playerId);
typedef OnTrackReady = void Function(String playerId);

typedef OnInfo = void Function(int infoCode, int extraValue, String extraMsg,String playerId);
typedef OnError = void Function(
    int errorCode, String errorExtra, String errorMsg,String playerId);
typedef OnCompletion = void Function(String playerId);

typedef OnTrackChanged = void Function(dynamic value,String playerId);

typedef OnThumbnailPreparedSuccess = void Function(String playerId);
typedef OnThumbnailPreparedFail = void Function(String playerId);

typedef OnThumbnailGetSuccess = void Function(
    Uint8List bitmap, Int64List range,String playerId);
typedef OnThumbnailGetFail = void Function(String playerId);

class FlutterAliplayer {
   OnLoadingBegin? onLoadingBegin;
   OnLoadingProgress? onLoadingProgress;
   OnLoadingEnd? onLoadingEnd;
   OnPrepared? onPrepared;
   OnRenderingStart? onRenderingStart;
   OnVideoSizeChanged? onVideoSizeChanged;
   OnSeekComplete? onSeekComplete;
   OnStateChanged? onStateChanged;
   OnInfo? onInfo;
   OnCompletion? onCompletion;
   OnTrackReady? onTrackReady;
   OnError? onError;
   OnSnapShot? onSnapShot;

   OnTrackChanged? onTrackChanged;
   OnThumbnailPreparedSuccess? onThumbnailPreparedSuccess;
   OnThumbnailPreparedFail? onThumbnailPreparedFail;

   OnThumbnailGetSuccess? onThumbnailGetSuccess;
   OnThumbnailGetFail? onThumbnailGetFail;

  //外挂字幕
   OnSubtitleExtAdded? onSubtitleExtAdded;
   OnSubtitleHide? onSubtitleHide;
   OnSubtitleShow? onSubtitleShow;

  MethodChannel channel = new MethodChannel('flutter_aliplayer');
  EventChannel eventChannel = EventChannel("flutter_aliplayer_event");

  FlutterAliplayer.init(int id) {
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  void setOnPrepared(OnPrepared prepared) {
    this.onPrepared = prepared;
  }

  void setOnRenderingStart(OnRenderingStart renderingStart) {
    this.onRenderingStart = renderingStart;
  }

  void setOnVideoSizeChanged(OnVideoSizeChanged videoSizeChanged) {
    this.onVideoSizeChanged = videoSizeChanged;
  }

  void setOnSnapShot(OnSnapShot snapShot) {
    this.onSnapShot = snapShot;
  }

  void setOnSeekComplete(OnSeekComplete seekComplete) {
    this.onSeekComplete = seekComplete;
  }

  void setOnError(OnError onError) {
    this.onError = onError;
  }

  void setOnLoadingStatusListener(
      {required OnLoadingBegin loadingBegin,
      required OnLoadingProgress loadingProgress,
      required OnLoadingEnd loadingEnd}) {
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

  void setOnTrackChanged(OnTrackChanged onTrackChanged) {
    this.onTrackChanged = onTrackChanged;
  }

  void setOnThumbnailPreparedListener(
      {required OnThumbnailPreparedSuccess preparedSuccess,
      required OnThumbnailPreparedFail preparedFail}) {
    this.onThumbnailPreparedSuccess = preparedSuccess;
    this.onThumbnailPreparedFail = preparedFail;
  }

  void setOnThumbnailGetListener(
      {required OnThumbnailGetSuccess onThumbnailGetSuccess,
      required OnThumbnailGetFail onThumbnailGetFail}) {
    this.onThumbnailGetSuccess = onThumbnailGetSuccess;
    this.onThumbnailGetSuccess = onThumbnailGetSuccess;
  }

  void setOnSubtitleShow(OnSubtitleShow onSubtitleShow) {
    this.onSubtitleShow = onSubtitleShow;
  }

  void setOnSubtitleHide(OnSubtitleHide onSubtitleHide) {
    this.onSubtitleHide = onSubtitleHide;
  }

  void setOnSubtitleExtAdded(OnSubtitleExtAdded onSubtitleExtAdded) {
    this.onSubtitleExtAdded = onSubtitleExtAdded;
  }

  ///接口部分
  wrapWithPlayerId({playerId,arg=''}) {
    if(playerId==null){
      playerId='default';
    }
    var map = {"arg": arg, "playerId": playerId.toString()};
    return map;
  }

  Future<void> createAliPlayer({playerId}) async {
    return channel.invokeMethod('createAliPlayer',wrapWithPlayerId(playerId:playerId,arg: PlayerType.PlayerType_Single));
  }

  Future<void> setPlayerView(int viewId,{playerId}) async {
    return channel.invokeMethod('setPlayerView',wrapWithPlayerId(playerId:playerId,arg: viewId));
  }

  Future<void> setUrl(String url,{playerId}) async {
    return channel.invokeMethod('setUrl', wrapWithPlayerId(playerId:playerId,arg:url));
  }

  Future<void> prepare({playerId}) async {
    return channel.invokeMethod('prepare',wrapWithPlayerId(playerId:playerId));
  }

  Future<void> play({playerId}) async {
    return channel.invokeMethod('play',wrapWithPlayerId(playerId:playerId));
  }

  Future<void> pause({playerId}) async {
    return channel.invokeMethod('pause',wrapWithPlayerId(playerId:playerId));
  }

  Future<dynamic> snapshot(String path,{playerId}) async {
    return channel.invokeMethod('snapshot', wrapWithPlayerId(playerId:playerId,arg: path));
  }

  Future<void> stop({playerId}) async {
    return channel.invokeMethod('stop',wrapWithPlayerId(playerId:playerId));
  }

  Future<void> destroy({playerId}) async {
    return channel.invokeMethod('destroy',wrapWithPlayerId(playerId:playerId));
  }

  Future<void> seekTo(int position, int seekMode,{playerId}) async {
    var map = {"position": position, "seekMode": seekMode};
    return channel.invokeMethod("seekTo", wrapWithPlayerId(playerId:playerId,arg: map));
  }

  Future<dynamic> isLoop({playerId}) async {
    return channel.invokeMethod('isLoop',wrapWithPlayerId(playerId:playerId));
  }

  Future<void> setLoop(bool isloop,{playerId}) async {
    return channel.invokeMethod('setLoop', wrapWithPlayerId(playerId:playerId,arg: isloop));
  }

  Future<dynamic> isAutoPlay({playerId}) async {
    return channel.invokeMethod('isAutoPlay',wrapWithPlayerId(playerId:playerId));
  }

  Future<void> setAutoPlay(bool isAutoPlay,{playerId}) async {
    return channel.invokeMethod('setAutoPlay', wrapWithPlayerId(playerId:playerId,arg: isAutoPlay));
  }

  Future<dynamic> isMuted({playerId}) async {
    return channel.invokeMethod('isMuted',wrapWithPlayerId(playerId:playerId));
  }

  Future<void> setMuted(bool isMuted,{playerId}) async {
    return channel.invokeMethod('setMuted', wrapWithPlayerId(playerId:playerId,arg: isMuted));
  }

  Future<dynamic> enableHardwareDecoder({playerId}) async {
    return channel.invokeMethod('enableHardwareDecoder',wrapWithPlayerId(playerId:playerId));
  }

  Future<void> setEnableHardwareDecoder(bool isHardWare,{playerId}) async {
    return channel.invokeMethod('setEnableHardwareDecoder',wrapWithPlayerId(playerId:playerId,arg: isHardWare));
  }

  Future<void> setVidSts(
      {String? vid,
      String? region,
      String? accessKeyId,
      String? accessKeySecret,
      String? securityToken,
      String? previewTime,
      List<String>? definitionList,
      playerId}) async {
    Map<String, dynamic> stsInfo = {
      "vid": vid,
      "region": region,
      "accessKeyId": accessKeyId,
      "accessKeySecret": accessKeySecret,
      "securityToken": securityToken,
      "definitionList": definitionList,
      "previewTime": previewTime
    };
    return channel.invokeMethod("setVidSts", wrapWithPlayerId(playerId:playerId,arg: stsInfo));
  }

  Future<void> setVidAuth({
    String? vid,
    String? region,
    String? playAuth,
    String? previewTime,
    List<String>? definitionList,
    playerId
  }) async {
    Map<String, dynamic> authInfo = {
      "vid": vid,
      "region": region,
      "playAuth": playAuth,
      "definitionList": definitionList,
      "previewTime": previewTime
    };
    return channel.invokeMethod("setVidAuth", wrapWithPlayerId(playerId:playerId,arg: authInfo));
  }

  Future<void> setVidMps(Map<String, dynamic> mpsInfo,{playerId}) async {
    return channel.invokeMethod("setVidMps", wrapWithPlayerId(playerId:playerId,arg: mpsInfo));
  }

  Future<dynamic> getRotateMode({playerId}) async {
    return channel.invokeMethod('getRotateMode',wrapWithPlayerId(playerId:playerId));
  }

  Future<void> setRotateMode(int mode,{playerId}) async {
    return channel.invokeMethod('setRotateMode', wrapWithPlayerId(playerId:playerId,arg: mode));
  }

  Future<dynamic> getScalingMode({playerId}) async {
    return channel.invokeMethod('getScalingMode',wrapWithPlayerId(playerId:playerId));
  }

  Future<void> setScalingMode(int mode,{playerId}) async {
    return channel.invokeMethod('setScalingMode', wrapWithPlayerId(playerId:playerId,arg: mode));
  }

  Future<dynamic> getMirrorMode({playerId}) async {
    return channel.invokeMethod('getMirrorMode',wrapWithPlayerId(playerId:playerId));
  }

  Future<void> setMirrorMode(int mode,{playerId}) async {
    return channel.invokeMethod('setMirrorMode', wrapWithPlayerId(playerId:playerId,arg: mode));
  }

  Future<dynamic> getRate({playerId}) async {
    return channel.invokeMethod('getRate',wrapWithPlayerId(playerId:playerId));
  }

  Future<void> setRate(double mode,{playerId}) async {
    return channel.invokeMethod('setRate', wrapWithPlayerId(playerId:playerId,arg: mode));
  }

  Future<void> setVideoBackgroundColor(var color,{playerId}) async {
    return channel.invokeMethod('setVideoBackgroundColor', wrapWithPlayerId(playerId:playerId,arg: color));
  }

  Future<void> setVolume(double volume,{playerId}) async {
    return channel.invokeMethod('setVolume', wrapWithPlayerId(playerId:playerId,arg: volume));
  }

  Future<dynamic> getVolume({playerId}) async {
    return channel.invokeMethod('getVolume',wrapWithPlayerId(playerId:playerId));
  }

  Future<dynamic> getConfig({playerId}) async {
    return channel.invokeMethod("getConfig",wrapWithPlayerId(playerId:playerId));
  }

  Future<void> setConfig(Map map,{playerId}) async {
    return channel.invokeMethod("setConfig", wrapWithPlayerId(playerId:playerId,arg: map));
  }

  Future<dynamic> getCacheConfig({playerId}) async {
    return channel.invokeMethod("getCacheConfig",wrapWithPlayerId(playerId:playerId));
  }

  Future<void> setCacheConfig(Map map,{playerId}) async {
    return channel.invokeMethod("setCacheConfig", wrapWithPlayerId(playerId:playerId,arg: map));
  }

  ///return deviceInfo
  Future<dynamic> createDeviceInfo() async {
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

  Future<dynamic> getSDKVersion() async {
    return channel.invokeMethod("getSDKVersion");
  }

  Future<void> enableMix(bool enable) {
    return channel.invokeMethod("enableMix", enable);
  }

  Future<void> enableConsoleLog(bool enable) {
    return channel.invokeMethod("enableConsoleLog", enable);
  }

  Future<void> setLogLevel(int level) async {
    return channel.invokeMethod("setLogLevel", level);
  }

  Future<dynamic> getLogLevel() {
    return channel.invokeMethod("getLogLevel",);
  }

  Future<dynamic> getMediaInfo({playerId}) {
    return channel.invokeMethod("getMediaInfo",wrapWithPlayerId(playerId:playerId));
  }

  Future<dynamic> getCurrentTrack(int trackIdx,{playerId}) {
    return channel.invokeMethod("getCurrentTrack", wrapWithPlayerId(playerId:playerId,arg: trackIdx));
  }

  Future<dynamic> createThumbnailHelper(String thumbnail,{playerId}) {
    return channel.invokeMethod("createThumbnailHelper", wrapWithPlayerId(playerId:playerId,arg: thumbnail));
  }

  Future<dynamic> requestBitmapAtPosition(int position,{playerId}) {
    return channel.invokeMethod("requestBitmapAtPosition", wrapWithPlayerId(playerId:playerId,arg: position));
  }

  Future<void> addExtSubtitle(String url,{playerId}) {
    return channel.invokeMethod("addExtSubtitle", wrapWithPlayerId(playerId:playerId,arg: url));
  }

  Future<void> selectExtSubtitle(int trackIndex, bool enable,{playerId}) {
    var map = {'trackIndex': trackIndex, 'enable': enable};
    return channel.invokeMethod("selectExtSubtitle", wrapWithPlayerId(playerId:playerId,arg: map));
  }

  // accurate 0 为不精确  1 为精确  不填为忽略
  Future<void> selectTrack(int trackIdx, {int accurate = -1,playerId,}) {
    var map = {
      'trackIdx': trackIdx,
      'accurate': accurate,
    };
    return channel.invokeMethod("selectTrack", wrapWithPlayerId(playerId:playerId,arg: map));
  }

  Future<void> setPrivateService(Int8List data) {
    return channel.invokeMethod("setPrivateService", data);
  }

  Future<void> setPreferPlayerName(String playerName,{playerId}) {
    return channel.invokeMethod("setPreferPlayerName", wrapWithPlayerId(playerId:playerId,arg: playerName));
  }

  Future<dynamic> getPlayerName({playerId}) {
    return channel.invokeMethod("getPlayerName",wrapWithPlayerId(playerId:playerId));
  }

  Future<void> setStreamDelayTime(int trackIdx, int time,{playerId}) {
    var map = {'index': trackIdx, 'time': time};
    return channel.invokeMethod("setStreamDelayTime", map);
  }

  void _onEvent(dynamic event) {
    String method = event[EventChanneldef.TYPE_KEY];
    String playerId = event['playerId']??'';
    switch (method) {
      case "onPrepared":
        if (onPrepared != null) {
          onPrepared!(playerId);
        }
        break;
      case "onRenderingStart":
        if (onRenderingStart != null) {
          onRenderingStart!(playerId);
        }
        break;
      case "onVideoSizeChanged":
        if (onVideoSizeChanged != null) {
          int width = event['width'];
          int height = event['height'];
          onVideoSizeChanged!(width, height,playerId);
        }
        break;
      case "onSnapShot":
        if (onSnapShot != null) {
          String snapShotPath = event['snapShotPath'];
          onSnapShot!(snapShotPath,playerId);
        }
        break;
      case "onChangedSuccess":
        break;
      case "onChangedFail":
        break;
      case "onSeekComplete":
        if (onSeekComplete != null) {
          onSeekComplete!(playerId);
        }
        break;
      case "onSeiData":
        break;
      case "onLoadingBegin":
        if (onLoadingBegin != null) {
          onLoadingBegin!(playerId);
        }
        break;
      case "onLoadingProgress":
        int percent = event['percent'];
        double netSpeed = event['netSpeed'];
        if (onLoadingProgress != null) {
          onLoadingProgress!(percent, netSpeed,playerId);
        }
        break;
      case "onLoadingEnd":
        if (onLoadingEnd != null) {
          print("onLoadingEnd");
          onLoadingEnd!(playerId);
        }
        break;
      case "onStateChanged":
        if (onStateChanged != null) {
          int newState = event['newState'];
          onStateChanged!(newState,playerId);
        }
        break;
      case "onInfo":
        if (onInfo != null) {
          int infoCode = event['infoCode'];
          int extraValue = event['extraValue'];
          String extraMsg = event['extraMsg'];
          onInfo!(infoCode, extraValue, extraMsg,playerId);
        }
        break;
      case "onError":
        if (onError != null) {
          int errorCode = event['errorCode'];
          String errorExtra = event['errorExtra'];
          String errorMsg = event['errorMsg'];
          onError!(errorCode, errorExtra, errorMsg,playerId);
        }
        break;
      case "onCompletion":
        if (onCompletion != null) {
          onCompletion!(playerId);
        }
        break;
      case "onTrackReady":
        if (onTrackReady != null) {
          this.onTrackReady!(playerId);
        }
        break;
      case "onTrackChanged":
        if (onTrackChanged != null) {
          dynamic info = event['info'];
          this.onTrackChanged!(info,playerId);
        }
        break;
      case "thumbnail_onPrepared_Success":
        if (onThumbnailPreparedSuccess != null) {
          onThumbnailPreparedSuccess!(playerId);
        }
        break;
      case "thumbnail_onPrepared_Fail":
        if (onThumbnailPreparedFail != null) {
          onThumbnailPreparedFail!(playerId);
        }
        break;
      case "onThumbnailGetSuccess":
        dynamic bitmap = event['thumbnailbitmap'];
        dynamic range = event['thumbnailRange'];
        if (onThumbnailGetSuccess != null) {
          if (Platform.isIOS) {
            range = Int64List.fromList(range.cast<int>());
          }
          onThumbnailGetSuccess!(bitmap, range,playerId);
        }
        break;
      case "onThumbnailGetFail":
        if (onThumbnailGetFail != null) {
          onThumbnailGetFail!(playerId);
        }
        break;
      case "onSubtitleExtAdded":
        if (onSubtitleExtAdded != null) {
          int trackIndex = event['trackIndex'];
          String url = event['url'];
          onSubtitleExtAdded!(trackIndex, url,playerId);
        }
        break;
      case "onSubtitleShow":
        if (onSubtitleShow != null) {
          int trackIndex = event['trackIndex'];
          int subtitleID = event['subtitleID'];
          String subtitle = event['subtitle'];
          onSubtitleShow!(trackIndex, subtitleID, subtitle,playerId);
        }
        break;
      case "onSubtitleHide":
        if (onSubtitleHide != null) {
          int trackIndex = event['trackIndex'];
          int subtitleID = event['subtitleID'];
          onSubtitleHide!(trackIndex, subtitleID,playerId);
        }
        break;
    }
  }

  void _onError(dynamic error) {}
}

typedef void AliPlayerViewCreatedCallback(int viewId);

class AliPlayerView extends StatefulWidget {
  final AliPlayerViewCreatedCallback? onCreated;
  final x;
  final y;
  final width;
  final height;

  AliPlayerView({
    Key? key,
    @required required this.onCreated,
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
    // print("abc : create PlatFormView initState");
  }

  @override
  Widget build(BuildContext context) {
    // print("abc : create PlatFormView build");
    return nativeView();
  }

  nativeView() {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'flutter_aliplayer_render_view',
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
        // viewType: 'flutter_aliplayer_render_view',
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
      widget.onCreated!(id);
    }
  }
}
