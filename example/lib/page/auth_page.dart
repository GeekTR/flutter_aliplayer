import 'package:flutter/material.dart';
import 'package:flutter_aliplayer_example/config.dart';
import 'package:flutter_aliplayer_example/page/player_page.dart';
import 'package:flutter_aliplayer_example/util/common_utils.dart';
import 'package:flutter_aliplayer_example/util/network_utils.dart';
import 'package:flutter_aliplayer_example/widget/aliyun_regin_dropdown.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController _vidController = TextEditingController.fromValue(
      TextEditingValue(text: DataSourceRelated.DEFAULT_VID));
  TextEditingController _previewController = TextEditingController();
  TextEditingController _playAuthController = TextEditingController();
  String _region = DataSourceRelated.DEFAULT_REGION;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AUTH 播放"),
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: false,
      body: Padding(
        padding:
            const EdgeInsets.only(left: 15.0, top: 5.0, right: 15.0, bottom: 0),
        child: Column(
          children: [
            //Region
            Container(
              width: double.infinity,
              child: ReginDropDownButton(
                currentHint: DataSourceRelated.DEFAULT_REGION,
                onRegionChanged: (region) => _region = region,
              ),
            ),
            //vid
            TextField(
              controller: _vidController,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: "vid",
              ),
            ),
            //试看时间(s)
            TextField(
              controller: _previewController,
              maxLines: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "试看时间(s)",
              ),
            ),
            //PlayAuth
            TextField(
              controller: _playAuthController,
              decoration: InputDecoration(
                labelText: "PlayAuth",
              ),
            ),

            SizedBox(
              height: 30.0,
            ),

            Row(
              children: [
                RaisedButton(
                  child: Text("AUTH播放"),
                  onPressed: () {
                    var params = {"videoId": _vidController.text};
                    NetWorkUtils.instance.getHttp(HttpConstant.GET_AUTH, params: params,
                        successCallback: (data) {
                      _playAuthController.text = data["playAuth"];
                      var map = {
                        DataSourceRelated.VID_KEY: _vidController.text,
                        DataSourceRelated.REGION_KEY: _region,
                        DataSourceRelated.PLAYAUTH_KEY:
                            _playAuthController.text,
                        DataSourceRelated.PREVIEWTIME_KEY:
                            _previewController.text
                      };
                      CommomUtils.pushPage(
                          context,
                          PlayerPage(
                            playMode: PlayMode.AUTH,
                            dataSourceMap: map,
                          ));
                    }, errorCallback: (error) {});
                  },
                ),
                Expanded(
                  child: SizedBox(),
                ),
                RaisedButton(
                  child: Text("清除"),
                  onPressed: () {
                    _vidController.clear();
                    _previewController.clear();
                    _playAuthController.clear();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
