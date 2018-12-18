import 'package:flutter/material.dart';
import 'package:anipocket/config/app_router.dart';
import 'package:anipocket/constants/constants.dart';

class AnimeListView extends StatelessWidget {
  static const int PORTRAIT_COLUMNS = 3;
  static const int LANDSCAPE_COLUMNS = 4;
  final List animeList;
  final Function() loadNextPage;

  AnimeListView({Key key, @required this.animeList, this.loadNextPage})
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
        itemBuilder: (context, i) {
          if (i >= animeList.length) {
            loadNextPage();
            print('loaded new page');
          }
          print('generated item number $i');
          return (i >= animeList.length)
              ? Center(child: CircularProgressIndicator())
              : AnimeListItem(animeListItem: animeList[i]);
        },
      );
    });
  }
}

class AnimeListItem extends StatelessWidget {
  final animeListItem;

  AnimeListItem({Key key, @required this.animeListItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      child: GridTile(
        child: Image.network(
          animeListItem[IMAGE_URL],
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
      onTap: () => AppRouter.router
          .navigateTo(context, '/anime_detail/${animeListItem[MAL_ID]}/${animeListItem[TITLE]}'),
    );
  }
}
