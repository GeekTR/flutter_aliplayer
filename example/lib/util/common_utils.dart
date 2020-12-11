import 'package:flutter/material.dart';

class CommomUtils {
  static pushPage(BuildContext context, Widget route) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => route));
  }

  static popPage(BuildContext context, Widget route) {
    Navigator.pop(context, MaterialPage(builder: (context) => route));
  }
}
