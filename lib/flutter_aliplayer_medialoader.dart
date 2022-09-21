import 'package:flutter/services.dart';

import 'flutter_avpdef.dart';

typedef OnCompletion = void Function(String url);
typedef OnError = void Function(String url, int code, String msg);
typedef OnCancel = void Function(String url);

class FlutterAliPlayerMediaLoader {
  static MethodChannel methodChannel =
      MethodChannel("plugins.flutter_aliplayer_media_loader");

  static EventChannel eventChannel = EventChannel("flutter_aliplayer_media_loader_event");

  static FlutterAliPlayerMediaLoader? _instance;

  FlutterAliPlayerMediaLoader._(){
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  static FlutterAliPlayerMediaLoader _getInstance(){
    if(_instance == null){
      return FlutterAliPlayerMediaLoader._();
    }
    return _instance!;
  }

  factory FlutterAliPlayerMediaLoader() => _getInstance();

  OnCompletion? onCompletion;
  OnCancel? onCancel;
  OnError? onError;

  void load(String url, String duration) async {
    var map = {
      "url": url,
      "duration": duration
    };
    await methodChannel.invokeMethod("load", map);
  }

  void resume(String url) async {
    await methodChannel.invokeMethod("resume", url);
  }

  void pause(String url) async {
    await methodChannel.invokeMethod("pause", url);
  }

  void cancel(String url) async {
    await methodChannel.invokeMethod("cancel", url);
  }

  void setOnLoadStatusListener(
      OnCompletion? onCompletion, OnCancel? onCancel, OnError? onError) {
    this.onCompletion = onCompletion;
    this.onCancel = onCancel;
    this.onError = onError;
  }

  ///回调分发
  void _onEvent(dynamic event) {
    String method = event[EventChanneldef.TYPE_KEY];
    switch(method){
      case "onError":
        String errorUrl = event["url"];
        String errorCode = event["code"];
        String errorMsg = event["msg"];
        print("预加载失败：$errorUrl -- $errorCode -- $errorMsg");
        break;
      case "onCompleted":
        String completeUrl = event["url"];
        print("预加载完成：$completeUrl");
        break;
      case "onCancel":
        String cancelUrl = event["url"];
        print("预加载取消：$cancelUrl");
        break;
    }
  }

  void _onError(dynamic error) {}
}
