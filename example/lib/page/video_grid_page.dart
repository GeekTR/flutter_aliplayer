import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aliplayer_example/config.dart';
import 'package:flutter_aliplayer_example/model/video_model.dart';
import 'package:flutter_aliplayer_example/util/network_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
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
      appBar: _showMode == VideoShowMode.Srceen?null:AppBar(
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
            ? CustomScrollView(
                controller: _pageController,
                physics: PageScrollPhysics(),
                slivers: _dataList
                    .map((model) => SliverFillViewport(
                            delegate: SliverChildListDelegate([
                          Image.network(
                            model.coverUrl,
                            fit: BoxFit.fitWidth,
                          )
                        ])))
                    .toList())
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
}
