import 'package:flutter/material.dart';
import 'package:flutter_aliplayer/flutter_aliplayer.dart';
import 'package:flutter_aliplayer_example/widget/aliyun_slider.dart';

class MultiplePlayerPage extends StatefulWidget {
  @override
  _MultiplePlayerPageState createState() => _MultiplePlayerPageState();
}

class _MultiplePlayerPageState extends State<MultiplePlayerPage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var height = width * 9 / 16;
    print(
        "width = $width ,,,, height = $height ,,, screenHeight = $screenHeight");
    AliPlayerView aliPlayerView = AliPlayerView(
        onCreated: onViewPlayerCreated,
        x: 0,
        y: 0,
        width: width,
        height: height);

    AliPlayerView aliPlayerView2 = AliPlayerView(
        onCreated: onViewPlayerCreated2,
        x: 0,
        y: 0,
        width: width,
        height: height);

    AliPlayerView aliPlayerView3 = AliPlayerView(
        onCreated: onViewPlayerCreated2,
        x: 0,
        y: 0,
        width: width,
        height: height);

    print(
        "abc : ${aliPlayerView.hashCode} ,,, ${aliPlayerView2.hashCode} ,,, ${aliPlayerView3.hashCode}");

    return Scaffold(
      appBar: AppBar(
        title: Text("多实例播放"),
        centerTitle: true,
      ),
      body: Scrollbar(
          child: SingleChildScrollView(
        child: Column(
          children: [
            //Player 1
            _buildRenderView(width, height, aliPlayerView),
            SizedBox(
              width: 0,
              height: 10,
            ),
            _buildControllerBtn(),

            //Player 2
            _buildRenderView(width, height, aliPlayerView2),
            SizedBox(
              width: 0,
              height: 10,
            ),
            _buildControllerBtn(),

            //Player 3
            _buildRenderView(width, height, aliPlayerView3),
            SizedBox(
              width: 0,
              height: 10,
            ),
            _buildControllerBtn(),
          ],
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

  Widget _buildControllerBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          child: Text(
            "准备",
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
          onTap: () {
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
          },
        ),
        InkWell(
          child: Text(
            "暂停",
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
          onTap: () {
            print("暂停");
          },
        ),
        InkWell(
          child: Text(
            "停止",
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
          onTap: () {
            print("停止");
          },
        ),
      ],
    );
  }
}

void onViewPlayerCreated() async {}
void onViewPlayerCreated2() async {}
void onViewPlayerCreated3() async {}
