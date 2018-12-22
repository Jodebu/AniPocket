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
              Text(UI_STANDARD_TITLE, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(titles.containsKey(TITLE) ? titles[TITLE] : UI_NO_TITLE),
              Divider(),
              Text(UI_ENGLISH, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(titles.containsKey(TITLE_ENGLISH) ? titles[TITLE_ENGLISH] : UI_NO_TITLE),
              Divider(),
              Text(UI_JAPANESE, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(titles.containsKey(TITLE_JAPANESE) ? titles[TITLE_JAPANESE] : UI_NO_TITLE),
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
