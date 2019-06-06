import 'dart:convert';

import 'package:anipocket/http_services/anime.dart';
import 'package:anipocket/views/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:anipocket/views/index.dart';
import 'package:anipocket/constants.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimeGridPage extends StatefulWidget {
  AnimeGridPage({Key key, this.animeList, this.genre, this.searchMode = false}) : super(key: key);

  final List<dynamic> animeList;
  final String genre;
  final bool searchMode;

  @override
  _AnimeGridPageState createState() {
    return animeList != null
        ? _AnimeGridPageState(animeList, genre, searchMode)
        : _AnimeGridPageState([], genre, searchMode);
  }
}

class _AnimeGridPageState extends State<AnimeGridPage> {
  final JikanApi jikan = JikanApi();
  
  List<dynamic> _animeList;
  String _title = 'Top';
  int _gridType;
  int _page = 1;
  bool _loading = true;
  bool _searchMode;

  _AnimeGridPageState(List<dynamic> animeList, String genre, bool searchMode) {
    _animeList = animeList;
    _gridType = int.parse(genre);
    _searchMode = searchMode;
  }

  void initState() {
    super.initState();
    _getTop(_gridType);
  }

  void _getTop([int genreId = 0]) async {
    setState(() {
      _searchMode = false;
      _loading = true;
    });

    List<dynamic> animeList = genreId == 0
      ? await getTop(ANIME)
      : await getGenre(ANIME, _gridType);
    
    setState(() {
      _animeList = animeList;
      _loading = false;
      if (_gridType > 0) _title = _getGenreTitle(_gridType);
    });
  }

  void loadNextPage() async {
    List<dynamic> animeListToAdd = _gridType == 0
      ? await getTop(ANIME, ++_page)
      : await getGenre(ANIME, _gridType, ++_page);

    setState(() {
      _animeList.addAll(animeListToAdd ?? []);
    });
  }

  void _getFavorites() async {
    setState(() {
      _searchMode = false;
      _loading = true;
      _page = 1;
      _gridType = -1;
      _title = UI_FAVORITES;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(SP_FAVORITES) ?? [];
    var animeList = favorites.map((anime) => jsonDecode(anime));

    setState(() {
      _animeList = animeList.toList();
      _loading = false;
    });
  }

  void getByGenre(int genreId) async {
    setState(() {
      _searchMode = false;
      _loading = true;
      _page = 1;
      _gridType = genreId;
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

  void _search() {
    setState(() {
      _searchMode = true;
      _gridType = -1;
      _loading = false;
      _animeList = [];
      _title = UI_SEARCH;
    });
  }

  void searchAnime(String terms) async {
    if (terms.length < 3) return;

    setState(() {
      _loading = true;
    });

    List animeList = await search(ANIME, terms);

    setState(() {
      _loading = false;
      _animeList = animeList; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$APP_TITLE - $_title'),
      ),
      body: Column(
        children: [
          if (_searchMode) SearchView(onTextWritten: searchAnime,),
          Expanded(
            child: _loading
              ? Center(child: CircularProgressIndicator())
              : AnimeGridView(
                  animeList: _animeList,
                  loadNextPage: loadNextPage,
                  singlePage: _gridType == -1,
            ),
          ),
        ],
      ),
      drawer: NavigationDrawer(
        onSelectGenre: getByGenre,
        onSelectTop: _getTop,
        onSelectFavorites: _getFavorites,
        onSelectSearch: _search,
      )
    );
  }
}
