import 'package:flutter/material.dart';

typedef OnChecked = void Function(int value);

class CustomRadioButton extends StatelessWidget {
  final String title;
  final int value;
  final int groupValue;
  OnChecked onChecked;

  CustomRadioButton(
      {Key key, this.title, this.value, this.groupValue, this.onChecked})
      : assert(title != null),
        assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (value == groupValue) {
      //选中状态
      return Container(
        child: FlatButton(
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
          onPressed: () {},
        ),
      );
    } else {
      //未选中状态
      return Container(
        child: OutlineButton(
          child: Text(
            title,
            style: TextStyle(color: Colors.blue),
          ),
          color: Colors.blue,
          onPressed: () {
            if (onChecked != null) {
              onChecked.call(value);
            }
          },
        ),
      );
    }
  }
}
