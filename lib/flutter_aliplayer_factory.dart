import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_aliplayer/flutter_alilistplayer.dart';

class FlutterAliPlayerFactory {
  static MethodChannel methodChannel = MethodChannel("plugins.flutter_aliplayer_factory");

  static FlutterAliListPlayer createAliListPlayer({playerId}) {
    if (Platform.isAndroid) {
      methodChannel.invokeMethod("createAliListPlayer");
    }
    FlutterAliListPlayer flutterAliListPlayer = FlutterAliListPlayer.init(playerId);
    flutterAliListPlayer.create();
    return flutterAliListPlayer;
  }

  static FlutterAliplayer createAliPlayer({playerId}) {
    if (Platform.isAndroid) {
      methodChannel.invokeMethod("createAliPlayer");
    }
    FlutterAliplayer flutterAliplayer = FlutterAliplayer.init(playerId);
    flutterAliplayer.create();
    return flutterAliplayer;
  }

  static Future<void> initService(Uint8List byteData) {
    return methodChannel.invokeMethod("initService", byteData);
  }

}
