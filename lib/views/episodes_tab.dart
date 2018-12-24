import 'package:flutter/material.dart';
import 'package:anipocket/constants/constants.dart';

class EpisodesTab extends StatelessWidget {
  EpisodesTab({Key key, @required this.title, @required this.episodes})
      : super(key: key);

  final String title;
  final List episodes;

  @override
  Widget build(BuildContext context) {
    return episodes == null
        ? Center(child: CircularProgressIndicator())
        : ListView.separated(
            separatorBuilder: (context, i) => Divider(),
            itemCount: episodes == null ? 0 : episodes.length,
            itemBuilder: (context, i) => ExpansionTile(
                  leading: Text(episodes[i][EPISODE_ID].toString()),
                  title: Text(episodes[i][TITLE]),
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.info),
                      title: Text(episodes[i][TITLE_JAPANESE]),
                      subtitle: Text(episodes[i][TITLE_ROMANJI]),
                    )
                  ],
                ),
          );
  }
}
