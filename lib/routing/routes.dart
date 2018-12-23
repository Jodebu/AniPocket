import 'package:fluro/fluro.dart';
import 'package:anipocket/routing/route_handlers.dart';

class Routes {

  static void configureRoutes(Router router) {
    router.define("/anime_detail/:id/:title", handler: animeDetailHandler);
    router.define("carousel/:title", handler: carouselHandler);
  }
}
