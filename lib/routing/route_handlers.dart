import 'package:fluro/fluro.dart';
import 'package:anipocket/pages/index.dart';
import 'package:anipocket/constants.dart';

var animeDetailHandler = Handler(handlerFunc: (context, params) {
  String id = params[ID]?.first;
  String title = params[TITLE]?.first;
  return AnimeDetailPage(malId: id, title: title,);
});

var carouselHandler = Handler(handlerFunc: (context, params) {
  String id = params[ID]?.first;
  String title = params[TITLE]?.first;
  String index = params[INDEX]?.first;
  return CarouselPage(malId: id, title: title, index: index);
});
