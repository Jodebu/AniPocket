import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:anipocket/http_services/anime.dart';
import 'package:anipocket/constants.dart';
import 'package:anipocket/views/index.dart';
import 'package:jikan_dart/jikan_dart.dart';

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
  List<dynamic> _media;
  List _episodes;

  _AnimeDetailPageState(String malId) {
    _malId = int.parse(malId);
  }

  void initState() {
    super.initState();
    _getAnimeInfo();
    _getAllAnimeMedia();
    _getAllEpisodes();
  }

  void _getAnimeInfo() async {
    final anime = await getAnime(_malId.toString());
    setState(() {
      _anime = anime;
    });
  }

  void _getAllAnimeMedia() async {
    final BuiltList<Picture> pictures = await jikan.getAnimePictures(_malId);
    final BuiltList<Promo> videos = await jikan.getAnimeVideos(_malId);
    List media = List()..addAll(videos.toList())..addAll(pictures.toList());
    setState(() {
      _media = media;
    });
  }

  void _getAllEpisodes() async {
    int page = 1;
    final Map ep = await getAnime(_malId.toString(), EPISODES, page);
    if (ep.containsKey(ERROR)) return;
    int lastPage = ep[EPISODES_LAST_PAGE];
    List episodes = ep[EPISODES];
    while (lastPage > page) {
      List nextPage = await _getAndAddEpisodePage(++page);
      episodes.addAll(nextPage);
    }
    setState(() {
      _episodes = episodes;
    });
  }

  dynamic _getAndAddEpisodePage(int page) async {
    final Map episodes = await getAnime(_malId.toString(), EPISODES, page);
    return episodes[EPISODES];
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
        icon: Icon(Icons.photo),
        text: Text(UI_PICTURES),
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
        icon: Icon(Icons.people),
        text: Text(UI_CHARACTERS),
      ),
    ));
    return tabs;
  }

  List<Widget> _getTabViews() {
    List<Widget> tabViews = List();
    tabViews.add(InfoTab(animeInfo: _anime));
    tabViews.add(MediaTab(malId: _malId, title: widget.title, media: _media));
    tabViews.add(EpisodesTab(title: widget.title, episodes: _episodes));
    tabViews.add(Center(child: Text('CHARACTERS')));
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
        ),
        body: TabBarView(
          children: _getTabViews(),
        ),
      ),
    );
  }
}
