import 'package:flutter/material.dart';
import 'package:anipocket/http_services/anime.dart';
import 'package:anipocket/constants/constants.dart';
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

  _AnimeDetailPageState(String malId) {
    _malId = malId;
  }

  void initState() {
    super.initState();
    _getAnimeInfo();
    _getAnimeMedia();
  }

  void _getAnimeInfo() async {
    final anime = await getAnime(_malId);
    setState(() {
      _anime = anime;
    });
  }

  void _getAnimeMedia() async {
    final Map pictures = await getAnime(_malId, PICTURES);
    final Map videos = await getAnime(_malId, VIDEOS);
    List media = List()..addAll(videos[PROMO])..addAll(pictures[PICTURES]);
    setState(() {
      _media = media;
    });
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
                tabs: [
                  Tab(
                    child: IconTextPair(
                      icon: Icon(Icons.info),
                      text: Text(UI_INFO),
                    ),
                  ),
                  Tab(
                    child: IconTextPair(
                      icon: Icon(Icons.photo),
                      text: Text(UI_PICTURES),
                    ),
                  ),
                  Tab(
                    child: IconTextPair(
                      icon: Icon(Icons.tv),
                      text: Text(UI_EPISODES),
                    ),
                  ),
                  Tab(
                    child: IconTextPair(
                      icon: Icon(Icons.people),
                      text: Text(UI_CHARACTERS),
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(children: [
              AnimeInfoView(animeInfo: _anime),
              MediaTab(media: _media),
              Center(child: Text('EPISODES')),
              Center(child: Text('CHARACTERS'))
            ])));
  }
}
