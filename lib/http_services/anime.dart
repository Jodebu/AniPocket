import 'dart:async';
import 'http.dart';
import 'endpoints.dart';
import 'package:anipocket/constants.dart';

Future<List> search(String type, String terms, {int page = 1, String queryString = ''}) async {
  final uri = '${Endpoints.search}/$type?q=$terms&page=$page&$queryString';
  final Map payload = await httpGet(uri);
  final List data = payload[RESULTS];
  return data;
}

Future getAnime(String malId, [String request = '', int param]) async {
  var uri = '${Endpoints.anime}/$malId';
  if (request != '') {
    uri = uri + '/$request';
  }
  if (param != null) {
    uri = uri + '/$param';
  }
  final Map payload = await httpGet(uri);
  return payload;
}

Future<List> getTop(String type, [int page = 1, String subtype = '']) async {
  final uri = '${Endpoints.top}/$type/$page/$subtype';
  final Map payload = await httpGet(uri);
  final List data = payload[TOP];
  return data;
}

Future<List> getGenre(String type, int genreId, [int page = 1]) async {
  final uri = '${Endpoints.genre}/$type/$genreId/$page';
  final Map payload = await httpGet(uri);
  final List data = payload[ANIME];
  return data;
}