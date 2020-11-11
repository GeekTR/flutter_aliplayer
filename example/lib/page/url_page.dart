import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aliplayer_example/common/common_utils.dart';
import 'package:flutter_aliplayer_example/page/player_page.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class UrlPage extends StatefulWidget {
  @override
  _UrlPageState createState() => _UrlPageState();
}

class _UrlPageState extends State<UrlPage> {
  TextEditingController urlSourceController = new TextEditingController();
  String _qrcode_result =
      "https://alivc-demo-vod.aliyuncs.com/6b357371ef3c45f4a06e2536fd534380/eb3f139a4b437d1e9b623ee1b671115b-ld.mp4";

  Future<void> getQrcodeState() async {
    _qrcode_result = await QRCodeReader()
               .setAutoFocusIntervalInMs(200) // default 5000
               .setForceAutoFocus(true) // default false
               .setTorchEnabled(true) // default false
               .setHandlePermissions(true) // default true
               .setExecuteAfterPermissionGranted(true) // default true
               .setFrontCamera(false) // default false
               .scan();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("URL 播放"),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.crop_free), onPressed: () => getQrcodeState())
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: urlSourceController,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: _qrcode_result,
            ),
            keyboardType: TextInputType.number,
          ),
          RaisedButton(
            child: Text("开始播放"),
            onPressed: () {
              CommomUtils.pushPage(context, PlayerPage(_qrcode_result));
            },
          )
        ],
      ),
    );
  }

}
