import 'package:flutter/material.dart';
import 'package:anipocket/constants/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AnimeInfoView extends StatelessWidget {
  AnimeInfoView({Key key, this.animeInfo}) : super(key: key);

  final Map animeInfo;
  final CircularProgressIndicator circularProgressIndicator =
      CircularProgressIndicator();

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
                    Text(
                      animeInfo == null ? 'title' : animeInfo[TITLE],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
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
                      text: Text(animeInfo == null
                          ? LOADING
                          : animeInfo[STATUS]),
                    ),
                    IconTextPair(
                      icon: Icon(Icons.live_tv,
                          color: Theme.of(context).primaryColor),
                      text: Text(
                          animeInfo == null ? LOADING : animeInfo[DURATION]),
                    ),
                    Text(
                      animeInfo == null
                          ? 'No english title provided'
                          : animeInfo[TITLE_ENGLISH],
                      softWrap: true,
                    ),
                    Text(
                      animeInfo == null
                          ? 'No japanese title provided'
                          : animeInfo[TITLE_JAPANESE],
                      softWrap: true,
                    )
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
    return Row(
        mainAxisAlignment: MainAxisAlignment.start, children: [icon, Padding(padding: EdgeInsets.only(left: 4.0),), text]);
  }
}
