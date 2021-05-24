import 'package:flutter/material.dart';
import 'package:flutter_aliplayer/flutter_aliplayer.dart';
import 'package:flutter_aliplayer/flutter_aliplayer_factory.dart';
import 'package:flutter_aliplayer_example/config.dart';
import 'package:flutter_aliplayer_example/util/formatter_utils.dart';
import 'package:flutter_aliplayer_example/widget/aliyun_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MultiplePlayerPage extends StatefulWidget {
  @override
  _MultiplePlayerPageState createState() => _MultiplePlayerPageState();
}

class _MultiplePlayerPageState extends State<MultiplePlayerPage> {
  List playerList = [];
  List viewList = [];
  List durationList = [];
  List currentDurationList = [];

  ///seek中
  bool _inSeek = false;

  @override
  void initState() {
    super.initState();

    ['0', '1', '2'].forEach((element) {
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
    durationList.add(0);
    currentDurationList.add(0);

    FlutterAliplayer player =
        FlutterAliPlayerFactory.createAliPlayer(playerId: playerId);
    playerList.add(player);

    player.setOnPrepared((playerId) {
      FlutterAliplayer currentPlayer = playerList[int.parse(playerId)];
      Fluttertoast.showToast(msg: "prepared : $playerId");
      currentPlayer
          .getPlayerName()
          .then((value) => print("getPlayerName==${value}"));

      currentPlayer.getMediaInfo().then((value) {
        //key 为 playerId，值为 视频时长
        durationList.insert(int.parse(playerId), value['duration']);
      });
      setState(() {});
    });

    player.setOnError((errorCode, errorExtra, errorMsg, playerId) {
      Fluttertoast.showToast(msg: "error : $playerId , $errorCode , $errorMsg");
    });

    player.setOnInfo((infoCode, extraValue, extraMsg, playerId) {
      if (infoCode == FlutterAvpdef.CURRENTPOSITION) {
        var duration = durationList[int.parse(playerId)];
        if (duration != 0 && extraValue <= duration) {
          currentDurationList[int.parse(playerId)] = extraValue;
        }
        if (!_inSeek) {
          setState(() {
            currentDurationList[int.parse(playerId)] = extraValue;
          });
        }
      }
    });

    if (playerId == '0') {
      await player.setUrl(DataSourceRelated.DEFAULT_URL);
    } else if (playerId == '1') {
      await player.setUrl(
          "https://alivc-demo-vod.aliyuncs.com/a3b9e7dba80b4600924754fc624238ae/737c5bac56bb4d45bdfc67659b21984b-dd187725b56b7c3b4df998570f5c967a-ld.m3u8");
    } else {
      await player.setUrl(DataSourceRelated.DEFAULT_URL);
    }
    // await player.setUrl(DataSourceRelated.DEFAULT_URL);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = width * 9 / 16;
    viewList.clear();
    playerList.forEach((player) {
      AliPlayerView aliPlayerView = AliPlayerView(
          onCreated: (int viewId) {
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
          children: playerList
              .asMap()
              .keys
              .map((idx) => Column(
                    children: [
                      _buildRenderView(width, height, idx),
                      SizedBox(
                        width: 0,
                        height: 10,
                      ),
                      _buildControllerBtn(playerList[idx]),
                      SizedBox(
                        width: 0,
                        height: 10,
                      ),
                    ],
                  ))
              .toList(),
        ),
      )),
    );
  }

  Widget _buildRenderView(var width, var height, int index) {
    //当前播放进度
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: width,
            height: height,
            child: viewList[index],
          ),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "${FormatterUtils.getTimeformatByMs(currentDurationList[index])}",
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                Expanded(
                  child: AliyunSlider(
                    value: currentDurationList[index].toDouble(),
                    max: durationList[index].toDouble() == 0
                        ? 1
                        : durationList[index].toDouble(),
                    min: 0,
                    bufferColor: Colors.white,
                    bufferValue: 100,
                    onChanged: (value) {
                      setState(() {
                        currentDurationList[index] = value.ceil();
                      });
                    },
                    onChangeStart: (value) {
                      _inSeek = true;
                      setState(() {});
                    },
                    onChangeEnd: (value) {
                      _inSeek = false;
                      setState(() {});
                      playerList[index].seekTo(
                          value.ceil(),
                          GlobalSettings.mEnableAccurateSeek
                              ? FlutterAvpdef.ACCURATE
                              : FlutterAvpdef.INACCURATE);
                    },
                  ),
                ),
                Text(
                  "${FormatterUtils.getTimeformatByMs(durationList[index])}",
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
