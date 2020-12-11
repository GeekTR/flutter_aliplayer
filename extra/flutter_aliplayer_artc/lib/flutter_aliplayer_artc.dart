
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterAliplayerArtc {
  static const MethodChannel _channel =
      const MethodChannel('flutter_aliplayer_artc');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
