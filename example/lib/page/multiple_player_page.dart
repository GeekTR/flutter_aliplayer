import 'package:flutter/material.dart';
import 'package:flutter_aliplayer/flutter_aliplayer.dart';
import 'package:flutter_aliplayer/flutter_aliplayer_factory.dart';
import 'package:flutter_aliplayer_example/config.dart';
import 'package:flutter_aliplayer_example/widget/aliyun_slider.dart';

class MultiplePlayerPage extends StatefulWidget {
  @override
  _MultiplePlayerPageState createState() => _MultiplePlayerPageState();
}

class _MultiplePlayerPageState extends State<MultiplePlayerPage> {


  List playerList = [];
  List viewList = [];

  @override
  void initState() {
    super.initState();

    ['0','1','2'].forEach((element) {
      initData(element);
    });
  }

   @override
  void dispose() {
    super.dispose();
    playerList.forEach((element) {
      element.stop();
      element.destroy();
    });
  }

  Future<void> initData(playerId) async {
    FlutterAliplayer player = FlutterAliPlayerFactory.createAliPlayer(playerId: playerId);
    playerList.add(player);
    await player.setUrl(DataSourceRelated.DEFAULT_URL);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var height = width * 9 / 16;
    print(
        "width = $width ,,,, height = $height ,,, screenHeight = $screenHeight");
        viewList.clear();
        playerList.forEach((player) {
        AliPlayerView aliPlayerView = AliPlayerView(
        onCreated: (int viewId){
          player.setPlayerView(viewId);
        },
        x: 0,
        y: 0,
        width: width,
        height: height);
        viewList.add(aliPlayerView);
    });
  

    return Scaffold(
      appBar: AppBar(
        title: Text("多实例播放"),
        centerTitle: true,
      ),
      body: Scrollbar(
          child: SingleChildScrollView(
        child: Column(
          children: playerList.asMap().keys.map((idx) => Column(
            children: [
              _buildRenderView(width, height, viewList[idx]),
            SizedBox(
              width: 0,
              height: 10,
            ),
            _buildControllerBtn(playerList[idx]),
            ],
          )).toList(),
        ),
      )),
    );
  }

  Widget _buildRenderView(var width, var height, Widget aliPlayerView) {
    //当前播放进度
    int _currentPosition = 0;
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: width,
            height: height,
            child: aliPlayerView,
          ),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "currentPosition",
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                Expanded(
                  child: AliyunSlider(
                    value: _currentPosition.toDouble(),
                    max: 100,
                    min: 0,
                    bufferColor: Colors.white,
                    bufferValue: 100,
                    onChanged: (value) {
                      setState(() {
                        _currentPosition = value.ceil();
                      });
                    },
                    onChangeStart: (value) {},
                    onChangeEnd: (value) {},
                  ),
                ),
                Text(
                  "Duration",
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                SizedBox(height: 0, width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControllerBtn(player) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          child: Text(
            "准备",
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
          onTap: () {
            player.prepare();
            print("准备");
          },
        ),
        InkWell(
          child: Text(
            "播放",
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
          onTap: () {
            print("播放");
            player.play();
          },
        ),
        InkWell(
          child: Text(
            "暂停",
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
          onTap: () {
            print("暂停");
            player.pause();
          },
        ),
        InkWell(
          child: Text(
            "停止",
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
          onTap: () {
            print("停止");
            player.stop();
          },
        ),
      ],
    );
  }

}
