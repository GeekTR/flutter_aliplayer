import 'package:flutter/material.dart';
import 'package:flutter_aliplayer_example/config.dart';
import 'package:flutter_aliplayer_example/model/video_model.dart';
import 'package:flutter_aliplayer_example/util/network_utils.dart';

class VideoGridPage extends StatefulWidget {
  @override
  _VideoGridPageState createState() => _VideoGridPageState();
}

class _VideoGridPageState extends State<VideoGridPage> {
  List _dataList = [];

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  _loadData() {
    NetWorkUtils.instance.getHttp(HttpConstant.GET_VIDEO_LIST, successCallback: (data) {
      print('data=$data');
      VideoListModel videoListModel =VideoListModel.fromJson(data);
      _dataList = videoListModel.videoList;
      setState(() {
        
      });
    }, errorCallback: (error) {
      print("error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('播放列表'),
      ),
      body: GridView.builder(
        shrinkWrap: true,
        itemCount: _dataList.length,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 9/16,
        ),
        itemBuilder: (context, index) {
          VideoModel model = _dataList[index];
          return Image.network(
                model.coverUrl,
                fit: BoxFit.cover,
              );
        },
      ),
    );
  }
}
