import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CacheConfigFramePage extends StatefulWidget {
  @override
  _CacheConfigFramePageState createState() => _CacheConfigFramePageState();
}

class _CacheConfigFramePageState extends State<CacheConfigFramePage> {
  bool mEnableCacheConfig = false;

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
                  enabled: mEnableCacheConfig,
                  decoration: InputDecoration(
                    labelText: "最大时长(s)",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  maxLines: 1,
                  enabled: mEnableCacheConfig,
                  decoration: InputDecoration(
                    labelText: "最大Size(MB)",
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  maxLines: 1,
                  enabled: mEnableCacheConfig,
                  decoration: InputDecoration(
                    labelText: "保存路径",
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
                          value: mEnableCacheConfig,
                          onChanged: (value) {
                            setState(() {
                              mEnableCacheConfig = value;
                            });
                          },
                        ),
                        Text("是否开启缓存配置"),
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
