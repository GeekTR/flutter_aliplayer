import 'package:flutter/material.dart';

class CommomUtils {
  static pushPage(BuildContext context, Widget route) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => route));
  }
}

/// 播放方式
enum PlayMode { URL, STS, AUTH, MPS }

///播放源相关
class DataSourceRelated {
  static String DEFAULT_REGION = "cn-shanghai";
  static String DEFAULT_VID = "63566edb9f61417bb46b0bb2b26cb29e";
  static String DEFAULT_URL =
      "https://alivc-demo-vod.aliyuncs.com/6b357371ef3c45f4a06e2536fd534380/eb3f139a4b437d1e9b623ee1b671115b-ld.mp4";

  static String REGION_KEY = "region";
  static String URL_KEY = "url";
  static String VID_KEY = "vid";
  static String ACCESSKEYID_KEY = "accessKeyId";
  static String ACCESSKEYSECRET_KEY = "accessKeySecret";
  static String SECURITYTOKEN_KEY = "securityToken";
  static String PREVIEWTIME_KEY = "previewTime";
  static String PLAYAUTH_KEY = "playAuth";
  static String PLAYDOMAIN_KEY = "playDomain";
  static String AUTHINFO_KEY = "authInfo";
  static String HLSURITOKEN_KEY = "hlsUriToken";
}
