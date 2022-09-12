import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../domain/util.dart';

class FitnessCenterApi {
  Future get(int page, int limit, double first_longitude, double first_latitude, double second_longitude, double second_latitude) async {
    http.Response response = await http.get(
      Uri.parse("https://fitmate.co.kr/v2/fitnesscenters"),
      headers: {
        "Authorization": "bearer $IdToken",
        "Content-Type": "application/json; charset=UTF-8",
        "page": page.toString(),
        "limit": limit.toString(),
        "first_longitude": first_longitude.toString(),
        "first_latitude": first_latitude.toString(),
        "second_longitude": second_longitude.toString(),
        "second_latitude": second_latitude.toString(),
      },
    );
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200 &&
        resBody["error"]["code"] == "auth/id-token-expired") {
      print("실패");
      IdToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();

      response = await http.get(
        Uri.parse("https://fitmate.co.kr/v2/fitnesscenters"),
        headers: {
          "Authorization": "bearer $IdToken",
          "Content-Type": "application/json; charset=UTF-8",
          "page": page.toString(),
          "limit": limit.toString(),
          "first_longitude": first_longitude.toString(),
          "first_latitude": first_latitude.toString(),
          "second_longitude": second_longitude.toString(),
          "second_latitude": second_latitude.toString(),
        },
      );
    }

    return response;
  }
}