import 'dart:convert';
import 'package:http/http.dart' as http;

import '../domain/model/post.dart';
import 'http_api.dart';

class UserTraceApi {
  Future<void> postLocation(Map _location) async {
    List<Post> _posts = <Post>[];
    final httpApi = HttpApi();
    String data = jsonEncode(_location);
    http.Response response = await httpApi.post(1, 'trace', _location);
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print("trace sent at : ${jsonResponse['data']['createdAt']}");
    } else {}
  }
}
