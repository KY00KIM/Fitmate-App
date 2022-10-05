import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../domain/model/post.dart';
import '../domain/util.dart';
import 'http_api.dart';

class PostApi {
  Future<List<Post>> getPost() async {
    List<Post> _posts = <Post>[];
    final httpApi = HttpApi();

    http.Response response;
    if(visit) {
      response = await http.get(
        Uri.parse("https://fitmate.co.kr/v2/visitor/posts?page=1&limit=3"),
      );
    } else  {
      response = await httpApi.get(2, 'posts');
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List hits;
      hits = jsonResponse['data']['docs'];

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

  Future<List<Post>> getSomePost(String someOneId) async {
    List<Post> _posts = <Post>[];
    final httpApi = HttpApi();

    http.Response response;
    response = await httpApi.get(2, 'posts/user/${someOneId}');

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print("json : $jsonResponse");
      List hits;
      hits = jsonResponse['data'];
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