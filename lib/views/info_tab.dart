import 'package:anipocket/config/app_router.dart';
import 'package:flutter/material.dart';
import 'package:anipocket/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:anipocket/dialogs/titleDialog.dart';
import 'package:anipocket/views/index.dart';

class InfoTab extends StatelessWidget {
  InfoTab({Key key, this.animeInfo}) : super(key: key);

  final Map animeInfo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          HeaderView(animeInfo: animeInfo),
          Divider(),
          CategoriesView(
              genres: animeInfo == null ? List() : animeInfo[GENRES]),
          Divider(),
          SynopsisView(
              synopsis: animeInfo == null ? UI_LOADING : animeInfo[SYNOPSIS])
        ],
      ),
    );
  }
}

class HeaderView extends StatelessWidget {
  HeaderView({Key key, this.animeInfo}) : super(key: key);

  final Map animeInfo;

  void _showTitleDialog(BuildContext context, Map<String, String> titles) {
    showDialog(
        context: context, builder: (context) => TitleDialog(titles: titles));
  }

  Map<String, String> _getTitles() {
    Map titles = Map<String, String>();
    titles[TITLE] = animeInfo[TITLE];
    titles[TITLE_ENGLISH] = animeInfo[TITLE_ENGLISH];
    titles[TITLE_JAPANESE] = animeInfo[TITLE_JAPANESE];
    return titles;
  }

  String _getDates() {
    DateTime from = DateTime.tryParse(animeInfo[AIRED]['from']);
    String dates = '${from.day}/${from.month}/${from.year}';
    if (animeInfo[AIRED]['to'] != null) {
      DateTime to = DateTime.tryParse(animeInfo[AIRED]['to']);
      dates = dates + ' - ${to.day}/${to.month}/${to.year}';
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: animeInfo == null
                ? Center(child: CircularProgressIndicator())
                : CachedNetworkImage(
                    imageUrl: animeInfo[IMAGE_URL],
                    placeholder: Center(child: CircularProgressIndicator()),
                    errorWidget: Icon(Icons.error),
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
          ),
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkResponse(
                  child: Text(
                    animeInfo == null ? UI_LOADING : animeInfo[TITLE],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _showTitleDialog(context, _getTitles()),
                ),
                Divider(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconTextPair(
                      icon: Icon(Icons.local_movies,
                          color: Theme.of(context).primaryColor),
                      text: Text(animeInfo == null
                          ? UI_LOADING
                          : animeInfo[TYPE].toString()),
                    ),
                    Padding(padding: EdgeInsets.only(left: 8.0)),
                    IconTextPair(
                      icon:
                          Icon(Icons.tv, color: Theme.of(context).primaryColor),
                      text: Text(animeInfo == null
                          ? UI_LOADING
                          : animeInfo[EPISODES].toString()),
                    ),
                  ],
                ),
                IconTextPair(
                  icon: Icon(Icons.live_tv,
                      color: Theme.of(context).primaryColor),
                  text:
                      Text(animeInfo == null ? UI_LOADING : animeInfo[STATUS]),
                ),
                IconTextPair(
                  icon: Icon(Icons.date_range,
                      color: Theme.of(context).primaryColor),
                  text: Text(animeInfo == null ? UI_LOADING : _getDates()),
                ),
                IconTextPair(
                  icon:
                      Icon(Icons.timer, color: Theme.of(context).primaryColor),
                  text: Text(
                      animeInfo == null ? UI_LOADING : animeInfo[DURATION]),
                ),
                IconTextPair(
                  icon: Icon(Icons.outlined_flag,
                      color: Theme.of(context).primaryColor),
                  text: Text(animeInfo == null
                      ? UI_LOADING
                      : animeInfo[RATING].split('(')[0]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoriesView extends StatelessWidget {
  CategoriesView({Key key, this.genres}) : super(key: key);

  final List genres;

  void _showGenre(BuildContext context, int genreId) {
    AppRouter.router.navigateTo(context, '/top/genre/${genreId.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(UI_GENRES, style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: -8.0,
          children: genres
            .map((genre) => ActionChip(
              label: Text(genre[NAME]),
              onPressed: () => _showGenre(context, genre[MAL_ID]),
            ))
            .toList(),
        ),
      ],
    );
  }
}

class SynopsisView extends StatelessWidget {
  SynopsisView({Key key, this.synopsis}) : super(key: key);

  final String synopsis;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(UI_SYNOPSIS, style: TextStyle(fontWeight: FontWeight.bold)),
        Padding(padding: EdgeInsets.only(top: 8.0)),
        Text(synopsis)
      ],
    );
  }
}
