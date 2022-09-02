import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;


import 'package:firebase_auth/firebase_auth.dart';

import '../domain/model/posts.dart';
import '../domain/util.dart';

class PostApi {
  Future<List> getPost(bool isPosts) async {
    //print("homeposts : ${HomePosts.length == 0}");
    //print("reload : ${widget.reload}");
    //if (isPosts == true && widget.reload == false) return HomePosts;
    //if (isPosts == true && refresh == true) {
    //  refresh = false;
    //  return HomePosts;
    //}

    List<Posts> _posts = <Posts>[];

    http.Response response = await http.get(
      Uri.parse("${baseUrl}posts"),
      headers: {
        "Authorization": "bearer $IdToken",
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200 &&
        resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();

      http.Response response = await http.post(
        Uri.parse("${baseUrl}posts"),
        headers: {
          'Authorization': 'bearer $IdToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    if (isPosts == false) {
      //refresh = true;
      //setState(() {});
    }

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
      print("what the fuck");
      throw Exception('Failed to load post');
    }
  }
}