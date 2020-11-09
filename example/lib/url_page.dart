import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aliplayer_example/play_page.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class UrlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyUrlPage(),
    );
  }
}

class MyUrlPage extends StatefulWidget {
  @override
  _MyUrlPageState createState() => _MyUrlPageState();
}

class _MyUrlPageState extends State<MyUrlPage> {
  TextEditingController urlSourceController = new TextEditingController();
  String _qrcode_result =
      "https://alivc-demo-vod.aliyuncs.com/6b357371ef3c45f4a06e2536fd534380/eb3f139a4b437d1e9b623ee1b671115b-ld.mp4";

  Future<void> getQrcodeState() async {
    // String qrcode_path;
    // try {
    //   qrcode_path = await FlutterPluginQrcode.getQRCode;
    // } on PlatformException {
    //   qrcode_path = 'Failed to get platform version.';
    // }

    // if (!mounted) return;
    // //获取到扫描的结果进行页面更新
    // setState(() {
    //   _qrcode_result = qrcode_path;
    // });
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
              _navigator_push(context, PlayPage(_qrcode_result));
            },
          )
        ],
      ),
    );
  }

  _navigator_push(BuildContext context, Widget route) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => route));
  }
}
