import 'package:flutter/material.dart';

typedef OnRegionChanged = void Function(String region);

class ReginDropDownButton extends StatefulWidget {
  OnRegionChanged onRegionChanged;

  ReginDropDownButton({Key key, this.onRegionChanged}) : super(key: key);

  @override
  _ReginDropDownButtonState createState() => _ReginDropDownButtonState();
}

class _ReginDropDownButtonState extends State<ReginDropDownButton> {
  String _currentHint = "cn-shanghai";

  List<DropdownMenuItem> getItemList() {
    List<DropdownMenuItem> items = List();
    DropdownMenuItem item1 = DropdownMenuItem(
      child: Text("cn-shanghai"),
      value: "cn-shanghai",
    );
    DropdownMenuItem item2 = DropdownMenuItem(
      child: Text("ap-southeast-1"),
      value: "ap-southeast-1",
    );
    DropdownMenuItem item3 = DropdownMenuItem(
      child: Text("ap-northeast-1"),
      value: "ap-northeast-1",
    );
    DropdownMenuItem item4 = DropdownMenuItem(
      child: Text("cn-beijing"),
      value: "cn-beijing",
    );
    items.add(item1);
    items.add(item2);
    items.add(item3);
    items.add(item4);
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        items: getItemList(),
        isExpanded: true,
        hint: Text(_currentHint),
        onChanged: (value) {
          setState(() {
            _currentHint = value;
            if (widget.onRegionChanged != null) {
              widget.onRegionChanged(value);
            }
          });
        });
  }
}
