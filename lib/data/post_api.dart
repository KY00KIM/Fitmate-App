import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../domain/model/post.dart';
import '../domain/util.dart';
import 'http_api.dart';

class PostApi {
  Future<List<Post>> getPost() async {
    print("ajsi");
    List<Post> _posts = <Post>[];
    final httpApi = HttpApi();

    http.Response response;
    print("durl 1");
    if(visit) {
      response = await http.get(
        Uri.parse("https://fitmate.co.kr/v2/visitor/posts?page=1&limit=3"),
      );
    } else  {
      response = await httpApi.get(1, 'posts');
    }
    print("durl 2");

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List hits;
      if(visit) {
        hits = jsonResponse['data']['docs'];
      } else {
        hits = jsonResponse['data'];
      }
      for(int i = 0; i < hits.length; i++) {
        try {
          _posts.add(Post.fromJson(hits[i]));
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