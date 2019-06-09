import 'package:flutter/material.dart';
import 'package:anipocket/constants.dart';

class FilterDialog extends StatefulWidget {
  FilterDialog({ @required this.filters, @required this.applyFilters });

  final Map<String, dynamic> filters;
  final Function() applyFilters;

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  Map<String, dynamic> _filters = {};
  Function() _applyFilters = () {};

  @override
  void initState() {
    _filters = widget.filters;
    _applyFilters = widget.applyFilters;
    super.initState();
  }

  void changedDropDownItem(String itemId, String filter) {
    Map newFilters = _filters;
    newFilters[filter] = itemId.toString();

    setState(() {
      _filters = newFilters;
    });
  }

  List<DropdownMenuItem<String>> _getAsDropdownList(List<Map> list) {
    List<DropdownMenuItem<String>> dropdownList = new List();
    for (Map item in list) {
      dropdownList.add(new DropdownMenuItem(
        value: item[MAL_ID].toString(),
        child: new Text(item[NAME]),
      ));
    }
    return dropdownList;
  }

  Widget rowDropdownFilter({String displayName, String filterName, String defaultValue, List data}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Text(displayName),
        ),
        Flexible(
          flex: 2,
          child: new DropdownButton<String>(
            value: _filters[filterName] ?? defaultValue,
            items: _getAsDropdownList(data),
            onChanged: (id) => changedDropDownItem(id, filterName),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(UI_FILTER),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          rowDropdownFilter(
            displayName: UI_GENRES,
            filterName: GENRE,
            defaultValue: '1',
            data: getSortedGenres()
          ),
          rowDropdownFilter(
            displayName: UI_TYPE,
            filterName: TYPE,
            defaultValue: 'tv',
            data: ANIME_TYPES
          ),
          rowDropdownFilter(
            displayName: UI_STATE,
            filterName: STATE,
            defaultValue: 'airing',
            data: ANIME_STATE
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
            //TODO: Devolver los filtros
            _applyFilters();
          },
        ),
      ],
    );
  }
}