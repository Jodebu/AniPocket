import 'package:flutter/material.dart';
import 'package:anipocket/constants/constants.dart';

class AnimeInfoView extends StatelessWidget {
  AnimeInfoView({Key key, this.animeInfo}) : super(key: key);

  final Map animeInfo;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: animeInfo == null
            ? CircularProgressIndicator()
            : Text(animeInfo[SYNOPSIS]));
  }
}
