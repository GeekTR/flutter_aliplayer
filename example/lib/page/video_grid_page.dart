import 'package:flutter/material.dart';
import 'package:flutter_aliplayer_example/config.dart';
import 'package:flutter_aliplayer_example/util/network_utils.dart';

class VideoGridPage extends StatefulWidget {
  @override
  _VideoGridPageState createState() => _VideoGridPageState();
}

class _VideoGridPageState extends State<VideoGridPage> {
  List _data = ['1', '2', '3', '4'];

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  _loadData(){
NetWorkUtils.getHttp(HttpConstant.GET_STS,
                        successCallback: (data) {
                      // _accessKeyIdController.text = data["accessKeyId"];
                      // _accessKeySecretController.text = data["accessKeySecret"];
                      // _securityTokenController.text = data["securityToken"];
                      // var map = {
                      //   DataSourceRelated.VID_KEY: _vidController.text,
                      //   DataSourceRelated.ACCESSKEYID_KEY:
                      //       _accessKeyIdController.text,
                      //   DataSourceRelated.ACCESSKEYSECRET_KEY:
                      //       _accessKeySecretController.text,
                      //   DataSourceRelated.SECURITYTOKEN_KEY:
                      //       _securityTokenController.text,
                      //   DataSourceRelated.REGION_KEY: _region,
                      //   DataSourceRelated.PREVIEWTIME_KEY:
                      //       _previewController.text
                      // };
                      // CommomUtils.pushPage(
                      //     context,
                      //     PlayerPage(
                      //       playMode: PlayMode.STS,
                      //       dataSourceMap: map,
                      //     ));
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
        itemCount: _data.length,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          return Text(_data[index]);
        },
      ),
    );
  }
}
