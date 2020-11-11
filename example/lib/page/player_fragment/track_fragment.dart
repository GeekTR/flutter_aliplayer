import 'package:flutter/material.dart';

class TrackUIModel {
  bool isOpen;
  var selValue;
  String title;
  List<SubTrackUIModel> children;
  TrackUIModel({this.selValue, this.isOpen, this.title, this.children});
}

class SubTrackUIModel {
  String title;
  var value;
  SubTrackUIModel({this.title, this.value});
}

class TrackFragment extends StatefulWidget {
  @override
  _TrackFragmentState createState() => _TrackFragmentState();
}

class _TrackFragmentState extends State<TrackFragment> {
  List<TrackUIModel> _list;

  @override
  void initState() {
    super.initState();

    _list = [
      TrackUIModel(
          isOpen: false,
          title: '---- VIDEO ----',
          selValue: 1000,
          children: [
            SubTrackUIModel(
              title: '1000',
              value: 1000,
            ),
            SubTrackUIModel(
              title: '2000',
              value: 2000,
            ),
            SubTrackUIModel(
              title: '3000',
              value: 3000,
            ),
          ]),
      TrackUIModel(
          isOpen: false,
          title: '---- VIDEO ----',
          selValue: 1000,
          children: [
            SubTrackUIModel(
              title: '1000',
              value: 1000,
            ),
            SubTrackUIModel(
              title: '2000',
              value: 2000,
            ),
            SubTrackUIModel(
              title: '3000',
              value: 3000,
            ),
          ]),
      TrackUIModel(
          isOpen: false,
          title: '---- VIDEO ----',
          selValue: 1000,
          children: [
            SubTrackUIModel(
              title: '1000',
              value: 1000,
            ),
            SubTrackUIModel(
              title: '2000',
              value: 2000,
            ),
            SubTrackUIModel(
              title: '3000',
              value: 3000,
            ),
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
                          element.selValue = e.value;
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
}
