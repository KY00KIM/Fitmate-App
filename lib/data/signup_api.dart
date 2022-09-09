import 'dart:convert';
import 'package:http/http.dart' as http;

import '../domain/model/SignupUser.dart';
import 'http_api.dart';

class SignUpApi {
  Future<Map> postSignUpUser(SignupUser user) async {
    final httpApi = HttpApi();
    try {
      http.Response response =
          await httpApi.post(1, 'users/oauth', user.toJson());

      if (response.statusCode == 201) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        Map user = jsonResponse['data'];
        return jsonResponse;
      }
    } catch (error) {
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
