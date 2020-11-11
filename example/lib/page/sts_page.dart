import 'package:flutter/material.dart';
import 'package:flutter_aliplayer_example/config.dart';
import 'package:flutter_aliplayer_example/util/network_utils.dart';
import 'package:flutter_aliplayer_example/widget/aliyun_regin_dropdown.dart';

class StsPage extends StatefulWidget {
  @override
  _StsHomePageState createState() => _StsHomePageState();
}

class _StsHomePageState extends State<StsPage> {
  NetWorkUtils _netWorkUtils;
  TextEditingController _vidController = TextEditingController();
  TextEditingController _accessKeyIdController = TextEditingController();
  TextEditingController _accessKeySecretController = TextEditingController();
  TextEditingController _previewController = TextEditingController();
  TextEditingController _securityTokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //NetWorkUtils
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
                onRegionChanged: (region) => {
                  print("region = $region"),
                },
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
                    _netWorkUtils.getHttp(HttpConstant.GET_STS);
                  },
                ),
                Expanded(
                  child: SizedBox(),
                ),
                RaisedButton(
                  child: Text("清除"),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
