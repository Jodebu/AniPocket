import 'package:fluro/fluro.dart';
import 'package:anipocket/pages/index.dart';

var animeDetailHandler = Handler(handlerFunc: (context, params) {
  String id = params['id']?.first;
  String title = params['title']?.first;
  return AnimeDetailPage(malId: id, title: title,);
});

var carouselHandler = Handler(handlerFunc: (context, params) {
  String title = params['title']?.first;
  return CarouselPage(title: title,);
});
