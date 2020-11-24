///自定义下载类
class CustomDownloaderModel {
  String videoId;
  String title;
  String coverUrl;
  int index;
  int vodFileSize;
  String vodFormat;
  String vodDefinition;
  String savePath;
  String stateMsg;
  DownloadState downloadState;
  String accessKeyId;
  String accessKeySecret;
  String securityToken;

  CustomDownloaderModel(
      {this.videoId,
      this.title,
      this.coverUrl,
      this.index,
      this.vodFileSize,
      this.vodFormat,
      this.vodDefinition,
      this.savePath,
      this.stateMsg,
      this.downloadState,
      this.accessKeyId,
      this.accessKeySecret,
      this.securityToken});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['mVideoId'] = this.videoId;
    data['mTitle'] = this.title;
    data['mCoverUrl'] = this.coverUrl;
    data['mIndex'] = this.index;
    data['mVodFileSize'] = this.vodFileSize;
    data['mVodFormat'] = this.vodFormat;
    data['mVodDefinition'] = this.vodDefinition;
    data['mSavePath'] = this.savePath;
    data['mDownloadState'] = this.downloadState.index;
    data['accessKeyId'] = this.accessKeyId;
    data['accessKeySecret'] = this.accessKeySecret;
    data['securityToken'] = this.securityToken;
    return data;
  }
}

enum DownloadState { PREPARE, START, STOP, COMPLETE, ERROR }
