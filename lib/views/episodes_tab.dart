import 'package:flutter/material.dart';
import 'package:anipocket/constants.dart';

class EpisodesTab extends StatelessWidget {
  EpisodesTab({Key key, @required this.title, @required this.episodes})
      : super(key: key);

  final String title;
  final List episodes;

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
            leading: Text(episodes[i][EPISODE_ID].toString()),
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
                    : episodes[i][AIRED]),
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
