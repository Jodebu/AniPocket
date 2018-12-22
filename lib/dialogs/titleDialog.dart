import 'package:flutter/material.dart';
import 'package:anipocket/constants/constants.dart';

class TitleDialog extends StatelessWidget {
  TitleDialog({
    Key key,
    @required this.titles,
  }) : super(key: key);

  final Map<String, String> titles;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Titles"),
      content: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(STANDARD_TITLE, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(titles[TITLE]),
              Divider(),
              Text(ENGLISH, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(titles[TITLE_ENGLISH]),
              Divider(),
              Text(JAPANESE, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(titles[TITLE_JAPANESE]),
            ]),
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
