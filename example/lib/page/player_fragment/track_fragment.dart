import 'package:flutter/material.dart';
import 'package:flutter_aliplayer/flutter_aliplayer.dart';
import 'package:flutter_aliplayer_example/model/downloader_model.dart';

class TrackUIModel {
  bool isOpen;
  var selValue;
  String title;
  List<AVPTrackInfo> children;
  TrackUIModel({this.selValue, this.isOpen, this.title, this.children});
}

class TrackFragment extends StatefulWidget {
  final FlutterAliplayer fAliplayer;
  final bool isTrackReady;
  TrackFragment(this.fAliplayer,{this.isTrackReady});
  @override
  _TrackFragmentState createState() => _TrackFragmentState();
}

class _TrackFragmentState extends State<TrackFragment> {
  List<TrackUIModel> _list;

  @override
  void initState() {
    super.initState();

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
          title: '---- VIDEO ----',
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
                  .map((AVPTrackInfo e) =>
                      InkWell(
                        onTap: () {
                          element.selValue = e.trackDefinition;
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Expanded(child: Center(child: Text('${e.trackDefinition}'))),
                            Container(
                                width: 80,
                                height: 33,
                                alignment: Alignment.center,
                                child: element.selValue==e.trackDefinition?Icon(
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
    // if(widget.isTrackReady){
      widget.fAliplayer.getMediaInfo().then((value) {
        AVPMediaInfo info = AVPMediaInfo.fromJson(value);
        if(info.tracks.length>0){
          info.tracks.forEach((element) {
            _list[element.trackType].children.add(element);
            // switch (element.trackType) {
            //   case FlutterAvpdef.AVPTRACK_TYPE_VIDEO: {
            //     [videoTracksArray addObject:track];
            // }
            //     break;
            // case FlutterAvpdef.AVPTRACK_TYPE_AUDIO: {
            //     [audioTracksArray addObject:track];
            // }
            //     break;
            // case FlutterAvpdef.AVPTRACK_TYPE_SUBTITLE: {
            //     [subtitleTracksArray addObject:track];
            // }
            //     break;
            // case FlutterAvpdef.AVPTRACK_TYPE_SAAS_VOD: {
            //     [vodTracksArray addObject:track];
            // }
            //     break;
            // default:
            //     break;
            // }
           });
        }
      });
    // }
  }

}
