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
                fit: FlexFit.loose,
                child: Column(
                  children: [
                    Text(
                      animeInfo == null ? 'title' : animeInfo[TITLE],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                    Text(
                      animeInfo == null ? 'title' : animeInfo[TITLE_ENGLISH],
                      softWrap: true,
                    ),
                    Text(
                      animeInfo == null ? 'title' : animeInfo[TITLE_JAPANESE],
                      softWrap: true,
                    )
                  ],
                ),
              ),
            ],
          )
        ]));
  }
}
