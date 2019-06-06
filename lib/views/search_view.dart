import 'package:flutter/material.dart';
import 'package:anipocket/constants.dart';

class SearchView extends StatelessWidget {

  SearchView({Key key, @required this.onTextWritten}) : super(key: key);
  
  final Function(String) onTextWritten;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: UI_SEARCH_HINT
          ),
          onChanged: (text) => onTextWritten(text),
        ),
      ),
    );
  }
}