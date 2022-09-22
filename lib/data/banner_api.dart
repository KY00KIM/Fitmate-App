import 'dart:convert';
import 'package:http/http.dart' as http;

import '../domain/model/banner.dart';
import 'http_api.dart';

class BannerApi {
  Future<List<Banner>> getBanner() async {
    List<Banner> _banner = <Banner>[];
    final httpApi = HttpApi();

    print("배너");
    http.Response response = await http.get(Uri.parse("https://fitmate.co.kr/v2/banner"));
    print("배너 완료");
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List hits = jsonResponse['data'];
      for(int i = 0; i < hits.length; i++) {
        try {
          _banner.add(Banner.fromJson(hits[i]));
        } catch (e) {
        }
      }
      return _banner;
    } else {
      print("배너 에러 떳씁니다!");
      throw Exception('Failed to load post');
    }
  }
}