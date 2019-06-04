import 'package:flutter/material.dart';

import '../constants.dart';

class NavigationDrawer extends StatelessWidget {
  final Function(int) onSelectGenre;
  final Function() onSelectTop;
  final Function() onSelectFavorites;

  NavigationDrawer({Key key, this.onSelectGenre, this.onSelectTop, this.onSelectFavorites})
      : super(key: key);

  List<Map> _getSortedGenres(){
    List<Map> genres = List.from(ANIME_GENRES);
    genres.sort((a, b) => a[NAME].compareTo(b[NAME]));
    return genres;
  }

  @override
  Widget build(BuildContext context) {
    List<Map> genres = _getSortedGenres();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Center(
                child: Text(
              APP_TITLE,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text(UI_ADVANCED_SEARCH),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.whatshot),
            title: Text(UI_TOP_ANIME),
            onTap: () {
              Navigator.pop(context);
              onSelectTop();
              
            }
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(UI_FAVORITES),
            onTap: () {
              Navigator.pop(context);
              onSelectFavorites();
            }
          ),
          ExpansionTile(
            leading: Icon(Icons.category),
            title: Text(UI_GENRES),
            children: List<Container>.generate(
              genres.length,
              (int i) => Container(
                padding: EdgeInsets.only(left: 32.0),
                child: ListTile(
                  title: Text(genres[i][NAME]),
                  onTap: () => onSelectGenre(genres[i][MAL_ID]),
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}