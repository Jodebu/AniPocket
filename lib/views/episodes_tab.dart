import 'package:flutter/material.dart';
import 'package:anipocket/constants.dart';
import 'package:intl/intl.dart';

class EpisodesTab extends StatelessWidget {
  EpisodesTab({Key key, @required this.malId, @required this.episodes, @required this.watched, @required this.toggleWatched})
      : super(key: key);

  final int malId;
  final List episodes;
  final List<String> watched;
  final Function toggleWatched;

  Text _getIfFillerOrRecap(int index) {
    List params = List();
    if (episodes[index][FILLER]) params.add(FILLER);
    if (episodes[index][RECAP]) params.add(RECAP);
    if (params.isEmpty) {
      return null;
    }
    String message = 'This is a ${params.join(' and ')} episode';
    return Text(message);
  }

  Widget _getEpisodeList() {
    return episodes.isEmpty
      ? Center(child: Text(UI_NO_EPISODES, textAlign: TextAlign.center,),)
      : ListView.separated(
      separatorBuilder: (context, i) => Divider(),
      itemCount: episodes == null ? 0 : episodes.length,
      itemBuilder: (context, i) => ExpansionTile(
        leading: IconButton(
          icon: watched.contains(episodes[i][EPISODE_ID].toString())
            ? Icon(Icons.visibility, color: Theme.of(context).primaryColor,)
            : Icon(Icons.visibility_off),
          onPressed: () => toggleWatched(episodes[i][EPISODE_ID]),
        ),
        title: Text(episodes[i][TITLE]),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.info),
            title: Text(episodes[i][TITLE_JAPANESE] ?? UI_NO_TITLE),
            subtitle: Text(episodes[i][TITLE_ROMANJI] ?? UI_NO_TITLE),
            dense: true,
          ),
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text(episodes[i][AIRED] == null
                ? UI_NO_DATE
                : DateFormat('dd-MM-yyyy').format(DateTime.parse(episodes[i][AIRED]))),
            subtitle: _getIfFillerOrRecap(i),
            dense: true,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return episodes == null
        ? Center(child: CircularProgressIndicator())
        : _getEpisodeList();
  }
}
