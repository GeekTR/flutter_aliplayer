import 'package:flutter/services.dart';
import 'package:flutter_aliplayer/flutter_alilistplayer.dart';

class FlutterAliPlayerFactory {
  MethodChannel _methodChannel =
      MethodChannel("plugins.flutter_aliplayer_factory");

  FlutterAliListPlayer createAliListPlayer() {
    _methodChannel.invokeMethod("createAliListPlayer");
    FlutterAliListPlayer flutterAliListPlayer = FlutterAliListPlayer.init(0);
    return flutterAliListPlayer;
  }

  FlutterAliplayer createAliPlayer() {
    _methodChannel.invokeMethod("createAliPlayer");
    FlutterAliplayer flutterAliplayer = FlutterAliplayer.init(0);
    return flutterAliplayer;
  }
}
