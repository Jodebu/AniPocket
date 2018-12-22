import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'config/app_router.dart';
import 'package:anipocket/routing/routes.dart';
import 'package:anipocket/pages/index.dart';
import 'package:anipocket/constants/constants.dart';

void main() => runApp(AniPocket());

class AniPocket extends StatelessWidget {
  AniPocket({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    AppRouter.router = router;

    return MaterialApp(
      title: APP_TITLE,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: AnimeListPage(),
      onGenerateRoute: AppRouter.router.generator,
    );
  }
}