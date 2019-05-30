import 'package:flutter/material.dart';

class StackedChipView extends StatelessWidget {
  StackedChipView({Key key, @required this.items, @required this.displayProperty})
      : super(key: key);

  final List items;
  final String displayProperty;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      runSpacing: -8.0,
      children: items
          .map((item) => Chip(label: Text(item[displayProperty])))
          .toList(),
    );
  }
}
