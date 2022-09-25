import 'dart:convert';
import 'dart:developer';

import 'package:fitmate/domain/model/fitnesscenter.dart';
import 'package:http/http.dart' as http;

import '../../data/fitness_center.dart';

class FitnessCenterApiRepository {
  final fitnessCenterApi = FitnessCenterApi();
  int baselimit = 10;

  Future<List> getFitnessCentersRepo(
      int pages,
      double first_longitude,
      double first_latitude,
      double second_longitude,
      double second_latitude) async {
    //여기서 새로고침 케이스 조절
    List<FitnessCenter> _fitnessCenter = <FitnessCenter>[];
    http.Response response = await fitnessCenterApi.get(pages, baselimit,
        first_longitude, first_latitude, second_longitude, second_latitude);

    int totalDocs = 0;
    int limit = 0;
    int page = 0;
    int totalPages = 0;
    int pagingCounter = 0;
    bool hasPrevPage = false;
    bool hasNextPage = false;
    var prevPage = null;
    var nextPage = null;
    List userCount = [];

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List hits = jsonResponse['data']['docs'];
      totalDocs = jsonResponse['data']['totalDocs'];
      limit = jsonResponse['data']['limit'];
      page = jsonResponse['data']['page'];
      totalPages = jsonResponse['data']['totalPages'];
      pagingCounter = jsonResponse['data']['pagingCounter'];
      hasPrevPage = jsonResponse['data']['hasPrevPage'];
      hasNextPage = jsonResponse['data']['hasNextPage'];
      prevPage = jsonResponse['data']['prevPage'];
      nextPage = jsonResponse['data']['nextPage'];
      userCount = jsonResponse['data']['userCount'];

      for (int i = 0; i < hits.length; i++) {
        try {
          _fitnessCenter.add(FitnessCenter.fromJson(hits[i]));
        } catch (e) {}
      }
      return _fitnessCenter;
    } else {
      print("post 에러 떳습니다!");
      throw Exception('Failed to load post');
    }
  }

  Future<FitnessCenter> getFitnessRepo(int pages, double first_longitude, double first_latitude, double second_longitude, double second_latitude) async {
    print("getFitnessRepo 시작");
    http.Response response = await fitnessCenterApi.get(pages, baselimit, first_longitude, first_latitude, second_longitude, second_latitude);
    FitnessCenter _fitness;
    print("status code : ${response.statusCode}");
    if (response.statusCode == 200) {
      print("200");
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print("getFitnessRepo response : $jsonResponse");
      List hits = jsonResponse['data']['docs'];
      print("hits : $hits");

      _fitness = FitnessCenter.fromJson(hits[0]);
      return _fitness;
    } else {
      print("200 아님");
      throw Exception('Failed to load post');
    }
  }
}
