import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_aliplayer/flutter_alilistplayer.dart';
import 'package:flutter_aliplayer/flutter_aliliveshiftplayer.dart';

class FlutterAliPlayerFactory {
  static MethodChannel methodChannel =
      MethodChannel("plugins.flutter_aliplayer_factory");
  
  static Map<String,FlutterAliplayer> instanceMap = {};

  static FlutterAliListPlayer createAliListPlayer({playerId}) {
    FlutterAliListPlayer flutterAliListPlayer =
        FlutterAliListPlayer.init(playerId);
    flutterAliListPlayer.create();
    return flutterAliListPlayer;
  }

  static FlutterAliplayer createAliPlayer({playerId}) {
    FlutterAliplayer flutterAliplayer = FlutterAliplayer.init(playerId);
    flutterAliplayer.create();
    return flutterAliplayer;
  }

  static FlutterAliLiveShiftPlayer createAliLiveShiftPlayer({playerId}){
    FlutterAliLiveShiftPlayer flutterAliLiveShiftPlayer = FlutterAliLiveShiftPlayer.init(playerId);
    flutterAliLiveShiftPlayer.create();
    return flutterAliLiveShiftPlayer;
  }

  static Future<void> initService(Uint8List byteData) {
    return methodChannel.invokeMethod("initService", byteData);
  }
}
