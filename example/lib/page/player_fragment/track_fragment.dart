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
  final bool isTrackReady;
  TrackFragment(this.fAliplayer,{this.isTrackReady});
  @override
  _TrackFragmentState createState() => _TrackFragmentState();
}

class SubTrackUIModel {
  String title;
  var value;
  SubTrackUIModel({this.title, this.value});
}

class _TrackFragmentState extends State<TrackFragment> {
  List<TrackUIModel> _list;

  Map extSubTitleMap = {
          "cn": "https://alivc-player.oss-cn-shanghai.aliyuncs.com/cnjap.vtt",
          "en": "https://alivc-player.oss-cn-shanghai.aliyuncs.com/6137c3dedd00a00547a1e8e5e3355369.vtt",
          "ja": "https://alivc-player.oss-cn-shanghai.aliyuncs.com/6b4949a8c3950f8aa76f1fed6730e525.vtt"
        };

  @override
  void initState() {
    super.initState();

    widget.fAliplayer.setOnSubtitleExtAdded((trackIndex, url) {
        String curKey = '';
        extSubTitleMap.forEach((key, value) {
          if(url==value){
            curKey = key;
          }
        });
        if(trackIndex<0){
            Fluttertoast.showToast(msg: '外挂字幕${curKey}添加失败');
        }else{
          _list[4].children.add(SubTrackUIModel(title: curKey,value: trackIndex));
            Fluttertoast.showToast(msg: '外挂字幕${curKey}添加成功');
            setState(() {
              
            });
        }
     });

    _loadData();

    _list = [
      TrackUIModel(
          isOpen: false,
          title: '---- VIDEO ----',
          selValue: 1000,
          children: [
            
          ]),
      TrackUIModel(
          isOpen: false,
          title: '---- VIDEO ----',
          selValue: 1000,
          children: [
            
          ]),
      TrackUIModel(
          isOpen: false,
          title: '---- SUBTITLE ----',
          selValue: 1000,
          children: [
            
          ]),
      TrackUIModel(
          isOpen: false,
          title: '---- VOD ----',
          selValue: 1000,
          children: [
            
          ]),
          TrackUIModel(
          isOpen: false,
          title: '---- 外挂字幕 ----',
          selValue: 1000,
          children: [
            
          ]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Scrollbar(
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
                  .map((SubTrackUIModel e) =>
                      InkWell(
                        onTap: () {
                          if(element.title=='---- 外挂字幕 ----'){
                            bool isSelected = element.selValue == e.value;
                            element.selValue = e.value;
                            widget.fAliplayer.selectExtSubtitle(element.selValue, !isSelected);
                          }else{
                              element.selValue = e.value;
                              widget.fAliplayer.selectTrack(element.selValue,accurate:0);
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
                                child: element.selValue==e.value?Icon(
                                  Icons.check,
                                  color: Theme.of(context).accentColor,
                                  size: 18,
                                ):null)
                          ],
                        ),
                      ))
                  .toList(),
            ),
            isExpanded: element.isOpen,
          );
        }).toList(),
      )),
    ));
  }

  _loadData(){

    //添加外挂字幕
    extSubTitleMap.forEach((key, value) {
      widget.fAliplayer.addExtSubtitle(value);
    });

    // if(widget.isTrackReady){
      widget.fAliplayer.getMediaInfo().then((value) {
        AVPMediaInfo info = AVPMediaInfo.fromJson(value);
        if(info.tracks.length>0){
          info.tracks.forEach((element) {
             SubTrackUIModel model = SubTrackUIModel();
             model.value = element.trackIndex;
             model.title = element.trackDefinition;
             _list[element.trackType].children.add(model);
           });

           //获取当前选中状态值
           for(int i=0;i<4;i++){
             widget.fAliplayer.getCurrentTrack(i).then((value){
               if(value!=null){
                AVPTrackInfo track = AVPTrackInfo.fromJson(value);
                _list[i].selValue = track.trackIndex;
               }
             });
           }
        }
      });
    // }
  }

}
