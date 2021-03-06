import 'dart:convert';

import 'package:anipocket/views/news_tab.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:anipocket/http_services/anime.dart';
import 'package:anipocket/constants.dart';
import 'package:anipocket/views/index.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimeDetailPage extends StatefulWidget {
  AnimeDetailPage({Key key, this.malId, this.title}) : super(key: key);

  final String malId;
  final String title;

  @override
  _AnimeDetailPageState createState() => _AnimeDetailPageState(malId);
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  final JikanApi jikan = JikanApi();

  int _malId;
  Map _anime;
  bool _favorite;
  bool _isFavDisabled;
  List<dynamic> _media;
  List _episodes;
  List _watched;
  List _news;

  _AnimeDetailPageState(String malId) {
    _malId = int.parse(malId);
  }

  void initState() {
    super.initState();
    _getAnimeInfo();
    _getAllAnimeMedia();
    _getAllEpisodes();
    _getWatchedEpisodes();
    _getAllNews();
    _favorite = false;
    _isFavDisabled = true;
  }

  void _getAnimeInfo() async {
    var anime = await getAnime(_malId.toString());
    _isFavorite();
    setState(() {
      _anime = anime;
    });
  }

  void _getAllAnimeMedia() async {
    BuiltList<Picture> pictures;
    BuiltList<Promo> videos;

    while (pictures == null) {
      try { pictures = await jikan.getAnimePictures(_malId); }
      on Exception { print('Exception!!'); }
    }
    while (videos == null) {
      try { videos = await jikan.getAnimeVideos(_malId); }
      on Exception { print('Exception!!'); }
    }
    List media = List()..addAll(videos.toList())..addAll(pictures.toList());
    setState(() { _media = media; });
  }

  void _getAllEpisodes() async {
    int page = 1;
    Map ep = await getAnime(_malId.toString(), EPISODES, page);

    if (ep.containsKey(ERROR)) return;
    int lastPage = ep[EPISODES_LAST_PAGE];
    List episodes = ep[EPISODES];
    while (lastPage > page) {
      List nextPage = await _getAndAddEpisodePage(++page);
      episodes.addAll(nextPage);
    }
    setState(() { _episodes = episodes; });
  }

  dynamic _getAndAddEpisodePage(int page) async {
    Map episodes = await getAnime(_malId.toString(), EPISODES, page);
    return episodes[EPISODES];
  }

  void _getWatchedEpisodes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> watched = prefs.getStringList(_malId.toString()) ?? [];
    setState(() {
     _watched = watched; 
     // _isFavDisabled = false;
    });
  }

  void _toggleWatched(int episodeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String episode = episodeId.toString();
    List<String> watched = prefs.getStringList(_malId.toString()) ?? [];

    if (watched.contains(episode)) {
      watched.remove(episode);
      prefs.setStringList(_malId.toString(), watched);
    } else {
      watched.add(episode);
      prefs.setStringList(_malId.toString(), watched);
    }
    setState(() {
      _watched = watched;
    });
  }

  void _getAllNews() async {
    BuiltList<Article> news;
    while (news == null) {
      try { news = await jikan.getAnimeNews(_malId); }
      on Exception { print('Exception!!'); }
    }
    setState(() { _news = news.asList(); });
  }

  void _isFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var anime = jsonEncode({
      MAL_ID: _anime == null ? '' : _anime[MAL_ID],
      TITLE: _anime == null ? '' : _anime[TITLE],
      IMAGE_URL: _anime == null ? '' : _anime[IMAGE_URL]
    });
    bool favorite = (prefs.getStringList(SP_FAVORITES) ?? []).contains(anime);
    setState(() {
     _favorite = favorite; 
     _isFavDisabled = false;
    });
  }

  void _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favourites = prefs.getStringList(SP_FAVORITES) ?? [];
    var anime = jsonEncode({
      MAL_ID: _anime == null ? '' : _anime[MAL_ID],
      TITLE: _anime == null ? '' : _anime[TITLE],
      IMAGE_URL: _anime == null ? '' : _anime[IMAGE_URL]
    });

    if (_favorite) {
      favourites.remove(anime);
      prefs.setStringList(SP_FAVORITES, favourites);
    } else {
      favourites.add(anime);
      prefs.setStringList(SP_FAVORITES, favourites);
    }
    setState(() {
      _favorite = !_favorite;
    });
  }

  List<Widget> _getTabs() {
    List<Widget> tabs = List();
    tabs.add(Tab(
      child: IconTextPair(
        icon: Icon(Icons.info),
        text: Text(UI_INFO),
      ),
    ));
    tabs.add(Tab(
      child: IconTextPair(
        icon: Icon(Icons.tv),
        text: Text(UI_EPISODES),
      ),
    ));
    tabs.add(Tab(
      child: IconTextPair(
        icon: Icon(Icons.photo),
        text: Text(UI_MEDIA),
      ),
    ));
    tabs.add(Tab(
      child: IconTextPair(
        icon: Icon(Icons.chrome_reader_mode),
        text: Text(UI_NEWS),
      ),
    ));
    return tabs;
  }

  List<Widget> _getTabViews() {
    List<Widget> tabViews = List();
    tabViews.add(InfoTab(animeInfo: _anime));
    tabViews.add(EpisodesTab(malId: _malId, episodes: _episodes, watched: _watched, toggleWatched: _toggleWatched,));
    tabViews.add(MediaTab(malId: _malId, title: widget.title, media: _media));
    tabViews.add(NewsTab(news: _news));
    return tabViews;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            overflow: TextOverflow.fade,
          ),
          bottom: TabBar(
            isScrollable: true,
            tabs: _getTabs(),
          ),
          actions: [
            IconButton(
              icon: _favorite
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_border),
              onPressed: _isFavDisabled
                ? null
                : () => _toggleFavorite(),
            )
          ],
        ),
        body: TabBarView(
          children: _getTabViews(),
        ),
      ),
    );
  }
}
