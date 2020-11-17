import 'package:flutter/material.dart';
import 'package:flutter_aliplayer_example/util/database_utils.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  List<String> _dataList = List<String>();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i <= 10; i++) {
      _dataList.add("$i");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Download"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: _dataList.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildListViewItem();
          }),
    );
  }

  Widget _buildListViewItem() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                "https://alivc-demo-vod.aliyuncs.com/6609a2f737cb43e1a79ec2bc6aee781b/snapshots/1231cd3803654152b529207a2081757b-00005.jpg",
                width: 85.0,
                height: 85.0,
                fit: BoxFit.cover,
              ),
              Text(
                "准备完成",
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "标题",
                  maxLines: 1,
                ),
                Text(
                  "大小M",
                  maxLines: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RaisedButton(
                        child: Text("开始"),
                        onPressed: () {
                          // DBUtils.openDB("download.db");
                          print("开始");
                        },
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        child: Text("停止"),
                        onPressed: () => print("停止"),
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        child: Text("播放"),
                        onPressed: () => print("播放"),
                      ),
                    ),
                    Expanded(
                      child: RaisedButton(
                        child: Text("删除"),
                        onPressed: () => print("删除"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
