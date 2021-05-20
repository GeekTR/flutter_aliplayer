import 'package:flutter/material.dart';

import 'flutter_aliplayer.dart';
export 'flutter_aliplayer.dart';

class FlutterAliListPlayer extends FlutterAliplayer {
  FlutterAliListPlayer.init(int id) : super.init(id);

  @override
  Future<void> createAliPlayer({playerId}) async {
    return channel.invokeMethod('createAliPlayer',wrapWithPlayerId(playerId:playerId,arg: PlayerType.PlayerType_List));
  }

  Future<void> setPreloadCount(int count,{playerId}) async {
    return channel.invokeMethod("setPreloadCount", wrapWithPlayerId(playerId:playerId,arg: count));
  }

  Future<void> addVidSource({@required vid, @required uid,playerId}) async {
    Map<String, dynamic> info = {'vid': vid, 'uid': uid};
    return channel.invokeMethod("addVidSource", wrapWithPlayerId(playerId:playerId,arg: info));
  }

  Future<void> addUrlSource({@required url, @required uid,playerId}) async {
    Map<String, dynamic> info = {'url': url, 'uid': uid};
    return channel.invokeMethod("addUrlSource", wrapWithPlayerId(playerId:playerId,arg: info));
  }

  Future<void> removeSource(String uid,{playerId}) async {
    return channel.invokeMethod("removeSource", wrapWithPlayerId(playerId:playerId,arg: uid));
  }

  Future<void> clear({playerId}) async {
    return channel.invokeMethod("clear",wrapWithPlayerId(playerId:playerId));
  }

  Future<void> moveToNext(
      {@required accId,
      @required accKey,
      @required token,
      @required region}) async {
    Map<String, dynamic> info = {
      'accId': accId,
      'accKey': accKey,
      'token': token,
      'region': region
    };
    return channel.invokeMethod("moveToNext", info);
  }

  Future<void> moveToPre(
      {@required accId,
      @required accKey,
      @required token,
      @required region,
      playerId}) async {
    Map<String, dynamic> info = {
      'accId': accId,
      'accKey': accKey,
      'token': token,
      'region': region
    };
    return channel.invokeMethod("moveToPre", wrapWithPlayerId(playerId:playerId,arg: info));
  }

  ///移动到指定位置开始准备播放,url播放方式只需要填写uid；sts播放方式，需要更新sts信息
  ///uid 指定资源的uid，代表在列表中的唯一标识
  Future<void> moveTo(
      {@required String? uid,
      String? accId,
      String? accKey,
      String? token,
      String? region,
      playerId}) async {
    Map<String, dynamic> info = {
      'uid': uid,
      'accId': accId,
      'accKey': accKey,
      'token': token,
      'region': region
    };
    return channel.invokeMethod("moveTo", wrapWithPlayerId(playerId:playerId,arg: info));
  }
}
