import 'package:flutter/services.dart';
import 'package:flutter_aliplayer/flutter_avpdef.dart';

typedef OnProgress(Map<String, dynamic> map);

class FlutterAliDownloader {
  MethodChannel _methodChannel = MethodChannel("plugins.flutter_alidownload");
  EventChannel _eventChannel =
      EventChannel("plugins.flutter_alidownload_event");

  Stream<dynamic> _receiveStream;
  OnProgress onProgress;

  FlutterAliDownloader.init() {
    _receiveStream = _eventChannel.receiveBroadcastStream();
  }

  Future<dynamic> prepare(Map map) async {
    return _methodChannel.invokeMethod("prepare", map);
  }

  Stream<dynamic> start(Map map) {
    _methodChannel.invokeMethod("start", map);
    return _receiveStream;
  }

  Future<dynamic> selectItem(Map map) {
    return _methodChannel.invokeMethod("selectItem", map);
  }

  void setSaveDir(String path) {
    _methodChannel.invokeMethod("setSaveDir", path);
  }

  Future<dynamic> stop(Map map) {
    return _methodChannel.invokeMethod("stop", map);
  }

  Future<dynamic> delete(Map map) {
    return _methodChannel.invokeMethod("delete", map);
  }

  Future<dynamic> getFilePath(Map map) {
    return _methodChannel.invokeMethod("getFilePath", map);
  }

  Future<dynamic> release(Map map) {
    return _methodChannel.invokeMethod("release", map);
  }

  Future<dynamic> updateSource(Map map) {
    return _methodChannel.invokeMethod("updateSource", map);
  }

  Future<dynamic> setDownloaderConfig(Map map) {
    return _methodChannel.invokeMethod("setDownloaderConfig", map);
  }

  void setOnProgressListener(OnProgress onProgress) {
    this.onProgress = onProgress;
  }

  void _onEvent(dynamic event) {
    if (event[EventChanneldef.TYPE_KEY] == EventChanneldef.DOWNLOAD_PREPARED) {
    } else if (event[EventChanneldef.TYPE_KEY] ==
        EventChanneldef.DOWNLOAD_PROGRESS) {
      // if (onProgress != null) {
      //   onProgress(event);
      // }
      print(
          "abc : progress ${event['download_progress']} ,,, ${event['mVodDefinition']}");
    }
  }

  void _onError(dynamic error) {
    print("abc : 原生发送消息 onError");
  }
}
