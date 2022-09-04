import 'dart:convert';
import 'package:http/http.dart' as http;

import '../domain/model/posts.dart';
import 'http_api.dart';

class PostApi {
  Future<List> getPost() async {
    List<Posts> _posts = <Posts>[];
    final httpApi = HttpApi();

    http.Response response = await httpApi.get(1, 'posts');

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List hits = jsonResponse['data'];
      for(int i = 0; i < hits.length; i++) {
        try {
          _posts.add(Posts.fromJson(hits[i]));
        } catch (e) {
        }
      }
      return _posts;
    } else {
      print("post 에러 떳습니다!");
      throw Exception('Failed to load post');
    }
  }
}