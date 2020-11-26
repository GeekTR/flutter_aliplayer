import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aliplayer_example/config.dart';
import 'package:flutter_aliplayer_example/model/video_model.dart';
import 'package:flutter_aliplayer_example/util/network_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_aliplayer/flutter_alilistplayer.dart';

class VideoGridPage extends StatefulWidget {
  final ModeType playMode;

  const VideoGridPage({Key key, this.playMode}) : super(key: key);

  @override
  _VideoGridPageState createState() => _VideoGridPageState();
}

class _VideoGridPageState extends State<VideoGridPage> {
  List _dataList = [];
  int _page = 1;
  VideoShowMode _showMode = VideoShowMode.Grid;

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  PageController _pageController;

  FlutterAliListPlayer fAliListPlayer = FlutterAliListPlayer.init(1);

  int _curIdx = 0;

  bool _isPause = false;

  @override
  void initState() {
    super.initState();
    fAliListPlayer.setAutoPlay(true);
    fAliListPlayer.setLoop(true);
  }

  _onRefresh() async {
    _page = 1;
    _dataList = [];
    _loadData();
  }

  _onLoadMore() async {
    _page++;
    _loadData();
  }

  _loadData() async {
    String url;
    if (widget.playMode == ModeType.URL) {
      url = HttpConstant.GET_VIDEO_LIST;
    } else if (widget.playMode == ModeType.STS) {
      url = HttpConstant.GET_RECOMMEND_VIDEO_LIST;
    }
    NetWorkUtils.instance.getHttp(HttpConstant.GET_RANDOM_USER,
        successCallback: (data) {
      String token = data['token'];
      NetWorkUtils.instance.getHttp(url,
          params: {'token': token, "pageIndex": _page, "pageSize": 10},
          successCallback: (data) {
        print('data=$data');
        _loadDataFinish(data);
      }, errorCallback: (error) {
        print("error");
      });
    }, errorCallback: (error) {
      print("error");
    });
  }

  _loadDataFinish(data) {
    VideoListModel videoListModel = VideoListModel.fromJson(data);
    if (videoListModel.videoList.isNotEmpty) {
      videoListModel.videoList.forEach((element) {
        if (widget.playMode == ModeType.URL) {
          fAliListPlayer.addUrlSource(
              url: element.fileUrl, uid: element.videoId);
        } else if (widget.playMode == ModeType.STS) {
          fAliListPlayer.addVidSource(
              vid: element.videoId, uid: element.videoId);
        }
      });

      _dataList.addAll(videoListModel.videoList);
    }
    _refreshController.refreshCompleted();
    if (videoListModel.videoList.length < 10) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_showMode == VideoShowMode.Srceen) {
          _exitScreenMode();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: _showMode == VideoShowMode.Srceen
            ? null
            : AppBar(
                title: Text('播放列表'),
              ),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: ClassicHeader(),
          footer: ClassicFooter(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoadMore,
          child: _showMode == VideoShowMode.Srceen
              ? Stack(
                  children: [
                    PageView.builder(
                        scrollDirection: Axis.vertical,
                        controller: _pageController,
                        itemCount: _dataList.length,
                        physics: PageScrollPhysics(),
                        onPageChanged: (value) {
                          print('object===$value');
                          _curIdx = value;
                          start();
                        },
                        itemBuilder: (BuildContext context, int index) {
                          VideoModel model = _dataList[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPause = !_isPause;
                              });
                              if (_isPause) {
                                this.fAliListPlayer.pause();
                              } else {
                                this.fAliListPlayer.play();
                              }
                            },
                            child: Container(
                              color: Colors.black,
                              child: Stack(
                                children: [
                                  Image.network(
                                    model.coverUrl,
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  AliPlayerView(
                                      onCreated: onViewPlayerCreated,
                                      x: 0,
                                      y: 0,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height),
                                  Container(
                                    color: Colors.black.withAlpha(0),
                                    alignment: Alignment.center,
                                    child: Offstage(
                                      offstage: _isPause == false,
                                      child: Icon(
                                        Icons.pause_circle_filled,
                                        size: 48,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                    InkWell(
                      onTap: () {
                        _exitScreenMode();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                )
              : GridView.builder(
                  shrinkWrap: true,
                  itemCount: _dataList.length,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 9 / 16,
                  ),
                  itemBuilder: (context, index) {
                    VideoModel model = _dataList[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _curIdx = index;
                          _showMode = VideoShowMode.Srceen;
                          _pageController =
                              PageController(initialPage: _curIdx);
                        });
                        start();
                      },
                      child: Container(
                        color: Colors.black,
                        child: Image.network(
                          model.coverUrl,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  void onViewPlayerCreated() async {
    print('onViewPlayerCreated===');
  }

  void start() async {
    if (_dataList != null &&
        _dataList.length > 0 &&
        _curIdx < _dataList.length) {
      print('start===$_curIdx');
      VideoModel model = _dataList[_curIdx];
      print('url===${model.fileUrl}');
      setState(() {
        _isPause = false;
      });
      if (widget.playMode == ModeType.URL) {
        this.fAliListPlayer.setUrl(model.fileUrl);
      } else if (widget.playMode == ModeType.STS) {
        NetWorkUtils.instance.getHttp(HttpConstant.GET_STS,
            successCallback: (data) {
          this.fAliListPlayer.moveTo(
              uid: model.videoId,
              accId: data["accessKeyId"],
              accKey: data["accessKeySecret"],
              token: data["securityToken"],
              region: DataSourceRelated.DEFAULT_REGION);
        }, errorCallback: (error) {
          print("error");
        });
      }
    }
  }

  void _exitScreenMode() {
    setState(() {
      _showMode = VideoShowMode.Grid;
    });
    this.fAliListPlayer.stop();
  }
}
