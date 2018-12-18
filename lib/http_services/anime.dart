import 'http.dart';
import 'endpoints.dart';
import 'package:anipocket/constants/constants.dart';

Future getAnimeInfo(String malId) async {
  final uri = '${Endpoints.anime}/$malId';
  final Map payload = await httpGet(uri);
  return payload;
}

Future<List> getTop(String type, [int page = 1, String subtype = '']) async {
  final uri = '${Endpoints.top}/$type/$page/$subtype';
  final Map payload = await httpGet(uri);
  final List data = payload[TOP];
  return data;
}