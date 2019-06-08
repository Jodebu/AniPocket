import 'package:flutter/material.dart';
import 'package:anipocket/constants.dart';

class SearchView extends StatefulWidget {
  SearchView({Key key, @required this.onTextWritten}) : super(key: key);

  final Function(String) onTextWritten;

  @override
  _SearchViewState createState() => _SearchViewState(onTextWritten);
}

class _SearchViewState extends State<SearchView> {

  TextEditingController _controller = TextEditingController();
  Function(String) _updateSearch;

  _SearchViewState(Function(String) onTextWritten) {
    _updateSearch = onTextWritten;
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onUpdateSearch);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onUpdateSearch() {
    _updateSearch(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: UI_SEARCH_HINT,
            suffixIcon: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _controller.clear(),
            ),
          ),
        ),
      ),
    );
  }
} 
