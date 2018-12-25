import 'package:flutter/material.dart';
import 'package:anipocket/views/index.dart';
import 'package:anipocket/http_services/anime.dart';
import 'package:anipocket/constants.dart';

class AnimeGridPage extends StatefulWidget {
  AnimeGridPage({Key key, this.animeList}) : super(key: key);

  final List animeList;

  @override
  _AnimeGridPageState createState() {
    return animeList != null
        ? _AnimeGridPageState(animeList)
        : _AnimeGridPageState([]);
  }
}

class _AnimeGridPageState extends State<AnimeGridPage> {
  List _animeList;
  int _page = 1;
  bool _loading = true;

  _AnimeGridPageState(List animeList) {
    _animeList = animeList;
  }

  void initState() {
    super.initState();
    _getTop();
  }

  void _getTop() async {
    setState(() {
      _loading = true;
    });
    final animeList = await getTop(ANIME);
    setState(() {
      _animeList = animeList;
      _loading = false;
    });
  }

  void loadNextPage() async {
    final animeListToAdd = await getTop(ANIME, ++_page);
    setState(() {
      _animeList.addAll(animeListToAdd);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(APP_TITLE),
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : AnimeGridView(
                animeList: _animeList,
                loadNextPage: loadNextPage,
              ),
      ),
      drawer: Drawer(
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
              title: Text(UI_ADVANCED_SEARCH),
              onTap: () {},
            ),
            ListTile(
              title: Text(UI_GENRES),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
