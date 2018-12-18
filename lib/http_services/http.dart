import 'dart:io';
import 'dart:convert';

httpGet(String url) async {
  var request = await HttpClient().getUrl(Uri.parse(url));
  var response = await request.close();
  await for (var payload in response.transform(Utf8Decoder())) {
    return json.decode(payload);
  }
}
