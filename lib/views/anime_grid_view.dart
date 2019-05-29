import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:anipocket/config/app_router.dart';
import 'package:jikan_dart/jikan_dart.dart';

class AnimeGridView extends StatelessWidget {
  static const int PORTRAIT_COLUMNS = 3;
  static const int LANDSCAPE_COLUMNS = 4;
  final List<Top> animeList;
  final Function() loadNextPage;

  AnimeGridView({Key key, @required this.animeList, this.loadNextPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: orientation == Orientation.portrait
              ? PORTRAIT_COLUMNS
              : LANDSCAPE_COLUMNS,
          childAspectRatio: 11 / 16,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemCount: animeList.length,
        itemBuilder: (context, i) {
          if (i >= animeList.length -1) {
            loadNextPage();
          }
          return AnimeListItem(animeListItem: animeList[i]);
        },
      );
    });
  } //TODO add something to indicate that the app is loading a new page!
}

class AnimeListItem extends StatelessWidget {
  final Top animeListItem;

  AnimeListItem({Key key, @required this.animeListItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      child: GridTile(
        child: CachedNetworkImage(
          imageUrl: animeListItem.imageUrl,
          placeholder: Center(child: CircularProgressIndicator()),
          errorWidget: Icon(Icons.error),
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          title: Text(
            animeListItem.title,
            maxLines: 2,
          ),
          backgroundColor: Theme.of(context).primaryColorDark.withOpacity(0.75),
        ),
      ),
      onTap: () {
        final encodedTitle = Uri.encodeComponent(animeListItem.title);
        AppRouter.router.navigateTo(context, '/anime_detail/${animeListItem.malId}/$encodedTitle');
      }
    );
  }
}
