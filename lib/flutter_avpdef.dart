class FlutterAvpdef {
  /**@brief 不保持比例平铺*/
  /// **@brief Auto stretch to fit.*/
  static const int AVP_SCALINGMODE_SCALETOFILL = 0;
  /**@brief 保持比例，黑边*/
  /// **@brief Keep aspect ratio and add black borders.*/
  static const int AVP_SCALINGMODE_SCALEASPECTFIT = 1;
  /**@brief 保持比例填充，需裁剪*/
  /// **@brief Keep aspect ratio and crop.*/
  static const int AVP_SCALINGMODE_SCALEASPECTFILL = 2;

  /**@brief 旋转模式*/
  /// **@brief Rotate mode*/
  static const int AVP_ROTATE_0 = 0;
  static const int AVP_ROTATE_90 = 90;
  static const int AVP_ROTATE_180 = 180;
  static const int AVP_ROTATE_270 = 270;

  /**@brief 镜像模式*/
  /// **@brief Mirroring mode*/
  static const int AVP_MIRRORMODE_NONE = 0;
  static const int AVP_MIRRORMODE_HORIZONTAL = 1;
  static const int AVP_MIRRORMODE_VERTICAL = 2;

  /// Log 日志级别
  static const int AF_LOG_LEVEL_NONE = 0;
  static const int AF_LOG_LEVEL_FATAL = 8;
  static const int AF_LOG_LEVEL_ERROR = 16;
  static const int AF_LOG_LEVEL_WARNING = 24;
  static const int AF_LOG_LEVEL_INFO = 32;
  static const int AF_LOG_LEVEL_DEBUG = 48;
  static const int AF_LOG_LEVEL_TRACE = 56;

  ///infoCode
  static const int UNKNOWN = -1;
  static const int LOOPINGSTART = 0;
  static const int BUFFEREDPOSITION = 1;
  static const int CURRENTPOSITION = 2;
  static const int AUTOPLAYSTART = 3;
  static const int SWITCHTOSOFTWAREVIDEODECODER = 100;
  static const int AUDIOCODECNOTSUPPORT = 101;
  static const int AUDIODECODERDEVICEERROR = 102;
  static const int VIDEOCODECNOTSUPPORT = 103;
  static const int VIDEODECODERDEVICEERROR = 104;
  static const int VIDEORENDERINITERROR = 105;
  static const int DEMUXERTRACEID = 106;
  static const int NETWORKRETRY = 108;
  static const int CACHESUCCESS = 109;
  static const int CACHEERROR = 110;
  static const int LOWMEMORY = 111;
  static const int NETWORKRETRYSUCCESS = 113;
  static const int SUBTITLESELECTERROR = 114;
  static const int DIRECTCOMPONENTMSG = 116;
  static const int RTSSERVERMAYBEDISCONNECT = 805371905;
  static const int RTSSERVERRECOVER = 805371906;

  ///精准seek
  static const int ACCURATE = 1;
  static const int INACCURATE = 16;

  ///下载方式
  static const String DOWNLOADTYPE_STS = "download_sts";
  static const String DOWNLOADTYPE_AUTH = "download_auth";

  ///黑名单
  static const String BLACK_DEVICES_H264 = "HW_Decode_H264";
  static const String BLACK_DEVICES_HEVC = "HW_Decode_HEVC";
}

class EventChanneldef {
  static const String TYPE_KEY = "method";

  static const String DOWNLOAD_PREPARED = "download_prepared";
  static const String DOWNLOAD_PROGRESS = "download_progress";
  static const String DOWNLOAD_PROCESS = "download_process";
  static const String DOWNLOAD_COMPLETION = "download_completion";
}
