import 'dart:convert';

import 'package:anipocket/http_services/anime.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/app_router.dart';
import 'package:anipocket/routing/routes.dart';
import 'package:anipocket/pages/index.dart';
import 'package:anipocket/constants.dart';
import 'package:background_fetch/background_fetch.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


void backgroundFetchHeadlessTask() async {
  print('[BackgroundFetch] Headless event received.');
  _AniPocketState.initializeNotifications(flutterLocalNotificationsPlugin);
  _AniPocketState.emitNotification(flutterLocalNotificationsPlugin);
  BackgroundFetch.finish();
}

void main() {
  runApp(AniPocket());
  //BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class AniPocket extends StatefulWidget {
  _AniPocketState createState() => new _AniPocketState();
}

class _AniPocketState extends State<AniPocket> {
  static var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initializeNotifications(flutterLocalNotificationsPlugin);
    //BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
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

  static void initializeNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    //TODO: Poner un icono decente en las notificaciones
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: (int id, String title, String body, String payload) {});
    var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) {});
}

  static void emitNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool notifiedToday = prefs.getBool(SP_NOTIFIED_TODAY) ?? false;

    if (true/* DateTime.now().hour < 8 */) {
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
      
      sendNotification(titleList, flutterLocalNotificationsPlugin);
      prefs.setBool(SP_NOTIFIED_TODAY, true);
    }

    BackgroundFetch.finish();
  }

  static void sendNotification(List animeTitles, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
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

    emitNotification(flutterLocalNotificationsPlugin);

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
