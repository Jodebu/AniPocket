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
  List _pictures;

  _AnimeDetailPageState(String malId) {
    _malId = malId;
  }

  void initState() {
    super.initState();
    _getAnimeInfo();
    _getAnimePictures();
  }

  void _getAnimeInfo() async {
    final anime = await getAnime(_malId);
    setState(() {
      _anime = anime;
    });
  }

  void _getAnimePictures() async {
    final pictures = await getAnime(_malId, PICTURES);
    setState(() {
      _pictures = pictures[PICTURES];
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
                      text: Text('Info'),
                    ),
                  ),
                  Tab(
                    child: IconTextPair(
                      icon: Icon(Icons.photo),
                      text: Text('Pictures'),
                    ),
                  ),
                  Tab(
                    child: IconTextPair(
                      icon: Icon(Icons.tv),
                      text: Text('Episodes'),
                    ),
                  ),
                  Tab(
                    child: IconTextPair(
                      icon: Icon(Icons.people),
                      text: Text('Characters'),
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(children: [
              AnimeInfoView(animeInfo: _anime),
              MediaTab(trailerUrl: _anime == null ? '' : _anime[TRAILER_URL], pictures: _pictures),
              Center(child: Text('PICTURES')),
              Center(child: Text('EPISODES')),
              Center(child: Text('CHARACTERS'))
            ])));
  }
}
