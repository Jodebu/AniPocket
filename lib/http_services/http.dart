import 'dart:io';
import 'dart:convert';

httpGet(String url) async {
  var request = await HttpClient().getUrl(Uri.parse(url));
  var response = await request.close();
  //var object = json.decode(response.transform(utf8.decoder).join());
  String payload = '';
  await for (String chunk in response.transform(Utf8Decoder())) {
    payload += chunk;
  }
  return json.decode(payload);
}
