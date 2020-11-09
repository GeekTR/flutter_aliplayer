import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

class PlayConfigFramePage extends StatefulWidget {
  @override
  _PlayConfigFramePageState createState() => _PlayConfigFramePageState();
}

class _PlayConfigFramePageState extends State<PlayConfigFramePage> {
  bool mShowFrameWhenStop = true;
  bool mEnableSEI = true;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
                top: 10.0, left: 20.0, bottom: 10.0, right: 20.0),
            child: Column(
              children: [
                TextField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: "起播缓冲区",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: "卡顿恢复",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: "最大缓冲区",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: "直播最大延时",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: "网络超时",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: "网络重试次数",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: "probe大小",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: "referer",
                  ),
                ),
                TextField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: "httpProxy",
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        CupertinoSwitch(
                          value: mShowFrameWhenStop,
                          onChanged: (value) {
                            setState(() {
                              mShowFrameWhenStop = value;
                            });
                          },
                        ),
                        Text("停止显示最后帧"),
                      ],
                    ),
                    Column(
                      children: [
                        CupertinoSwitch(
                          value: mEnableSEI,
                          onChanged: (value) {
                            setState(() {
                              mEnableSEI = value;
                            });
                          },
                        ),
                        Text("开启SEI"),
                      ],
                    ),
                    InkWell(
                      child: Text(
                        "应用配置",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
