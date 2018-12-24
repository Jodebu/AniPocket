import 'dart:io';
import 'dart:convert';

httpGet(String url) async {
  HttpClientRequest request = await HttpClient().getUrl(Uri.parse(url));
  HttpClientResponse response = await request.close();
  String payload = '';
  await for (String chunk in response.transform(Utf8Decoder())) {
    payload += chunk;
  }
  return json.decode(payload);
}
