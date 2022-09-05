import 'dart:convert';
import 'package:http/http.dart' as http;

import 'http_api.dart';

class UserApi {
  Future<List> getUser(String userId) async {
    final httpApi = HttpApi();

    http.Response response = await httpApi.get(1, 'users/${userId}');

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List hits = jsonResponse['data'];
      return hits;
    } else {
      print("post 에러 떳습니다!");
      throw Exception('Failed to load post');
    }
  }
}