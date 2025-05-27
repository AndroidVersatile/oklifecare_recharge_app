import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StepProgressView extends StatelessWidget {
  final double width;
  final List<String> titles;
  final int curStep;
  final Color activeColor;
  final Color inactiveColor = hexToColor("#E6EEF3");
  final double lineWidth = 3.0;
  final Function(int) onStepTap;
  final TextStyle textStyle; // 👈 New parameter added

  StepProgressView({
    Key? key,
    required this.curStep,
    required this.titles,
    required this.width,
    required this.activeColor,
    required this.onStepTap,
    this.textStyle = const TextStyle(color: Colors.black), // 👈 Default Black
  }) : assert(width > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _iconViews(),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _titleViews(),
          ),
        ],
      ),
    );
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    titles.asMap().forEach((i, icon) {
      var circleColor = (i == 0 || curStep > i + 1) ? activeColor : inactiveColor;
      var lineColor = curStep > i + 1 ? activeColor : inactiveColor;
      var iconColor = (i == 0 || curStep > i + 1) ? activeColor : inactiveColor;

      list.add(
        GestureDetector(
          onTap: () => onStepTap(i),
          child: Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(22.0)),
              border: Border.all(
                color: circleColor,
                width: 2.0,
              ),
            ),
            child: Center(
              child: Container(
                width: 12.0,
                height: 12.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      );

      if (i != titles.length - 1) {
        list.add(Expanded(
          child: Container(
            height: lineWidth,
            color: lineColor,
          ),
        ));
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    titles.asMap().forEach((i, text) {
      list.add(
        GestureDetector(
          onTap: () => onStepTap(i),
          child: Text(
            text,
            style: textStyle, // 👈 Apply custom text style
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
    return list;
  }

  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
