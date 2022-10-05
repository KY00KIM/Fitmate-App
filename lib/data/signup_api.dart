import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../domain/model/SignupUser.dart';
import 'http_api.dart';

class SignUpApi {
  Future<Map> postSignUpUser(SignupUser user) async {
    HttpApi httpApi = HttpApi();
    try {
      log("user at API : ${user.toJson()}");
      http.Response response =
          await httpApi.post(2, 'users/oauth', user.toJson());
      print("$response");
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      print("res is : $jsonResponse");

      if (response.statusCode == 201) {
        Map user = jsonResponse['data'];
        return jsonResponse;
      }
    } catch (error) {
      print("oauth error : ${error.toString()}");
      print(error);
      Future.error(Exception("${error.toString()}"));
    }
    return {"success": false};
  }

  Future<bool> checkNickname(String nickname) async {
    final httpApi = HttpApi();
    http.Response response =
        await httpApi.getWithoutAuth('users/valid/$nickname');
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // print("result : ${jsonResponse['data']['result']}");
      // print(jsonResponse['data']['result'].runtimeType);
      return jsonResponse['data']['result'];
    } else {
      return false;
    }
  }
}
