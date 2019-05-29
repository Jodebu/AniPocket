import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jikan_dart/jikan_dart.dart';
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
  final int malId;
  final String title;
  final List media;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) => media == null
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
              itemBuilder: (context, i) =>
                  MediaItem(malId: malId, title: title, media: media, index: i),
            ),
    );
  }
}

class MediaItem extends StatelessWidget {
  final int malId;
  final String title;
  final List media;
  final int index;

  MediaItem(
      {Key key,
      @required this.malId,
      this.title = '',
      @required this.media,
      @required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _isVideo = media[index] is Promo;

    return InkResponse(
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: _isVideo ? media[index].imageUrl : media[index].small,
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
              color: _isVideo
                  ? Theme.of(context).primaryColorDark
                  : Colors.transparent,
            ),
          )
        ],
      ),
      onTap: () {
        final encodedTitle = Uri.encodeComponent(title);
        AppRouter.router.navigateTo(context, '/carousel/$malId/$encodedTitle/$index');
        //TODO: Hero animations -> transitions
      },
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
