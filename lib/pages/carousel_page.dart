import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:anipocket/constants.dart';
import 'package:anipocket/http_services/anime.dart';
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
  bool _appBarVisible = false;
  bool _loading = true;
  List _media = List();
  int _index;

  void initState() {
    super.initState();
    _getAllAnimeMedia();
    setState(() {
      _index = int.tryParse(widget.index);
    });
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  void _getAllAnimeMedia() async {
    final Map pictures = await getAnime(widget.malId, PICTURES);
    final Map videos = await getAnime(widget.malId, VIDEOS);
    List media = List()..addAll(videos[PROMO])..addAll(pictures[PICTURES]);
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
    bool _isVideo = _loading ? false : _media[_index].containsKey(VIDEO_URL);
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
                      imageUrl: _media[i].containsKey(VIDEO_URL)
                          ? _media[i][IMAGE_URL]
                          : _media[i][LARGE],
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
            onPressed: () => _launchVideo(_media[_index][VIDEO_URL]),
            backgroundColor: _isVideo ? null : Colors.transparent,
          ),
        ),
      ),
    );
  }
}
