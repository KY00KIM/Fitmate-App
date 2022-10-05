import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:developer';
import 'model/banner.dart';
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

String version = "1.1.3";
String UserCenterName = '';
bool mapOpend = false;
List chatList = []; // sqlite로

// 홈 화면 전역 객체들
List<Post> posts = <Post>[]; //sqlite로
List<Banner> banners = <Banner>[]; //sqlite로
var myFitnessCenter = null;

late locationController locator = locationController();
late User test;
bool isLoading = false;
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
  "updatedAt": "",
  "is_certificated": false
};
Map userWeekdayMap = UserData["user_weekday"];
List<String> userWeekdayList = []; //sqlite로
Map user_center = {};
bool visit = false;

bool findStringInList(List list, String string) {
  for (int i = 0; i < list.length; i++) {
    if (list[i] == string) return true;
  }
  return false;
}

// ignore: non_constant_identifier_names
Future<bool> UpdateUserData() async {
  log(IdToken.toString());
  http.Response responseInit =
      await http.get(Uri.parse("${baseUrlV1}users/login"), headers: {
    // ignore: unnecessary_string_interpolations
    "Authorization": "bearer ${IdToken.toString()}",
    "Content-Type": "application/json; charset=UTF-8",
  });
  if (responseInit.statusCode == 200) {
    var resBody = jsonDecode(utf8.decode(responseInit.bodyBytes));
    UserId = resBody['data']['user_id'];
  }

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
    //로컬 SharedPreference에 저장
    // await UserIdData().saveUser(UserData['_id']);
    // String pref_data = await UserIdData().getUserId();
    // print("THIS pref_data : $pref_data");
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

// class UserIdData {
//   static const _userKey = 'background_user_data';
//   static const _userSeparator = '-/-/-/';

//   static UserIdData? _instance;
//   UserIdData._();
//   factory UserIdData() => _instance ??= UserIdData._();
//   SharedPreferences? _prefs;

//   Future<SharedPreferences> get prefs async =>
//       _prefs ??= await SharedPreferences.getInstance();

//   Future<void> saveUser(String newId) async {
//     final userIds = newId;
//     final prefs = await this.prefs;
//     await prefs.reload();

//     await (await prefs).setString(_userKey, newId);
//   }

//   Future<String> getUserId() async {
//     final prefs = await this.prefs;
//     await prefs.reload();
//     final userId = prefs.getString(_userKey);
//     if (userId == null) return "63367815762ac8c4a8b291d9";
//     return userId;
//   }

//   Future<void> clear() async => (await prefs).clear();
// }
