import 'dart:async';
import 'dart:io';

import 'package:flutter_aliplayer/flutter_alidownloader.dart';
import 'package:flutter_aliplayer/flutter_avpdef.dart';
import 'package:flutter_aliplayer_example/model/custom_downloader_model.dart';
import 'package:flutter_aliplayer_example/util/database_utils.dart';
import 'package:path_provider/path_provider.dart';

class AliyunDownloadManager {
  static AliyunDownloadManager _instance =
      AliyunDownloadManager._privateConstructor();
  FlutterAliDownloader _flutterAliDownloader;
  DBUtils _dbUtils;
  //下载保存地址
  String _downloadSavePath;
  //prepared集合
  List<CustomDownloaderModel> _preparedList = List();

  Map<String, StreamController> _controllerMap = Map();

  static AliyunDownloadManager get instance {
    return _instance;
  }

  AliyunDownloadManager._privateConstructor() {
    _dbUtils = DBUtils.instance;
    _flutterAliDownloader = FlutterAliDownloader.init();

    if (Platform.isAndroid) {
      getExternalStorageDirectories().then((value) {
        if (value.length > 0) {
          _downloadSavePath = value[0].path + "/download/";
          return Directory(_downloadSavePath);
        }
      }).then((value) {
        return value.exists();
      }).then((value) {
        if (!value) {
          Directory directory = Directory(_downloadSavePath);
          directory.create();
        }
        return _downloadSavePath;
      }).then((value) {
        _flutterAliDownloader.setSaveDir(_downloadSavePath);
      });
    } else if (Platform.isIOS) {
      //TODO  IOS
    }
  }

  ///比较两个对象是否相等
  bool _compareTo(CustomDownloaderModel src, CustomDownloaderModel dst) {
    return src != null &&
        dst != null &&
        src.videoId == dst.videoId &&
        src.vodDefinition == dst.vodDefinition;
  }

  Future<List<CustomDownloaderModel>> findAllDownload() {
    return _dbUtils.selectAll().then((value) {
      if (_preparedList.length > 0) {
        _preparedList.clear();
      }
      value.forEach((element) {
        CustomDownloaderModel customDownloaderModel =
            CustomDownloaderModel.fromJson(element);
        if (customDownloaderModel != null) {
          if (customDownloaderModel.downloadState != DownloadState.COMPLETE) {
            customDownloaderModel.downloadState = DownloadState.PREPARE;
            customDownloaderModel.stateMsg = "准备完成";
          }
          _preparedList.add(customDownloaderModel);
        }
      });
      return _preparedList;
    });
  }

  Future<dynamic> prepare(Map map) {
    return _flutterAliDownloader.prepare(map).then((value) {
      return value;
    });
  }

  Future<dynamic> add(CustomDownloaderModel customDownloaderModel) async {
    await Future.forEach(_preparedList, (element) {
      if (_compareTo(element, customDownloaderModel)) {
        return Future.error(
            '${customDownloaderModel.videoId} , ${customDownloaderModel.vodDefinition}  has added');
      }
    });
    var json = customDownloaderModel.toJson();
    _preparedList.add(customDownloaderModel);
    _flutterAliDownloader.selectItem(json);
    _dbUtils.insert(json);
    return Future.value(customDownloaderModel);
  }

  Stream<dynamic> start(CustomDownloaderModel customDownloaderModel) {
    String key = customDownloaderModel.videoId +
        '_' +
        customDownloaderModel.index.toString();
    StreamController _controller = _controllerMap[key];
    if (_controller == null) {
      _controller = StreamController<dynamic>();
      _controllerMap.putIfAbsent(key, () => _controller);
    }
    StreamController<dynamic> _callbackController = StreamController();
    StreamSink<dynamic> _sink = _callbackController.sink;
    _controller
        .addStream(_flutterAliDownloader.start(customDownloaderModel.toJson()));
    if (!_controller.hasListener) {
      _controller.stream.listen((event) {
        if (event[EventChanneldef.TYPE_KEY] ==
                EventChanneldef.DOWNLOAD_PROGRESS &&
            customDownloaderModel.videoId == event['mVideoId'] &&
            customDownloaderModel.index == event['mIndex']) {
          customDownloaderModel.downloadState = DownloadState.START;
          customDownloaderModel.stateMsg =
              event[EventChanneldef.DOWNLOAD_PROGRESS] + "%";
          _sink.add(customDownloaderModel);
        } else if (event[EventChanneldef.TYPE_KEY] ==
                EventChanneldef.DOWNLOAD_PROCESS &&
            customDownloaderModel.videoId == event['mVideoId'] &&
            customDownloaderModel.index == event['mIndex']) {
          customDownloaderModel.downloadState = DownloadState.START;
          customDownloaderModel.stateMsg = "ProcessingProgress \n" +
              event[EventChanneldef.DOWNLOAD_PROGRESS] +
              "%";
          _sink.add(customDownloaderModel);
        } else if (event[EventChanneldef.TYPE_KEY] ==
                EventChanneldef.DOWNLOAD_COMPLETION &&
            customDownloaderModel.videoId == event['mVideoId'] &&
            customDownloaderModel.index == event['mIndex']) {
          customDownloaderModel.downloadState = DownloadState.COMPLETE;
          customDownloaderModel.stateMsg = "下载完成";
          customDownloaderModel.savePath = event['mSavePath'];

          _dbUtils.update(customDownloaderModel.toJson());
          _sink.add(customDownloaderModel);
        }
      });
    }

    return _callbackController.stream;
  }

  Future<dynamic> stop(CustomDownloaderModel customDownloaderModel) {
    if (customDownloaderModel.downloadState == DownloadState.START ||
        customDownloaderModel.downloadState == DownloadState.PREPARE) {
      _flutterAliDownloader.stop(customDownloaderModel.toJson());
      customDownloaderModel.downloadState = DownloadState.STOP;
      customDownloaderModel.stateMsg = "暂停下载";
      return Future.value(customDownloaderModel);
    }
  }

  Future<dynamic> delete(CustomDownloaderModel customDownloaderModel) {
    var map = customDownloaderModel.toJson();
    _preparedList.remove(customDownloaderModel);
    _dbUtils.delete(map);
    _flutterAliDownloader.delete(map);
    _flutterAliDownloader.release(map);
    return Future.value(customDownloaderModel);
  }
}
