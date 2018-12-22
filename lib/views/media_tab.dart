import 'package:flutter/material.dart';
import 'package:anipocket/constants/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MediaTab extends StatelessWidget {
  MediaTab({Key key, this.trailerUrl, this.pictures}) : super(key: key);

  static const int PORTRAIT_COLUMNS = 3;
  static const int LANDSCAPE_COLUMNS = 4;
  final String trailerUrl;
  final List pictures;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return pictures == null
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait
                    ? PORTRAIT_COLUMNS
                    : LANDSCAPE_COLUMNS,
                childAspectRatio: 1,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemCount: pictures == null ? 0 : pictures.length,
              itemBuilder: (context, i) =>
                  PictureItem(imageUrl: pictures[i][SMALL]));
    });
  }
}

class PictureItem extends StatelessWidget {
  final imageUrl;

  PictureItem({Key key, @required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: Center(child: CircularProgressIndicator()),
        errorWidget: Icon(Icons.error),
        fit: BoxFit.cover,
      ),
      //TODO: image_view -> Fullscreen, Hero animations -> transitions
    );
  }
}
