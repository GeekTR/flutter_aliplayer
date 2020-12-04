import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_aliplayer/flutter_alilistplayer.dart';

class FlutterAliPlayerFactory {
  MethodChannel _methodChannel =
      MethodChannel("plugins.flutter_aliplayer_factory");

  FlutterAliListPlayer createAliListPlayer() {
    if(Platform.isAndroid){
      _methodChannel.invokeMethod("createAliListPlayer");
    }
    FlutterAliListPlayer flutterAliListPlayer = FlutterAliListPlayer.init(0);
    return flutterAliListPlayer;
  }

  FlutterAliplayer createAliPlayer() {
    if(Platform.isAndroid){
      _methodChannel.invokeMethod("createAliPlayer");
    }
    FlutterAliplayer flutterAliplayer = FlutterAliplayer.init(0);
    return flutterAliplayer;
  }
}
