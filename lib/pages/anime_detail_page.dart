import 'package:flutter/material.dart';
import 'package:anipocket/http_services/anime.dart';
import 'package:anipocket/constants.dart';
import 'package:anipocket/views/index.dart';

class AnimeDetailPage extends StatefulWidget {
  AnimeDetailPage({Key key, this.malId, this.title}) : super(key: key);

  final String malId;
  final String title;

  @override
  _AnimeDetailPageState createState() => _AnimeDetailPageState(malId);
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  String _malId;
  Map _anime;
  List _media;
  List _episodes;

  _AnimeDetailPageState(String malId) {
    _malId = malId;
  }

  void initState() {
    super.initState();
    _getAnimeInfo();
    _getAllAnimeMedia();
    _getAllEpisodes();
  }

  void _getAnimeInfo() async {
    final anime = await getAnime(_malId);
    setState(() {
      _anime = anime;
    });
  }

  void _getAllAnimeMedia() async {
    final Map pictures = await getAnime(_malId, PICTURES);
    final Map videos = await getAnime(_malId, VIDEOS);
    List media = List()..addAll(videos[PROMO])..addAll(pictures[PICTURES]);
    setState(() {
      _media = media;
    });
  }

  void _getAllEpisodes() async {
    int page = 1;
    final Map ep = await getAnime(_malId, EPISODES, page);
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
    final Map episodes = await getAnime(_malId, EPISODES, page);
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
    if (_episodes != null) {
      tabs.add(Tab(
          child: IconTextPair(
        icon: Icon(Icons.tv),
        text: Text(UI_EPISODES),
      )));
    }
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
    if (_episodes != null)
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
