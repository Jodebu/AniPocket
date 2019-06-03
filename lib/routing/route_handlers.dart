import 'package:fluro/fluro.dart';
import 'package:anipocket/pages/index.dart';
import 'package:anipocket/constants.dart';

var topHandler = Handler(handlerFunc: (context, params) {
  String genre = params[GENRES]?.first ?? '0';
  return AnimeGridPage(genre: genre,);
});

var animeDetailHandler = Handler(handlerFunc: (context, params) {
  String id = params[ID]?.first;
  String title = Uri.decodeQueryComponent(params[TITLE]?.first);
  return AnimeDetailPage(malId: id, title: title,);
});

var carouselHandler = Handler(handlerFunc: (context, params) {
  String id = params[ID]?.first;
  String title = Uri.decodeQueryComponent(params[TITLE]?.first);
  String index = params[INDEX]?.first;
  return CarouselPage(malId: id, title: title, index: index);
});
