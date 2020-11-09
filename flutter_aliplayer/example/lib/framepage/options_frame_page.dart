import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_aliplayer_example/widget/custom_radio.dart';

class OptionsFramePage extends StatefulWidget {
  @override
  _OptionsFramePageState createState() => _OptionsFramePageState();
}

class _OptionsFramePageState extends State<OptionsFramePage> {
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

  /**
   * switch for : autoplay、mute、loop...
   */
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

  /**
   * 音量
   */
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

  /**
   * 缩放模式
   */
  Row _buildScale() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('缩放模式'),
        Row(
          children: [
            CustomRadioButton(
              title: "比例填充",
              value: 1,
              groupValue: mScaleGroupValue,
              onChecked: (value) {
                setState(() {
                  mScaleGroupValue = value;
                });
              },
            ),
            CustomRadioButton(
              title: "比例全屏",
              value: 2,
              groupValue: mScaleGroupValue,
              onChecked: (value) {
                setState(() {
                  mScaleGroupValue = value;
                });
              },
            ),
            CustomRadioButton(
              title: "拉伸全屏",
              value: 3,
              groupValue: mScaleGroupValue,
              onChecked: (value) {
                setState(() {
                  mScaleGroupValue = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  /**
   * 镜像模式
   */
  Row _buildMirror() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('镜像模式'),
        Row(
          children: [
            CustomRadioButton(
              title: "无镜像",
              value: 1,
              groupValue: mMirrorGroupValue,
              onChecked: (value) {
                setState(() {
                  mMirrorGroupValue = value;
                });
              },
            ),
            CustomRadioButton(
              title: "水平镜像",
              value: 2,
              groupValue: mMirrorGroupValue,
              onChecked: (value) {
                setState(() {
                  mMirrorGroupValue = value;
                });
              },
            ),
            CustomRadioButton(
              title: "垂直镜像",
              value: 3,
              groupValue: mMirrorGroupValue,
              onChecked: (value) {
                setState(() {
                  mMirrorGroupValue = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  /**
   * 旋转模式
   */
  Container _buildRotate() {
    double width = MediaQuery.of(context).size.width;
    print("abc : 屏幕宽度 width = $width");
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('旋转模式'),
          SizedBox(
            width: 20.0,
          ),
          Row(
            children: [
              CustomRadioButton(
                title: "0°",
                value: 1,
                groupValue: mRotateGroupValue,
                onChecked: (value) {
                  setState(() {
                    mRotateGroupValue = value;
                  });
                },
              ),
              CustomRadioButton(
                title: "90°",
                value: 2,
                groupValue: mRotateGroupValue,
                onChecked: (value) {
                  setState(() {
                    mRotateGroupValue = value;
                  });
                },
              ),
              CustomRadioButton(
                title: "180°",
                value: 3,
                groupValue: mRotateGroupValue,
                onChecked: (value) {
                  setState(() {
                    mRotateGroupValue = value;
                  });
                },
              ),
              CustomRadioButton(
                title: "270°",
                value: 4,
                groupValue: mRotateGroupValue,
                onChecked: (value) {
                  setState(() {
                    mRotateGroupValue = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /**
   * 倍速播放
   */
  Row _buildSpeed() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('倍速播放'),
        Row(
          children: [
            CustomRadioButton(
              title: "正常",
              value: 1,
              groupValue: mSpeedGroupValue,
              onChecked: (value) {
                setState(() {
                  mSpeedGroupValue = value;
                });
              },
            ),
            CustomRadioButton(
              title: "0.5倍速",
              value: 2,
              groupValue: mSpeedGroupValue,
              onChecked: (value) {
                setState(() {
                  mSpeedGroupValue = value;
                });
              },
            ),
            CustomRadioButton(
              title: "1.5倍速",
              value: 3,
              groupValue: mSpeedGroupValue,
              onChecked: (value) {
                setState(() {
                  mSpeedGroupValue = value;
                });
              },
            ),
            CustomRadioButton(
              title: "2.0倍速",
              value: 4,
              groupValue: mSpeedGroupValue,
              onChecked: (value) {
                setState(() {
                  mSpeedGroupValue = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  /**
   * 背景色
   */
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

  /**
   * 后台播放
   */
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
