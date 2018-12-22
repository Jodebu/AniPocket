import 'package:flutter/material.dart';

class IconTextPair extends StatelessWidget {
  IconTextPair(
      {Key key,
      this.icon,
      this.text,
      this.mainAxisalignment: MainAxisAlignment.start});

  final Icon icon;
  final Text text;
  final MainAxisAlignment mainAxisalignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisalignment,
      children: [
        icon,
        Padding(
          padding: EdgeInsets.only(left: 4.0),
        ),
        text
      ],
    );
  }
}
