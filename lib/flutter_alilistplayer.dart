
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'flutter_aliplayer.dart';
export 'flutter_aliplayer.dart';

class FlutterAliListPlayer extends FlutterAliplayer{

  FlutterAliListPlayer.init(int id) : super.init(id){
    channel = new MethodChannel('flutter_alilistplayer');
  }

  Future<void> addVidSource({@required vid,@required uid}) async {
    Map<String, dynamic> info = {
      'vid':vid,
      'uid':uid
    };
    return channel.invokeMethod("addVidSource", info);
  }

  Future<void> addUrlSource({@required url,@required uid}) async {
    Map<String, dynamic> info = {
      'url':url,
      'uid':uid
    };
    return channel.invokeMethod("addUrlSource", info);
  }

  Future<void> removeSource(String uid) async {
    return channel.invokeMethod("removeSource", uid);
  }

  Future<void> clear() async {
    return channel.invokeMethod("clear");
  }

  Future<void> moveToNext({@required accId,@required accKey,@required token,@required region}) async {
    Map<String, dynamic> info = {
      'accId':accId,
      'accKey':accKey,
      'token':token,
      'region':region
    };
    return channel.invokeMethod("moveToNext",info);
  }

  Future<void> moveToPre({@required accId,@required accKey,@required token,@required region}) async {
    Map<String, dynamic> info = {
      'accId':accId,
      'accKey':accKey,
      'token':token,
      'region':region
    };
    return channel.invokeMethod("moveToPre",info);
  }

  Future<void> moveTo({@required uid,@required accId,@required accKey,@required token,@required region}) async {
    Map<String, dynamic> info = {
      'uid':uid,
      'accId':accId,
      'accKey':accKey,
      'token':token,
      'region':region
    };
    return channel.invokeMethod("moveTo",info);
  }
  
}