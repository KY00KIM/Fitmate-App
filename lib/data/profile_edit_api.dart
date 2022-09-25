import 'http_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileEditApi {
  Future<Map> patchUser(String user_id, Map<String, dynamic> user) async {
    HttpApi httpApi = HttpApi();
    try {
      http.Response response = await httpApi.patch(2, 'users/${user_id}', user);
      print("$response");
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      print("response from server : $jsonResponse");

      if (response.statusCode == 200) {
        Map user = jsonResponse['data'];
        return jsonResponse;
      }
    } catch (error) {
      print("error from server : ${error.toString()}");
      Future.error(Exception("${error.toString()}"));
    }
    return {"success": false};
  }
}
