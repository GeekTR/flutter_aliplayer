import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlutterAliplayer {

  MethodChannel _channel;
  FlutterAliplayer.init(int id) {
    _channel = new MethodChannel('flutter_aliplayer_$id');
  }

  Future<void> setUrl(String url) async {
    assert(url != null);
    return _channel.invokeMethod('setUrl', url);
  }

  Future<void> prepare() async {
    return _channel.invokeMethod('prepare');
  }

  Future<void> play() async {
    return _channel.invokeMethod('play');
  }

  Future<void> pause() async {
    return _channel.invokeMethod('pause');
  }

  Future<void> stop() async {
    return _channel.invokeMethod('stop');
  }
}

typedef void AliPlayerViewCreatedCallback(FlutterAliplayer fAliplayer);

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
    if (widget.onCreated == null) {
      return;
    }
    widget.onCreated(new FlutterAliplayer.init(id));
  }

}
