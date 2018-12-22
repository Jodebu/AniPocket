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
    showDialog(context: context, builder: (context) => TitleDialog(titles: titles));
  }

  Map<String, String> _getTitles() {
    Map titles = Map<String, String>();
    titles[TITLE] = animeInfo[TITLE];
    titles[TITLE_ENGLISH] = animeInfo[TITLE_ENGLISH];
    titles[TITLE_JAPANESE] = animeInfo[TITLE_JAPANESE];
    return titles;
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
                        animeInfo == null ? LOADING : animeInfo[TITLE],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () =>_showTitleDialog(context, _getTitles()),
                    ),
                    Divider(),
                    IconTextPair(
                      icon: Icon(Icons.local_movies,
                          color: Theme.of(context).primaryColor),
                      text: Text(animeInfo == null
                          ? LOADING
                          : animeInfo[TYPE].toString()),
                    ),
                    IconTextPair(
                      icon:
                          Icon(Icons.tv, color: Theme.of(context).primaryColor),
                      text: Text(animeInfo == null
                          ? LOADING
                          : animeInfo[EPISODES].toString()),
                    ),
                    IconTextPair(
                      icon: Icon(Icons.live_tv,
                          color: Theme.of(context).primaryColor),
                      text:
                          Text(animeInfo == null ? LOADING : animeInfo[STATUS]),
                    ),
                    IconTextPair(
                      icon: Icon(Icons.live_tv,
                          color: Theme.of(context).primaryColor),
                      text: Text(
                          animeInfo == null ? LOADING : animeInfo[DURATION]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          AnimeStatsView(animeInfo: animeInfo)
        ]));
  }
}

class AnimeStatsView extends StatelessWidget {
  AnimeStatsView({Key key, this.animeInfo}) : super(key: key);

  final Map animeInfo;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('General Information'),
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [],
      )
    ]);
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
