import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:anipocket/constants.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:url_launcher/url_launcher.dart';

class CarouselPage extends StatefulWidget {
  final String malId;
  final String title;
  final String index;

  CarouselPage(
      {Key key,
      @required this.malId,
      @required this.title,
      @required this.index})
      : super(key: key);

  _CarouselPageState createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  JikanApi jikan = JikanApi();

  bool _appBarVisible = false;
  bool _loading = true;
  List<dynamic> _media = List();
  int _index;

  void initState() {
    super.initState();
    _getAllAnimeMedia();
    setState(() {
      _index = int.parse(widget.index);
    });
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  void _getAllAnimeMedia() async {
    final BuiltList<Picture> pictures = await jikan.getAnimePictures(int.parse(widget.malId));
    final BuiltList<Promo> videos = await jikan.getAnimeVideos(int.parse(widget.malId));
    List media = List()..addAll(videos.toList())..addAll(pictures.toList());
    setState(() {
      _media = media;
      _loading = false;
    });
  }

  void _toggleAppBarVisibility() {
    setState(() {
      _appBarVisible = !_appBarVisible;
    });
    _appBarVisible
        ? SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values)
        : SystemChrome.setEnabledSystemUIOverlays([]);
    //TODO Cuidado cuando se sale del carrusel sin que se vea el toolbar
  }

  void _updateIndex(int index) {
    setState(() {
      _index = index;
    });
  }

  void _launchVideo(videoUrl) async {
    if (await canLaunch(videoUrl)) {
      await launch(videoUrl);
    } else {
      throw 'Could not launch $videoUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _isVideo = _loading ? false : _media[_index] is Promo;
    return Scaffold(
      backgroundColor: Colors.black,
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Swiper(
                  itemCount: _media.length,
                  index: _index,
                  onIndexChanged: (i) => _updateIndex(i),
                  onTap: (i) => _toggleAppBarVisibility(),
                  itemBuilder: (context, i) {
                    return CachedNetworkImage(
                      imageUrl: _media[i] is Promo
                          ? _media[i].imageUrl
                          : _media[i].large,
                      placeholder: Center(child: CircularProgressIndicator()),
                      errorWidget: Icon(Icons.error),
                      fit: BoxFit.contain,
                    );
                  },
                ),
                SizedBox.fromSize(
                  size: Size.fromHeight(70.0),
                  child: AppBar(
                    title: Text(widget.title),
                    backgroundColor: Colors.transparent,
                    toolbarOpacity: _appBarVisible ? 1.0 : 0.0,
                    elevation: _appBarVisible ? 4 : 0,
                  ),
                ),
              ],
            ),
      floatingActionButton: Opacity(
        opacity: _isVideo ? 1.0 : 0.0,
        child: IgnorePointer(
          ignoring: _isVideo ? false : true,
          child: FloatingActionButton.extended(
            icon: Icon(Icons.play_circle_filled),
            label: Text(UI_PLAY_IN_YOUTUBE),
            tooltip: UI_PLAY_IN_YOUTUBE,
            onPressed: () => _launchVideo(_media[_index].videoUrl),
            backgroundColor: _isVideo ? null : Colors.transparent,
          ),
        ),
      ),
    );
  }
}
