import 'dart:async';
import 'http.dart';
import 'endpoints.dart';
import 'package:anipocket/constants.dart';

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