import 'package:flutter/material.dart';
import 'package:flutter_aliplayer/flutter_aliplayer.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TrackUIModel {
  bool isOpen;
  var selValue;
  String title;
  List<SubTrackUIModel> children;
  TrackUIModel({this.selValue, this.isOpen, this.title, this.children});
}

class TrackFragment extends StatefulWidget {
  final FlutterAliplayer fAliplayer;
  TrackFragment(Key key, this.fAliplayer) : super(key: key);
  @override
  TrackFragmentState createState() => TrackFragmentState();
}

class SubTrackUIModel {
  String title;
  var value;
  SubTrackUIModel({this.title, this.value});
}

class TrackFragmentState extends State<TrackFragment> {
  List<TrackUIModel> _list;

  Map extSubTitleMap = {
    "cn":
        "https://alivc-player.oss-cn-shanghai.aliyuncs.com/6137c3dedd00a00547a1e8e5e3355369.vtt",
    "en":
        "https://alivc-player.oss-cn-shanghai.aliyuncs.com/6b4949a8c3950f8aa76f1fed6730e525.vtt"
  };

  @override
  void initState() {
    super.initState();

    loadData();

    widget.fAliplayer.setOnSubtitleExtAdded((trackIndex, url) {
      String curKey = '';
      extSubTitleMap.forEach((key, value) {
        if (url == value) {
          curKey = key;
        }
      });
      if (trackIndex < 0) {
        Fluttertoast.showToast(msg: '外挂字幕${curKey}添加失败');
      } else {
        _list[4].children.removeWhere((element) => element.title == curKey);
        _list[4]
            .children
            .add(SubTrackUIModel(title: curKey, value: trackIndex));
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
          child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.symmetric(vertical: 1),
        expansionCallback: (index, bool) {
          TrackUIModel model = _list[index];
          model.isOpen = !model.isOpen;
          setState(() {});
        },
        children: _list.map((TrackUIModel element) {
          return ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (context, isExpanded) {
              return Center(child: Text('${element.title}'));
            },
            body: Column(
              children: element.children
                  .map((SubTrackUIModel e) => InkWell(
                        onTap: () {
                          if (element.title == '---- 外挂字幕 ----') {
                            widget.fAliplayer
                                .selectExtSubtitle(element.selValue, false)
                                .then((value) {
                              bool isSelected = element.selValue == e.value;
                              if (isSelected) {
                                element.selValue = -1;
                              } else {
                                element.selValue = e.value;
                                widget.fAliplayer
                                    .selectExtSubtitle(element.selValue, true);
                              }
                            });
                          } else {
                            element.selValue = e.value;
                            widget.fAliplayer
                                .selectTrack(element.selValue, accurate: 0);
                          }
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Expanded(child: Center(child: Text('${e.title}'))),
                            Container(
                                width: 80,
                                height: 33,
                                alignment: Alignment.center,
                                child: element.selValue == e.value
                                    ? Icon(
                                        Icons.check,
                                        color: Theme.of(context).accentColor,
                                        size: 18,
                                      )
                                    : null)
                          ],
                        ),
                      ))
                  .toList(),
            ),
            isExpanded: element.isOpen,
          );
        }).toList(),
      )),
    );
  }

  prepared() {
    if (_list != null && _list.length > 0) {
      widget.fAliplayer.selectExtSubtitle(_list[4].selValue, false);
      _list[4].selValue = -1;
    }
  }

  _initData() {
    _list = [
      TrackUIModel(
          isOpen: false, title: '---- VIDEO ----', selValue: -1, children: []),
      TrackUIModel(
          isOpen: false, title: '---- AUDIO ----', selValue: -1, children: []),
      TrackUIModel(
          isOpen: false,
          title: '---- SUBTITLE ----',
          selValue: -1,
          children: []),
      TrackUIModel(
          isOpen: false, title: '---- VOD ----', selValue: -1, children: []),
      TrackUIModel(
          isOpen: false, title: '---- 外挂字幕 ----', selValue: -1, children: []),
    ];
  }

  onTrackChanged(AVPTrackInfo info) {
    //自动码率切换成功
    if (info.trackType == 0) {
      _list[0].children[0].title = "自动码率(${info.trackDefinition})";
      setState(() {});
    }
  }

  loadData() {
    _initData();
    //添加外挂字幕
    extSubTitleMap.forEach((key, value) {
      widget.fAliplayer.addExtSubtitle(value);
    });
    widget.fAliplayer.getMediaInfo().then((value) {
      AVPMediaInfo info = AVPMediaInfo.fromJson(value);
      if (info.tracks.length > 0) {
        bool _hasVodDefinition = false;
        info.tracks.forEach((element) {
          SubTrackUIModel model = SubTrackUIModel();
          model.value = element.trackIndex;
          model.title = element.trackDefinition;
          if (element.trackType == 0) {
            _hasVodDefinition = true;
          }
          _list[element.trackType].children.add(model);
        });

        //获取当前选中状态值
        for (int i = 0; i < 4; i++) {
          widget.fAliplayer.getCurrentTrack(i).then((value) {
            if (value != null) {
              AVPTrackInfo track = AVPTrackInfo.fromJson(value);
              _list[i].selValue = track.trackIndex;
              //码率
              if (_hasVodDefinition && track.trackType == 0) {
                _hasVodDefinition = false;
                SubTrackUIModel model = SubTrackUIModel();
                model.title = "自动码率(${track.trackDefinition})";
                model.value = -1;
                _list[0].children.insert(0, model);
              }
            }
          });
        }
      }
    });
  }
}
