import 'package:anipocket/http_services/anime.dart';
import 'package:anipocket/views/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:anipocket/views/index.dart';
import 'package:anipocket/constants.dart';
import 'package:jikan_dart/jikan_dart.dart';

class AnimeGridPage extends StatefulWidget {
  AnimeGridPage({Key key, this.animeList, this.genre}) : super(key: key);

  final List<dynamic> animeList;
  final String genre;

  @override
  _AnimeGridPageState createState() {
    return animeList != null
        ? _AnimeGridPageState(animeList, genre)
        : _AnimeGridPageState([], genre);
  }
}

class _AnimeGridPageState extends State<AnimeGridPage> {
  final JikanApi jikan = JikanApi();
  
  List<dynamic> _animeList;
  String _title = 'Top';
  int _byGenre;
  int _page = 1;
  bool _loading = true;

  _AnimeGridPageState(List<dynamic> animeList, String genre) {
    _animeList = animeList;
    _byGenre = int.parse(genre);
  }

  void initState() {
    super.initState();
    _getTop(_byGenre);
  }

  void _getTop([int genreId = 0]) async {
    setState(() {
      _loading = true;

    });

    List<dynamic> animeList = genreId == 0
      ? await getTop(ANIME)
      : await getGenre(ANIME, _byGenre);
    
    setState(() {
      _animeList = animeList;
      _loading = false;
      if (_byGenre != 0) _title = _getGenreTitle(_byGenre);
    });
  }

  void loadNextPage() async {
    List<dynamic> animeListToAdd = _byGenre == 0
      ? await getTop(ANIME, ++_page)
      : await getGenre(ANIME, _byGenre, ++_page);

    setState(() {
      _animeList.addAll(animeListToAdd);
    });
  }

  void getByGenre(int genreId) async {
    setState(() {
      _loading = true;
      _page = 1;
      _byGenre = genreId;
      _title = _getGenreTitle(genreId);
    });

    Navigator.pop(context);
    List animeList = await getGenre(ANIME, genreId);

    setState(() {
      _animeList = animeList;
      _loading = false;
    });
  }

  String _getGenreTitle(int genreId) {
    return 'Top ${ANIME_GENRES.where((genre) => genre[MAL_ID] == genreId).first[NAME]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$APP_TITLE - $_title'),
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : AnimeGridView(
                animeList: _animeList,
                loadNextPage: loadNextPage,
              ),
      ),
      drawer: NavigationDrawer(onSelectGenre: getByGenre, onSelectTop: _getTop,)
    );
  }
}
