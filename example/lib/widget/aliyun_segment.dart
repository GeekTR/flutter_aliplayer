import 'package:flutter/material.dart';

typedef OnSelectAtIdx = void Function(int value);

class AliyunSegment extends StatefulWidget {

  final List<String> titles;
  final int selIdx;
  final OnSelectAtIdx onSelectAtIdx;

  const AliyunSegment({Key key, this.titles,this.selIdx=0,this.onSelectAtIdx}) : super(key: key); 
  @override
  _AliyunSegmentState createState() => _AliyunSegmentState();
}

class _AliyunSegmentState extends State<AliyunSegment> {

  int _selIdx;

  @override
  void initState() {
    super.initState();
    _selIdx = widget.selIdx;
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.titles.asMap().map((i, value) => MapEntry(i, Expanded(
          child: i==_selIdx? FlatButton(
            color: Theme.of(context).accentColor,
            textColor: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(),
            onPressed: () =>_onSelIdx(i),
          child: Text(value)):
          OutlineButton(
            color: Theme.of(context).accentColor,
            textColor: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(),
            onPressed: () =>_onSelIdx(i),
          child: Text(value))
        )
      )).values.toList()
      );
  }

  _onSelIdx(int idx){
    if(widget.onSelectAtIdx!=null){
      widget.onSelectAtIdx(idx);
      setState(() {
        _selIdx = idx;
      });
    }
  }

}