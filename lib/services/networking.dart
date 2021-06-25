import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {
  late String url;

  NetworkHelper({required this.url});

  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String body = response.body;
      return jsonDecode(body);
    } else {
      print(response.statusCode);
    }
  }
}
