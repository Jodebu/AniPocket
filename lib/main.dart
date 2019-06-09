import 'dart:convert';

import 'package:anipocket/http_services/anime.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:anipocket/routing/app_router.dart';
import 'package:anipocket/routing/routes.dart';
import 'package:anipocket/pages/index.dart';
import 'package:anipocket/constants.dart';
import 'package:background_fetch/background_fetch.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() {
  runApp(AniPocket());
}

class AniPocket extends StatefulWidget {
  _AniPocketState createState() => new _AniPocketState();
}

class _AniPocketState extends State<AniPocket> {
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initializeNotifications();
  }

  Future<void> initPlatformState() async {
    BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true
      ),
      emitNotification);
    if (!mounted) return;
  }

  void initializeNotifications() async {
    //TODO: Poner un icono decente en las notificaciones
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: (int id, String title, String body, String payload) {});
    var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) {});
}

  void emitNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastNotification = prefs.getInt(SP_LAST_NOTIFICATION) ?? 0;
    bool notifiedToday = prefs.getBool(SP_NOTIFIED_TODAY) ?? false;

    if (lastNotification != DateTime.now().weekday) {
      prefs.setBool(SP_NOTIFIED_TODAY, false);
      notifiedToday = false;
    }
  
    if (!notifiedToday && DateTime.now().hour >= 9) {
      List<String> favorites = prefs.getStringList(SP_FAVORITES) ?? [];
      var favoriteList = favorites.map((anime) => jsonDecode(anime));

      List airingToday = await getSchedule(WEEKDAYS[DateTime.now().weekday - 1][MAL_ID]);

      List titleList = [];
      favoriteList.forEach((favorite) => {
        airingToday.forEach((airing) => {
          if (favorite[MAL_ID] == airing[MAL_ID]) {
            titleList.add(favorite[TITLE])
          }
        })
      });

      if (titleList.isEmpty) return;
      
      sendNotification(titleList);
      prefs.setBool(SP_NOTIFIED_TODAY, true);
      prefs.setInt(SP_LAST_NOTIFICATION, DateTime.now().weekday);
    }

    BackgroundFetch.finish();
  }

  void sendNotification(List animeTitles) async {
    var bigTextStyleInformation = BigTextStyleInformation(
        animeTitles.join('<br>'),
        htmlFormatBigText: true,
        contentTitle: 'New anime episodes',
        htmlFormatContentTitle: true,
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        style: AndroidNotificationStyle.BigText,
        styleInformation: bigTextStyleInformation);
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecifics, null);

    await flutterLocalNotificationsPlugin.show(
      0,
      'New anime episodes',
      '${animeTitles[0]}${animeTitles.length > 1 ? ' and ${animeTitles.length - 1} more' : ''}',
      platformChannelSpecifics,
    );
}

  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    AppRouter.router = router;

    emitNotification();

    return MaterialApp(
      title: APP_TITLE,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: AnimeGridPage(),
      onGenerateRoute: AppRouter.router.generator,
    );
  }
}
