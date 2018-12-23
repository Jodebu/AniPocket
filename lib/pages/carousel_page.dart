import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//TODO investigate flutter_swiper for the carousel

class CarouselPage extends StatefulWidget {
  final String title;
  final List imageUrls;

  CarouselPage({Key key, @required this.title, this.imageUrls})
      : super(key: key);

  _CarouselPageState createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  bool _appBarVisible = true;

  _toggleAppBarVisibility() {
    setState(() {
      _appBarVisible = !_appBarVisible;
    });
    _appBarVisible
        ? SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values)
        : SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        toolbarOpacity: _appBarVisible ? 1.0 : 0.0,
        elevation: _appBarVisible ? 4 : 0,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.flip),
        onPressed: _toggleAppBarVisibility,
      ),
    );
  }
}
