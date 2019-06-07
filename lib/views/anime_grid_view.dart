import 'package:anipocket/constants.dart';
import 'package:anipocket/pages/index.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:anipocket/config/app_router.dart';

class AnimeGridView extends StatelessWidget {
  static const int PORTRAIT_COLUMNS = 3;
  static const int LANDSCAPE_COLUMNS = 5;
  final List<dynamic> animeList;
  final Function() loadNextPage;
  final ViewType viewType;

  AnimeGridView({Key key, @required this.animeList, @required this.loadNextPage, @required this.viewType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return GridView.builder(
        padding: EdgeInsets.only(top: viewType == ViewType.search ? 68.0 : 0),
        //TODO: only portrait plz
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
          if (i == animeList.length - 10 && viewType != ViewType.favorite) {
            loadNextPage();
          }
          return AnimeListItem(animeListItem: animeList[i]);
        },
      );
    });
  } //TODO add something to indicate that the app is loading a new page!
}

class AnimeListItem extends StatelessWidget {
  final dynamic animeListItem;

  AnimeListItem({Key key, @required this.animeListItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      child: GridTile(
        child: CachedNetworkImage(
          imageUrl: animeListItem[IMAGE_URL],
          placeholder: Center(child: CircularProgressIndicator()),
          errorWidget: Icon(Icons.error),
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          title: Text(
            animeListItem[TITLE],
            maxLines: 2,
          ),
          backgroundColor: Theme.of(context).primaryColorDark.withOpacity(0.75),
        ),
      ),
      onTap: () {
        final encodedTitle = Uri.encodeComponent(animeListItem[TITLE]);
        AppRouter.router.navigateTo(context, '/anime_detail/${animeListItem[MAL_ID]}/$encodedTitle');
      }
    );
  }
}
