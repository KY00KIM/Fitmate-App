import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import '../domain/util.dart';

class HttpApi {
  String baseUrl = "https://fitmate.co.kr/";

  Future get(int version, String url) async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();

    http.Response response = await http.get(
      Uri.parse("${baseUrl}v${version.toString()}/${url}"),
      headers: {
        "Authorization": "bearer $IdToken",
        'device': '${deviceToken}',
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

      response = await http.get(
        Uri.parse("${baseUrl}v${version.toString()}/${url}"),
        headers: {
          "Authorization": "bearer $IdToken",
          'device': '${deviceToken}',
          "Content-Type": "application/json; charset=UTF-8"
        },
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    return response;
  }

  Future post(int version, String url, Map body) async {
    String json = jsonEncode(body);
    http.Response response =
        await http.post(Uri.parse("${baseUrl}v${version.toString()}/${url}"),
            headers: {
              "Authorization": "bearer $IdToken",
              "Content-Type": "application/json; charset=UTF-8"
            },
            body: json);
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200 &&
        resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();

      response =
          await http.post(Uri.parse("${baseUrl}v${version.toString()}/${url}"),
              headers: {
                "Authorization": "bearer $IdToken",
                "Content-Type": "application/json; charset=UTF-8"
              },
              body: body);
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    return response;
  }

  Future delete(int version, String url) async {
    http.Response response = await http.delete(
      Uri.parse("${baseUrl}v${version.toString()}/${url}"),
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

      response = await http.delete(
        Uri.parse("${baseUrl}v${version.toString()}/${url}"),
        headers: {
          "Authorization": "bearer $IdToken",
          "Content-Type": "application/json; charset=UTF-8"
        },
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    return response;
  }

  Future patch(int version, String url, Map body) async {
    http.Response response =
        await http.patch(Uri.parse("${baseUrl}v${version.toString()}/${url}"),
            headers: {
              "Authorization": "bearer $IdToken",
              "Content-Type": "application/json; charset=UTF-8"
            },
            body: body);
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200 &&
        resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();

      response =
          await http.patch(Uri.parse("${baseUrl}v${version.toString()}/${url}"),
              headers: {
                "Authorization": "bearer $IdToken",
                "Content-Type": "application/json; charset=UTF-8"
              },
              body: body);
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    return response;
  }
}
