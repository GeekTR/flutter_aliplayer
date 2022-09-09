import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_aliplayer/flutter_aliplayer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class FilterFragment extends StatefulWidget {
  final FlutterAliplayer fAliplayer;

  FilterFragment(this.fAliplayer);

  @override
  _FilterFragmentState createState() => _FilterFragmentState();
}

class _FilterFragmentState extends State<FilterFragment> {
  bool _mEnableSharp = false;
  bool _mEnableSR = false;
  double _mStrengthValue = 0.00;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Container(
          margin:
              EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0),
          child: Column(
            children: [
              SizedBox(width: 1, height: 20),
              _buildSharp(),
              _buildsr()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSharp() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("sharp"),
            CupertinoSwitch(
              value: _mEnableSharp,
              onChanged: (value) {
                setState(() {
                  _mEnableSharp = value;
                });
              },
            )
          ],
        ),
        _buildSharpSlider()
      ],
    );
  }

  Widget _buildSharpSlider() {
    if (_mEnableSharp) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("strength"),
          Slider(
              value: _mStrengthValue,
              min: 0.00,
              max: 1.00,
              divisions: 100,
              onChanged: (value) {
                setState(() {
                  _mStrengthValue = value;
                });
              }),
          SizedBox(width: 30, height: 20, child: Text("$_mStrengthValue"))
        ],
      );
    } else {
      return SizedBox(width: 1, height: 1);
    }
  }

  Widget _buildsr() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("sr"),
        CupertinoSwitch(
          value: _mEnableSR,
          onChanged: (value) {
            setState(() {
              _mEnableSR = value;
            });
          },
        )
      ],
    );
  }
}
