import 'dart:convert';
import 'package:http/http.dart' as http;

import '../domain/model/post.dart';
import 'http_api.dart';

class UserTraceApi {
  Future<void> postLocation(Map _location) async {
    final httpApi = HttpApi();
    http.Response response = await httpApi.post(1, 'trace', _location);
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("trace sent at : ${jsonResponse['data']['createdAt']}");
    } else {
      print("trace failed");
      print(jsonResponse);
    }
  }
}
