import 'dart:io';

import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingHomePageState createState() => _SettingHomePageState();
}

class _SettingHomePageState extends State<SettingPage> {
  TextEditingController _dnsTextEditingController = TextEditingController();
  int _currentLogIndex = 5;
  bool _enableLog = true;
  bool _enableHardwareDecoder = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
            left: 5.0, top: 10.0, right: 5.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //VersionCode
            Text("版本号"),

            //硬解开关
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("硬解开关"),
                SizedBox(
                  width: 5.0,
                ),
                Switch(
                    value: _enableHardwareDecoder,
                    onChanged: (value) {
                      setState(() {
                        _enableHardwareDecoder = value;
                      });
                    }),
              ],
            ),

            //黑名单,Android显示，iOS不显示
            Text(Platform.operatingSystemVersion),
            _blackListForAndroid(),

            SizedBox(
              height: 10.0,
            ),

            //DSResolve
            _buildDNSResolve(),

            //Log
            Row(
              children: [
                Text("Log日志开关"),
                Switch(
                    value: _enableLog,
                    onChanged: (value) {
                      setState(() {
                        _enableLog = value;
                      });
                    })
              ],
            ),
            _buildLog(),
          ],
        ),
      ),
    );
  }

  //黑名单
  Widget _blackListForAndroid() {
    if (Platform.isAndroid) {
      return Row(
        children: [
          RaisedButton(
            child: Text("HEVC黑名单"),
            onPressed: () => print("h265黑名单"),
          ),
          SizedBox(
            width: 10.0,
          ),
          RaisedButton(
            child: Text("H264黑名单"),
            onPressed: () => print("h264黑名单"),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  //DNS
  Widget _buildDNSResolve() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("DNSResolve"),
        Text("输入格式:域名1:端口1,ip1;域名2:端口2,ip2;..."),
        SizedBox(
          height: 5.0,
        ),
        TextField(
          controller: _dnsTextEditingController,
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        RaisedButton(
          child: Text("设置DNS"),
          onPressed: () {
            String dns = _dnsTextEditingController.text;
            print("dns = $dns");
          },
        ),
      ],
    );
  }

  //Log
  Widget _buildLog() {
    if (_enableLog) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 35.0,
            child: RadioListTile(
                dense: true,
                title: Text("AF_LOG_LEVEL_NONE"),
                value: 0,
                groupValue: _currentLogIndex,
                onChanged: (value) {
                  setState(() {
                    _currentLogIndex = value;
                  });
                }),
          ),
          Container(
            height: 35.0,
            child: RadioListTile(
                dense: true,
                title: Text("AF_LOG_LEVEL_FATAL"),
                value: 1,
                groupValue: _currentLogIndex,
                onChanged: (value) {
                  setState(() {
                    _currentLogIndex = value;
                  });
                }),
          ),
          Container(
            height: 35.0,
            child: RadioListTile(
                dense: true,
                title: Text("AF_LOG_LEVEL_ERROR"),
                value: 2,
                groupValue: _currentLogIndex,
                onChanged: (value) {
                  setState(() {
                    _currentLogIndex = value;
                  });
                }),
          ),
          Container(
            height: 35.0,
            child: RadioListTile(
                dense: true,
                title: Text("AF_LOG_LEVEL_WARNING"),
                value: 3,
                groupValue: _currentLogIndex,
                onChanged: (value) {
                  setState(() {
                    _currentLogIndex = value;
                  });
                }),
          ),
          Container(
            height: 35.0,
            child: RadioListTile(
                dense: true,
                title: Text("AF_LOG_LEVEL_INFO"),
                value: 4,
                groupValue: _currentLogIndex,
                onChanged: (value) {
                  setState(() {
                    _currentLogIndex = value;
                  });
                }),
          ),
          Container(
            height: 35.0,
            child: RadioListTile(
                dense: true,
                title: Text("AF_LOG_LEVEL_DEBUG"),
                value: 5,
                groupValue: _currentLogIndex,
                onChanged: (value) {
                  setState(() {
                    _currentLogIndex = value;
                  });
                }),
          ),
          Container(
            height: 35.0,
            child: RadioListTile(
                dense: true,
                title: Text("AF_LOG_LEVEL_TRACE"),
                value: 6,
                groupValue: _currentLogIndex,
                onChanged: (value) {
                  setState(() {
                    _currentLogIndex = value;
                  });
                }),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
