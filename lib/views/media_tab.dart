import 'package:flutter/material.dart';
import 'package:anipocket/constants/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:anipocket/config/app_router.dart';

class MediaTab extends StatelessWidget {
  MediaTab(
      {Key key,
      @required this.malId,
      @required this.title,
      @required this.media})
      : super(key: key);

  static const int PORTRAIT_COLUMNS = 3;
  static const int LANDSCAPE_COLUMNS = 4;
  final String malId;
  final String title;
  final List media;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return media == null
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait
                    ? PORTRAIT_COLUMNS
                    : LANDSCAPE_COLUMNS,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemCount: media == null ? 0 : media.length,
              itemBuilder: (context, i) => media[i].containsKey(VIDEO_URL)
                  ? VideoItem(
                      imageUrl: media[i][IMAGE_URL],
                      videoUrl: media[i][VIDEO_URL])
                  : PictureItem(malId: malId, title: title, media: media, index: i));
    });
  }
}

class PictureItem extends StatelessWidget {
  final String malId;
  final String title;
  final List media;
  final int index;

  PictureItem(
      {Key key, @required this.malId, this.title = '', @required this.media, @required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      child: CachedNetworkImage(
        imageUrl: media[index][SMALL],
        placeholder: Center(child: CircularProgressIndicator()),
        errorWidget: Icon(Icons.error),
        fit: BoxFit.cover,
      ),
      onTap: () => AppRouter.router
          .navigateTo(context, '/carousel/$malId/$title/$index'),
      //TODO: Hero animations -> transitions
    );
  }
}

class VideoItem extends StatelessWidget {
  final imageUrl;
  final videoUrl;

  VideoItem({Key key, @required this.imageUrl, @required this.videoUrl})
      : super(key: key);

  _launchVideo() async {
    if (await canLaunch(videoUrl)) {
      await launch(videoUrl);
    } else {
      throw 'Could not launch $videoUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: Center(child: CircularProgressIndicator()),
            errorWidget: Icon(Icons.error),
            fit: BoxFit.cover,
          ),
          PositionedDirectional(
            bottom: 4.0,
            end: 4.0,
            child: Icon(
              Icons.play_circle_filled,
              size: 50,
              color: Theme.of(context).primaryColorDark,
            ),
          )
        ],
      ),
      onTap: () => _launchVideo(),
    );
  }
}
