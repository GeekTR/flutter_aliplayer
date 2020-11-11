import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_aliplayer_example/widget/aliyun_segment.dart';

class OptionsFragment extends StatefulWidget {
  @override
  _OptionsFragmentState createState() => _OptionsFragmentState();
}

class _OptionsFragmentState extends State<OptionsFragment> {
  bool mAutoPlay = false;
  bool mMute = false;
  bool mLoop = false;
  bool mAccurateSeek = false;
  bool mEnablePlayBack = false;
  int mScaleGroupValue = 1;
  int mMirrorGroupValue = 1;
  int mRotateGroupValue = 1;
  int mSpeedGroupValue = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                _buildSwitch(),
                _buildVolume(),
                _buildScale(),
                _buildMirror(),
                _buildRotate(),
                _buildSpeed(),
                _buildBgColor(),
                _buildPlayBack(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// switch for : autoplay、mute、loop...
  Row _buildSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            CupertinoSwitch(
              value: mAutoPlay,
              onChanged: (value) {
                setState(() {
                  mAutoPlay = value;
                });
              },
            ),
            Text("自动播放"),
          ],
        ),
        Column(
          children: [
            CupertinoSwitch(
              value: mMute,
              onChanged: (value) {
                setState(() {
                  mMute = value;
                });
              },
            ),
            Text("静音"),
          ],
        ),
        Column(
          children: [
            CupertinoSwitch(
              value: mLoop,
              onChanged: (value) {
                setState(() {
                  mLoop = value;
                });
              },
            ),
            Text("循环"),
          ],
        ),
        Column(
          children: [
            CupertinoSwitch(
              value: true,
            ),
            Text("硬解"),
          ],
        ),
        Column(
          children: [
            CupertinoSwitch(
              value: mAccurateSeek,
              onChanged: (value) {
                setState(() {
                  mAccurateSeek = value;
                });
              },
            ),
            Text("精准seek"),
          ],
        ),
      ],
    );
  }

  /// 音量
  Row _buildVolume() {
    return Row(
      children: [
        SizedBox(
          width: 10.0,
        ),
        Text("音量"),
        Expanded(
          child: Slider(
            value: 50,
            max: 100,
          ),
        ),
      ],
    );
  }

  /// 缩放模式
  Row _buildScale() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('缩放模式'),
        Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal:8),
                    child: AliyunSegment(titles: ['比例填充','比例全屏','拉伸全屏'],selIdx: 0,onSelectAtIdx: (value) {
                      mScaleGroupValue = value;
                    },),
                  ),
        ),

      ],
    );
  }

  /// 镜像模式
  Row _buildMirror() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('镜像模式'),
         Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal:8),
                    child: AliyunSegment(titles: ['无镜像','水平镜像','垂直镜像'],selIdx: 0,onSelectAtIdx: (value) {
                      mMirrorGroupValue = value;
                    },),
                  ),
        ),
      ],
    );
  }

  /// 旋转模式
  Container _buildRotate() {
    double width = MediaQuery.of(context).size.width;
    print("abc : 屏幕宽度 width = $width");
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('旋转模式'),
          Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal:8),
                    child: AliyunSegment(titles: ['0°','90°','180°',"270°"],selIdx: 0,onSelectAtIdx: (value) {
                      mRotateGroupValue = value;
                    },),
                  ),
        ),
        ]
      ),  
    );
  }

  /// 倍速播放
  Row _buildSpeed() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('倍速播放'),
        Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal:8),
                    child: AliyunSegment(titles: ['正常','0.5倍速','1.5倍速',"2.0倍速"],selIdx: 0,onSelectAtIdx: (value) {
                      mSpeedGroupValue = value;
                    },),
                  ),
        ),
      ]
    );
        
  }

  /// 背景色
  Row _buildBgColor() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 10.0,
        ),
        Text("背景色"),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: TextField(
            maxLines: 1,
            maxLength: 20,
          ),
        ),
        SizedBox(
          width: 30.0,
        ),
        InkWell(
          child: Text(
            "确定",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
      ],
    );
  }

  /// 后台播放
  Row _buildPlayBack() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            CupertinoSwitch(
              value: mEnablePlayBack,
              onChanged: (value) {
                setState(() {
                  mEnablePlayBack = value;
                });
              },
            ),
            Text("后台播放"),
          ],
        ),
        InkWell(
          child: Text(
            "媒体信息",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
