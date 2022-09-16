import 'package:http/http.dart' as http;
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'dart:convert';
import 'dart:developer';

import 'model/banner.dart';
import 'model/fitnesscenter.dart';
import 'model/post.dart';
import 'instance_preference/location.dart';
import 'model/user.dart';

//공통 변수

Map fitnessPart = {
  "62c670514b8212e4674dbe34": '등',
  '62c670404b8212e4674dbe33': '어깨',
  '62c6706e4b8212e4674dbe37': '이두',
  '62c6705e4b8212e4674dbe35': '가슴',
  '62c6707f4b8212e4674dbe38': '삼두',
  '62c670874b8212e4674dbe39': '복근',
  '62c670664b8212e4674dbe36': '하체',
  '62c670a04b8212e4674dbe3a': '유산소'
};

Map fitnessPartConverse = {
  '등': "62c670514b8212e4674dbe34",
  '어깨': '62c670404b8212e4674dbe33',
  '이두': '62c6706e4b8212e4674dbe37',
  '가슴': '62c6705e4b8212e4674dbe35',
  '삼두': '62c6707f4b8212e4674dbe38',
  '복근': '62c670874b8212e4674dbe39',
  '하체': '62c670664b8212e4674dbe36',
  '유산소': '62c670a04b8212e4674dbe3a'
};
Map weekdayEngToKor = {
  "mon": "월",
  "tue": "화",
  "wed": "수",
  "thu": "목",
  "fri": "금",
  "sat": "토",
  "sun": "일"
};

class LoginedUser {
  late String _id;
  late String User_name;
  late String user_address;
}

String version = "2.0.0";
String UserCenterName = '';
bool mapOpend = false;
List chatList = [];

// 홈 화면 전역 객체들
List<Post> posts = <Post>[];
List<Banner> banners = <Banner>[];
var myFitnessCenter = null;

late locationController locator = locationController();
late User test;
late Map UserData = {
  "_id": "",
  "user_name": "",
  "user_address": "",
  "user_nickname": "",
  "user_email": "",
  "user_profile_img": "",
  "user_schedule_time": 0,
  "user_weekday": [],
  "user_introduce": "",
  "user_fitness_part": [""],
  "user_age": 0,
  "user_gender": true,
  "user_loc_bound": 3,
  "fitness_center_id": "",
  "user_longitude": 0,
  "user_latitude": 0,
  "location_id": "",
  "social": {
    "user_id": "",
    "user_name": "",
    "provider": "",
    "device_token": [""],
    "firebase_info": {}
  },
  "is_deleted": false,
  "createdAt": "",
  "updatedAt": ""
};
Map userWeekdayMap = UserData["user_weekday"];
List<String> userWeekdayList = [];
Map user_center = {};

bool findStringInList(List list, String string) {
  for (int i = 0; i < list.length; i++) {
    if (list[i] == string) return true;
  }
  return false;
}

// ignore: non_constant_identifier_names
Future<bool> UpdateUserData() async {
  log(IdToken.toString());
  http.Response response = await http
      .get(Uri.parse("${baseUrlV1}users/${UserId.toString()}"), headers: {
    // ignore: unnecessary_string_interpolations
    "Authorization": "bearer ${IdToken.toString()}",
    "Content-Type": "application/json; charset=UTF-8",
    "userId": "${UserId.toString()}"
  });
  if (response.statusCode == 200) {
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));

    UserData = resBody["data"];
    print("fitness center id : ${UserData["fitness_center_id"].toString()}");
    http.Response responseFitness = await http.get(
        Uri.parse(
            "${baseUrlV1}fitnesscenters/${UserData["fitness_center_id"].toString()}"),
        headers: {
          // ignore: unnecessary_string_interpolations
          "Authorization": "bearer ${IdToken.toString()}",
          "fitnesscenterId": "${UserData["fitness_center_id"]}"
        });

    userWeekdayMap = UserData["user_weekday"];
    userWeekdayMap.forEach((key, value) => {
          if (value && !findStringInList(userWeekdayList, key.toString()))
            {userWeekdayList.add(key)}
        });
    log("userWeekdayList : ${userWeekdayList}");

    log(UserData.toString());

    if (responseFitness.statusCode == 200) {
      var resBody2 = jsonDecode(utf8.decode(responseFitness.bodyBytes));

      UserCenterName = resBody2["data"]["center_name"];
      user_center["center_name"] = resBody2["data"]["center_name"]!;
      user_center["center_address"] = resBody2["data"]["center_address"]!;
      user_center["fitness_longitude"] = resBody2["data"]["fitness_longitude"]!;
      user_center["fitness_latitude"] = resBody2["data"]["fitness_latitude"]!;
      user_center["id"] = resBody2["data"]["_id"]!;
    }
    return true;
  } else {
    print("유저 정보 가져오지 못함");
    return false;
  }
}

bool isSignedIn() {
  return IdToken == null ? false : true;
}

late String IdToken;
late String UserId;

String baseUrlV1 = "https://fitmate.co.kr/v1/";
String baseUrlV2 = "https://fitmate.co.kr/v2/";
