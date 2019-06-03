import 'package:fluro/fluro.dart';
import 'package:anipocket/constants.dart';
import 'package:anipocket/routing/route_handlers.dart';

class Routes {
  static void configureRoutes(Router router) {
    router.define("/top/:$GENRES", handler: topHandler);
    router.define("/anime_detail/:$ID/:$TITLE", handler: animeDetailHandler);
    router.define("/carousel/:$ID/:$TITLE/:$INDEX", handler: carouselHandler);
  }
}
