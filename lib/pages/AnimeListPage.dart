import 'package:flutter/material.dart';
import 'package:anipocket/http_services/anime.dart';
import 'package:anipocket/views/index.dart';
import 'package:anipocket/constants/constants.dart';

class AnimeListPage extends StatefulWidget {
  AnimeListPage({Key key, this.animeList}) : super(key: key);

  // Fields in a Widget subclass are always marked "final".
  final List animeList;

  @override
  _AnimeListPageState createState() {
    return animeList != null
        ? _AnimeListPageState(animeList)
        : _AnimeListPageState([]);
  }
}

class _AnimeListPageState extends State<AnimeListPage> {
  List _animeList;
  int _page = 1;
  bool _loading = true;

  _AnimeListPageState(List animeList) {
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
              : AnimeListView(
                  animeList: _animeList,
                  loadNextPage: loadNextPage,
                )),
    );
  }
}
