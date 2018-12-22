import 'package:flutter/material.dart';
import 'package:anipocket/constants/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:anipocket/dialogs/titleDialog.dart';

class AnimeInfoView extends StatelessWidget {
  AnimeInfoView({Key key, this.animeInfo}) : super(key: key);

  final Map animeInfo;
  final CircularProgressIndicator circularProgressIndicator =
      CircularProgressIndicator();

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
    return SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: animeInfo == null
                      ? circularProgressIndicator
                      : CachedNetworkImage(
                          imageUrl: animeInfo[IMAGE_URL],
                          placeholder: circularProgressIndicator,
                          errorWidget: Icon(Icons.error),
                        )),
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                          icon: Icon(Icons.tv,
                              color: Theme.of(context).primaryColor),
                          text: Text(animeInfo == null
                              ? UI_LOADING
                              : animeInfo[EPISODES].toString()),
                        ),
                      ],
                    ),
                    IconTextPair(
                      icon: Icon(Icons.live_tv,
                          color: Theme.of(context).primaryColor),
                      text: Text(
                          animeInfo == null ? UI_LOADING : animeInfo[STATUS]),
                    ),
                    IconTextPair(
                      icon: Icon(Icons.date_range,
                          color: Theme.of(context).primaryColor),
                      text: Text(animeInfo == null ? UI_LOADING : _getDates()),
                    ),
                    IconTextPair(
                      icon: Icon(Icons.timer,
                          color: Theme.of(context).primaryColor),
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
          Divider(),
          CategoriesView(genres: animeInfo == null ? List() : animeInfo[GENRES])
        ]));
  }
}

class CategoriesView extends StatelessWidget {
  CategoriesView({Key key, this.genres}) : super(key: key);

  final List genres;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(GENRES),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: -8.0,
          children:
              genres.map((genre) => Chip(label: Text(genre[NAME]))).toList(),
        ),
      ],
    );
  }
}

class IconTextPair extends StatelessWidget {
  IconTextPair({
    Key key,
    this.icon,
    this.text,
  });

  final Icon icon;
  final Text text;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      icon,
      Padding(
        padding: EdgeInsets.only(left: 4.0),
      ),
      text
    ]);
  }
}
