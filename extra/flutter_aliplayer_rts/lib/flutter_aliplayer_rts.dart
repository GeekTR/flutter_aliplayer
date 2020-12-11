
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterAliplayerRts {
  static const MethodChannel _channel =
      const MethodChannel('flutter_aliplayer_rts');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
