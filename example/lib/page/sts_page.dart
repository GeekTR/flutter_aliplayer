import 'package:flutter/material.dart';
import 'package:flutter_aliplayer_example/config.dart';
import 'package:flutter_aliplayer_example/page/player_page.dart';
import 'package:flutter_aliplayer_example/util/common_utils.dart';
import 'package:flutter_aliplayer_example/util/network_utils.dart';
import 'package:flutter_aliplayer_example/widget/aliyun_regin_dropdown.dart';

class StsPage extends StatefulWidget {
  @override
  _StsHomePageState createState() => _StsHomePageState();
}

class _StsHomePageState extends State<StsPage> {
  NetWorkUtils _netWorkUtils;
  TextEditingController _vidController =
      TextEditingController.fromValue(TextEditingValue(
    text: DataSourceRelated.DEFAULT_VID,
  ));
  TextEditingController _accessKeyIdController = TextEditingController();
  TextEditingController _accessKeySecretController = TextEditingController();
  TextEditingController _previewController = TextEditingController();
  TextEditingController _securityTokenController = TextEditingController();
  String _region = DataSourceRelated.DEFAULT_REGION;

  @override
  void initState() {
    super.initState();
    _netWorkUtils = NetWorkUtils.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("STS 播放"),
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
            //AccessKeyId
            TextField(
              controller: _accessKeyIdController,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: "AccessKeyId",
              ),
            ),
            //AccessKeySecret
            TextField(
              controller: _accessKeySecretController,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: "AccessKeySecret",
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
            //SecurityToken
            TextField(
              controller: _securityTokenController,
              decoration: InputDecoration(
                labelText: "SecurityToken",
              ),
            ),

            SizedBox(
              height: 30.0,
            ),

            Row(
              children: [
                RaisedButton(
                  child: Text("STS播放"),
                  onPressed: () {
                    _netWorkUtils.getHttp(HttpConstant.GET_STS,
                        successCallback: (data) {
                      _accessKeyIdController.text = data["accessKeyId"];
                      _accessKeySecretController.text = data["accessKeySecret"];
                      _securityTokenController.text = data["securityToken"];
                      var map = {
                        DataSourceRelated.VID_KEY: _vidController.text,
                        DataSourceRelated.ACCESSKEYID_KEY:
                            _accessKeyIdController.text,
                        DataSourceRelated.ACCESSKEYSECRET_KEY:
                            _accessKeySecretController.text,
                        DataSourceRelated.SECURITYTOKEN_KEY:
                            _securityTokenController.text,
                        DataSourceRelated.REGION_KEY: _region,
                        DataSourceRelated.PREVIEWTIME_KEY:
                            _previewController.text
                      };
                      CommomUtils.pushPage(
                          context,
                          PlayerPage(
                            playMode: PlayMode.STS,
                            dataSourceMap: map,
                          ));
                    }, errorCallback: (error) {
                      print("error");
                    });
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
                    _accessKeyIdController.clear();
                    _accessKeySecretController.clear();
                    _securityTokenController.clear();
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
