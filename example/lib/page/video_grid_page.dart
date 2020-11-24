import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aliplayer_example/config.dart';
import 'package:flutter_aliplayer_example/model/video_model.dart';
import 'package:flutter_aliplayer_example/util/network_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_aliplayer/flutter_alilistplayer.dart';

class VideoGridPage extends StatefulWidget {
  @override
  _VideoGridPageState createState() => _VideoGridPageState();
}

class _VideoGridPageState extends State<VideoGridPage> {
  List _dataList = [];
  int _page = 1;
  VideoShowMode _showMode = VideoShowMode.Srceen;

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  FlutterAliListPlayer fAliListPlayer;

  int _curIdx = 0;

  @override
  void initState() {
    super.initState();
    fAliListPlayer = FlutterAliListPlayer.init(1);
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
    NetWorkUtils.instance.getHttp(HttpConstant.GET_RANDOM_USER,
        successCallback: (data) {
      String token = data['token'];
      NetWorkUtils.instance.getHttp(HttpConstant.GET_RECOMMEND_VIDEO_LIST,
          params: {'token': token, "pageIndex": _page, "pageSize": 10},
          successCallback: (data) {
        print('data=$data');
        VideoListModel videoListModel = VideoListModel.fromJson(data);
        if (videoListModel.videoList.isNotEmpty) {
          _dataList.addAll(videoListModel.videoList);
        }
        _refreshController.refreshCompleted();
        if (videoListModel.videoList.length < 10) {
          _refreshController.loadNoData();
        } else {
          _refreshController.loadComplete();
        }
        setState(() {});
      }, errorCallback: (error) {
        print("error");
      });
      setState(() {});
    }, errorCallback: (error) {
      print("error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ? PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _dataList.length,
                physics: PageScrollPhysics(),
                onPageChanged: (value) {
                  print('object===$value');
                  _curIdx = value;
                  start();
                },
                itemBuilder: (BuildContext context, int index) {
                  VideoModel model = _dataList[index];
                  return Container(
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
                            height: MediaQuery.of(context).size.height),
                      ],
                    ),
                  );
                })
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
                  return Image.network(
                    model.coverUrl,
                    fit: BoxFit.fitWidth,
                  );
                },
              ),
      ),
    );
  }

  void onViewPlayerCreated() async {
    fAliListPlayer.setAutoPlay(true);
    fAliListPlayer.setLoop(true);
    print('onViewPlayerCreated===');
  }

  void start() async {
    if (_dataList != null &&
        _dataList.length > 0 &&
        _curIdx < _dataList.length) {
      print('start===$_curIdx');
      VideoModel model = _dataList[_curIdx];
      print('url===${model.fileUrl}');
      // this.fAliListPlayer.setUrl(model.fileUrl);
      NetWorkUtils.instance.getHttp(HttpConstant.GET_STS,
          successCallback: (data) {
        var map = {
          DataSourceRelated.VID_KEY: model.videoId,
          DataSourceRelated.ACCESSKEYID_KEY: data["accessKeyId"],
          DataSourceRelated.ACCESSKEYSECRET_KEY: data["accessKeySecret"],
          DataSourceRelated.SECURITYTOKEN_KEY: data["securityToken"],
          DataSourceRelated.REGION_KEY: DataSourceRelated.DEFAULT_REGION,
          DataSourceRelated.PREVIEWTIME_KEY: ""
        };

        this.fAliListPlayer.setVidSts(Map<String, String>.from(map));
        this.fAliListPlayer.prepare();
        this.fAliListPlayer.play();
        setState(() {});
      }, errorCallback: (error) {
        print("error");
      });
    }
  }
}
