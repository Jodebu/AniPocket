import 'dart:io';
import 'dart:convert';

httpGet(String url) async {
  String payload = '';
  while (payload == '') {
    try {
      HttpClientRequest request = await HttpClient().getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();
      await for (String chunk in response.transform(Utf8Decoder())) {
        payload += chunk;
      }
      return json.decode(payload);
    } on Exception {
      print('Server unresponsive. Retrying...');
      payload = '';
    }
  }
}
