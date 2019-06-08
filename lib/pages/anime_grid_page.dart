import 'dart:convert';

import 'package:anipocket/dialogs/filter_dialog.dart';
import 'package:anipocket/http_services/anime.dart';
import 'package:anipocket/views/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:anipocket/views/index.dart';
import 'package:anipocket/constants.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimeGridPage extends StatefulWidget {
  AnimeGridPage({Key key, this.viewType , this.genre}) : super(key: key);

  final String viewType;
  final String genre;

  @override
  _AnimeGridPageState createState() {
    return _AnimeGridPageState(viewType, genre);
  }
}

class _AnimeGridPageState extends State<AnimeGridPage> {
  final JikanApi jikan = JikanApi();
  
  List<dynamic> _animeList = [];
  String _title = 'Top';
  int _page = 1;
  ViewType _viewType = ViewType.top;
  int _genre = 0;
  bool _loading = true;
  String _terms = '';
  Map<String, String> _filters = {};

  _AnimeGridPageState([String viewType, String genre]) {
    switch (viewType) {
      case 'top': _viewType = ViewType.top; break;
      case 'search': _viewType = ViewType.search; break;
      case 'favorite': _viewType = ViewType.favorite; break;
      case 'genre': _viewType = ViewType.genre; break;
      default: _viewType = ViewType.top; break;
    }
    _genre = genre == null ? 0 : int.parse(genre);
  }

  void initState() {
    super.initState();
    if (_animeList.isNotEmpty) return;
    switch (_viewType) {
      case ViewType.top: _getTop(); break;
      case ViewType.genre: getByGenre(_genre); break;
      case ViewType.favorite: _getFavorites(); break;
      case ViewType.search: _search(); break;
      default: break;
    }
  }

  void _getTop() async {
    setState(() {
      _title = 'Top';
      _viewType = ViewType.top;
      _loading = true;
    });

    List<dynamic> animeList = await getTop(ANIME);
    
    setState(() {
      _animeList = animeList;
      _loading = false;
    });
  }

  void loadNextPage() async {
    List<dynamic> animeListToAdd;

    switch (_viewType) {
      case ViewType.top: 
        animeListToAdd = await getTop(ANIME, ++_page);
        break;
      case ViewType.genre:
        animeListToAdd = await getGenre(ANIME, _genre, ++_page);
        break;
      case ViewType.search:
        animeListToAdd = await search(ANIME, _terms, page: ++_page);
        break;
      default:
        break;
    }

    setState(() {
      _animeList.addAll(animeListToAdd ?? []);
    });
  }

  void _getFavorites() async {
    setState(() {
      _viewType = ViewType.favorite;
      _loading = true;
      _page = 1;
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
      _viewType = ViewType.genre;
      _loading = true;
      _genre = genreId;
      _page = 1;
      _title = _getGenreTitle(genreId);
    });

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
      _viewType = ViewType.search;
      _loading = false;
      _page = 1;
      _animeList = [];
      _terms = '';
      _title = UI_SEARCH;
    });
  }

  void searchAnime(String terms) async {
    if (terms.length < 3 || _terms == terms) return;

    setState(() {
      _terms = terms;
      _loading = true;
      _page = 1;
    });

    List animeList = await search(ANIME, terms);

    setState(() {
      _loading = false;
      _animeList = animeList; 
    });
  }

  void _onFilterIconPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FilterDialog(
        filters: _filters,
        applyFilters: aplyFilters,
      )
    );
  }

  void aplyFilters() async {
    if (_terms.length < 3) return;

    setState(() {
      _loading = true;
      _page = 1;
    });

    List<String> queryParams = [];
    _filters.forEach((name, value) => queryParams.add('$name=$value'));
    String queryString = queryParams.join('&');

    List animeList = await search(ANIME, _terms, queryString: queryString);

    setState(() {
      _animeList = animeList; 
      _loading = false;
    });
  }

  void _getSchedule(String weekday) async {
    setState(() {
      _viewType = ViewType.airing;
      _loading = true;
      _page = 1;
      _animeList = [];
      _terms = '';
      _title = _getAiringTitle(weekday);
    });

    List animeList = await getSchedule(weekday);

    setState(() {
      _loading = false;
      _animeList = animeList; 
    });
  }

  String _getAiringTitle(String weekday) {
    return '$UI_AIRING ${WEEKDAYS.where((day) => day[MAL_ID] == weekday).first[NAME]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$APP_TITLE - $_title'),
        actions: [
          if (_viewType == ViewType.search) IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _onFilterIconPressed(context),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _loading
            ? Center(child: CircularProgressIndicator())
            : AnimeGridView(
                animeList: _animeList,
                loadNextPage: loadNextPage,
                viewType: _viewType,
          ),
          if (_viewType == ViewType.search) Align(
            alignment: Alignment.topCenter,
            child: SearchView(onTextWritten: searchAnime,),
          ),
        ],
      ),
      drawer: NavigationDrawer(
        onSelectGenre: getByGenre,
        onSelectTop: _getTop,
        onSelectFavorites: _getFavorites,
        onSelectSearch: _search,
        onSelectAiring: _getSchedule,
      ),
    );
  }
}

enum ViewType {
  search,
  top,
  favorite,
  genre,
  airing,
}
