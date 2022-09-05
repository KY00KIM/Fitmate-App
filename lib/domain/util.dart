import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

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

class LoginedUser {
  late String _id;
  late String User_name;
  late String user_address;
}

String UserCenterName = '';
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

// ignore: non_constant_identifier_names
Future<bool> UpdateUserData() async {
  log(IdToken.toString());
  http.Response response = await http
      .get(Uri.parse("${baseUrl}users/${UserId.toString()}"), headers: {
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
            "${baseUrl}fitnesscenters/${UserData["fitness_center_id"].toString()}"),
        headers: {
          // ignore: unnecessary_string_interpolations
          "Authorization": "bearer ${IdToken.toString()}",
          "fitnesscenterId": "${UserData["fitness_center_id"]}"
        });
    log(UserData.toString());
    if (responseFitness.statusCode == 200) {
      var resBody2 = jsonDecode(utf8.decode(responseFitness.bodyBytes));

      UserCenterName = resBody2["data"]["center_name"];
    }
    return true;
  } else {
    print("유저 정보 가져오지 못함");
    return false;
  }
}

Future<Position> DeterminePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}

late String IdToken;
late String UserId;

String baseUrl = "https://fitmate.co.kr/v1/";

final List<String> locationList = [
  '서울특별시 종로구',
  '서울특별시 중구',
  '서울특별시 용산구',
  '서울특별시 성동구',
  '서울특별시 광진구',
  '서울특별시 동대문구',
  '서울특별시 중랑구',
  '서울특별시 성북구',
  '서울특별시 강북구',
  '서울특별시 도봉구',
  '서울특별시 노원구',
  '서울특별시 은평구',
  '서울특별시 서대문구',
  '서울특별시 마포구',
  '서울특별시 양천구',
  '서울특별시 강서구',
  '서울특별시 구로구',
  '서울특별시 금천구',
  '서울특별시 영등포구',
  '서울특별시 동작구',
  '서울특별시 관악구',
  '서울특별시 서초구',
  '서울특별시 강남구',
  '서울특별시 송파구',
  '서울특별시 강동구',
  '부산광역시 중구',
  '부산광역시 서구',
  '부산광역시 동구',
  '부산광역시 영도구',
  '부산광역시 부산진구',
  '부산광역시 동래구',
  '부산광역시 남구',
  '부산광역시 북구',
  '부산광역시 강서구',
  '부산광역시 해운대구',
  '부산광역시 사하구',
  '부산광역시 금정구',
  '부산광역시 연제구',
  '부산광역시 수영구',
  '부산광역시 사상구',
  '부산광역시 기장군',
  '대구광역시 중구',
  '대구광역시 동구',
  '대구광역시 서구',
  '대구광역시 남구',
  '대구광역시 북구',
  '대구광역시 수성구',
  '대구광역시 달서구',
  '대구광역시 달성군',
  '인청광역시 중구',
  '인청광역시 동구',
  '인청광역시 미추홀구',
  '인청광역시 연수구',
  '인청광역시 남동구',
  '인청광역시 부평구',
  '인청광역시 계양구',
  '인청광역시 서구',
  '인청광역시 강화군',
  '인청광역시 옹진군',
  '광주광역시 동구',
  '광주광역시 서구',
  '광주광역시 남구',
  '광주광역시 북구',
  '광주광역시 광산구',
  '대전광역시 동구',
  '대전광역시 중구',
  '대전광역시 서구',
  '대전광역시 유성구',
  '대전광역시 대덕구',
  '울산광역시 중구',
  '울산광역시 남구',
  '울산광역시 동구',
  '울산광역시 북구',
  '울산광역시 울주군',
  '세종특별자치시',
  '경기도 수원시',
  '경기도 성남시',
  '경기도 의정부시',
  '경기도 안양시',
  '경기도 부천시',
  '경기도 광명시',
  '경기도 동두천시',
  '경기도 평택시',
  '경기도 안산시',
  '경기도 고양시',
  '경기도 과천시',
  '경기도 구리시',
  '경기도 남양주시',
  '경기도 오산시',
  '경기도 시흥시',
  '경기도 군포시',
  '경기도 의왕시',
  '경기도 하남시',
  '경기도 용인시',
  '경기도 파주시',
  '경기도 이천시',
  '경기도 안성시',
  '경기도 김포시',
  '경기도 화성시',
  '경기도 광주시',
  '경기도 양주시',
  '경기도 포천시',
  '경기도 여주시',
  '경기도 연천군',
  '경기도 가평군',
  '경기도 양평군',
  '강원도 춘천시',
  '강원도 원주시',
  '강원도 강릉시',
  '강원도 동해시',
  '강원도 태백시',
  '강원도 속초시',
  '강원도 삼척시',
  '강원도 홍청군',
  '강원도 횡성군',
  '강원도 영월군',
  '강원도 평창군',
  '강원도 정선군',
  '강원도 철원군',
  '강원도 화천군',
  '강원도 양구군',
  '강원도 인제군',
  '강원도 고성군',
  '강원도 양양군',
  '충청북도 청주시',
  '충청북도 충주시',
  '충청북도 제천시',
  '충청북도 보은군',
  '충청북도 옥천군',
  '충청북도 영동군',
  '충청북도 증평군',
  '충청북도 진천군',
  '충청북도 괴산군',
  '충청북도 음성군',
  '충청북도 단양군',
  '충청남도 천안시',
  '충청남도 공주시',
  '충청남도 보령시',
  '충청남도 아산시',
  '충청남도 서산시',
  '충청남도 논산시',
  '충청남도 계룡시',
  '충청남도 당진시',
  '충청남도 금산군',
  '충청남도 부여군',
  '충청남도 서천군',
  '충청남도 청양군',
  '충청남도 홍성군',
  '충청남도 예산군',
  '충청남도 태안군',
  '전라북도 전주시',
  '전라북도 군산시',
  '전라북도 익산시',
  '전라북도 정읍시',
  '전라북도 남원시',
  '전라북도 김제시',
  '전라북도 완주군',
  '전라북도 진안군',
  '전라북도 무주군',
  '전라북도 장수군',
  '전라북도 임실군',
  '전라북도 순창군',
  '전라북도 고창군',
  '전라북도 부안군',
  '전라남도 목포시',
  '전라남도 여수시',
  '전라남도 순천시',
  '전라남도 나주시',
  '전라남도 광양시',
  '전라남도 담양군',
  '전라남도 곡성군',
  '전라남도 구례군',
  '전라남도 고흥군',
  '전라남도 보성군',
  '전라남도 화순군',
  '전라남도 장흥군',
  '전라남도 강진군',
  '전라남도 해남군',
  '전라남도 영암군',
  '전라남도 무안군',
  '전라남도 함평군',
  '전라남도 영광군',
  '전라남도 장성군',
  '전라남도 완도군',
  '전라남도 진도군',
  '전라남도 신안군',
  '경상북도 포항시',
  '경상북도 경주시',
  '경상북도 김천시',
  '경상북도 안동시',
  '경상북도 구미시',
  '경상북도 영주시',
  '경상북도 영천시',
  '경상북도 상수시',
  '경상북도 문경시',
  '경상북도 경산시',
  '경상북도 군위군',
  '경상북도 의성군',
  '경상북도 청송군',
  '경상북도 영양군',
  '경상북도 영덕군',
  '경상북도 청도군',
  '경상북도 고령군',
  '경상북도 성주군',
  '경상북도 칠곡군',
  '경상북도 예천군',
  '경상북도 봉화군',
  '경상북도 울진군',
  '경상북도 울릉군',
  '경상남도 창원시',
  '경상남도 진주시',
  '경상남도 통영시',
  '경상남도 사천시',
  '경상남도 김해시',
  '경상남도 밀양시',
  '경상남도 거제시',
  '경상남도 양산시',
  '경상남도 의령군',
  '경상남도 함안군',
  '경상남도 창녕군',
  '경상남도 고성군',
  '경상남도 남해군',
  '경상남도 하동군',
  '경상남도 산청군',
  '경상남도 함양군',
  '경상남도 거창군',
  '경상남도 합천군',
  '제주특별자치도 제주시',
  '제주특별자치도 서귀포시'
];
