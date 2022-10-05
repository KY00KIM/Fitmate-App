import 'dart:developer';

import 'package:fitmate/ui/bar_widget.dart';
import 'package:fitmate/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../../../domain/model/SignupUser.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../domain/instance_preference/location.dart';

import '../../../data/signup_api.dart';
import 'dart:core';

class signUpViewModel {
  late SignUpApi signupApi = SignUpApi();

  late locationController locator;

  late SignupUser userdata;

  Future sendSignUp() async {
    locator = locationController();
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    await locator.init();
    // Map location = await locator.getAndSendLocation(null);
    Map<String, dynamic> json = {
      "user_nickname": nickname == null ? "" : nickname,
      "user_introduce": introduce,
      'user_address': "$selectedLocation $selectedSemiLocation",
      'user_schedule_time': selectedTime,
      "user_gender": gender,
      "user_weekday": isSelectedWeekDay,
      "user_longitude": 0.0,
      "user_latitude": 0.0,
      "survey_candidates": Survey,
      "device_token": deviceToken ?? "",
      "fitness_center_id": centerName == "피트니스 센터를 검색"
          ? "631d65a35c8fcf2a7116f0d7"
          : center["id"]
      // "fitness_center": {
      //   "center_name": centerName == "피트니스 센터를 검색" ? "선택안함" : centerName,
      //   "center_address":
      //       centerName == "피트니스 센터를 검색" ? "" : center['address_name'],
      //   "fitness_longitude":
      //       centerName == "피트니스 센터를 검색" ? 0.0 : double.parse(center['y']),
      //   "fitness_latitude":
      //       centerName == "피트니스 센터를 검색" ? 0.0 : double.parse(center['x'])
      // }
    };
    log("userdata json ready : ${json.toString()}");
    userdata = SignupUser.fromJson(json);
    var result = await signupApi.postSignUpUser(userdata);
    print("oauth response : $result");
    return result["success"];
  }

  Future<bool> checkValidNickname(String input) async {
    bool result = await signupApi.checkNickname(input);
    print("result is $result");
    isNicknameValid = result;
    // nickname = input;
    return result;
  }

  Map<String, String> socialProvider = {
    "google.com": "구글 계정",
    "custom": "카카오 계정",
    "apple.com": "애플 계정",
  };
  /**
   * @회원가입 1페이지 파라미터
   */
  bool isNicknameValid = false;
  String? nickname;
  bool gender = true;
  String introduce = '';

  /**
   * @회원가입 2페이지 파라미터
   */
  int selectedTime = -1;
  String selectedStartTime = '시간 선택';
  String selectedEndTime = '시간 선택';
  String? selectedLocation;
  String? selectedSemiLocation;
  String centerName = '피트니스 센터를 검색';
  late Map center;

  /**
   * @회원가입 3페이지 파라미터
   */
  List Survey = [];

/**
 * @운동 시간 관련 함수
 */
  String selectTime(int i) {
    int temp = i ~/ 10;
    if (temp == 0)
      return '0${i}';
    else
      return '${i}';
  }

  final Map<String, int> timeToInt = {"오전": 0, "오후": 1, "저녁": 2};

  /**
   * @요일 관련 데이터
   */

  Map<String, dynamic> isSelectedWeekDay = {
    "mon": false,
    "tue": false,
    "wed": false,
    "thu": false,
    "fri": false,
    "sat": false,
    "sun": false
  };
  final List<String> weekdayKor = ["월", "화", "수", "목", "금", "토", "일"];
  final Map weekdayToEng = {
    "월": "mon",
    "화": "tue",
    "수": "wed",
    "목": "thu",
    "금": "fri",
    "토": "sat",
    "일": "sun"
  };

  /**
   * @설문조사 관련 데이터
   */

  final List SurveyKorList = [
    "마른것보다 근성장을 선호해요",
    "누군가에게 동기부여를 주는 몸을 갖고 싶어요",
    "스스로 도전하는 삶을 지향해요",
    "즐거운 삶은 건강한 몸에서 나온다고 생각해요",
    "미래의 건강을 위해서 꾸준한 운동이 중요해요",
    "혼자하기 어려운 운동을 같이 해보고 싶어요",
    "같이 운동할 때 더 성장하는 것 같아요",
    "새로운 사람들과 함께 다양한 운동을 하고 싶어요",
    "몰랐던 루틴이나 식단을 함께 공유하고 싶어요",
    "어제보다 오늘 더 가벼워지고 싶어요",
    "중량이 늘 때, 더 성장하는 것 같아요",
    "부상없이, 안전하게 운동하고 싶어요",
  ];
  Map<String, dynamic> isSelectedSurveyKor = {
    "633a75c0ad5ad46e4d0f81dd" : false,
    "633a75c0ad5ad46e4d0f81df" : false,
    "633a75c0ad5ad46e4d0f81e1" : false,
    "633a75c0ad5ad46e4d0f81e3" : false,
    "633a75c0ad5ad46e4d0f81e5" : false,
    "633a75c0ad5ad46e4d0f81e7" : false,
    "633a75c0ad5ad46e4d0f81e9" : false,
    "633a75c0ad5ad46e4d0f81eb" : false,
    "633a75c0ad5ad46e4d0f81ed" : false,
    "633a75c0ad5ad46e4d0f81ef" : false,
    "633a75c0ad5ad46e4d0f81f1" : false,
    "633a75c0ad5ad46e4d0f81f3" : false
  };
  final Map SurveyKorId = {
    "마른것보다 근성장을 선호해요" : "633a75c0ad5ad46e4d0f81dd",
    "누군가에게 동기부여를 주는 몸을 갖고 싶어요" : "633a75c0ad5ad46e4d0f81df",
    "스스로 도전하는 삶을 지향해요" : "633a75c0ad5ad46e4d0f81e1",
    "즐거운 삶은 건강한 몸에서 나온다고 생각해요" : "633a75c0ad5ad46e4d0f81e3",
    "미래의 건강을 위해서 꾸준한 운동이 중요해요" : "633a75c0ad5ad46e4d0f81e5",
    "혼자하기 어려운 운동을 같이 해보고 싶어요" : "633a75c0ad5ad46e4d0f81e7",
    "같이 운동할 때 더 성장하는 것 같아요" : "633a75c0ad5ad46e4d0f81e9",
    "새로운 사람들과 함께 다양한 운동을 하고 싶어요" : "633a75c0ad5ad46e4d0f81eb",
    "몰랐던 루틴이나 식단을 함께 공유하고 싶어요" : "633a75c0ad5ad46e4d0f81ed",
    "어제보다 오늘 더 가벼워지고 싶어요" : "633a75c0ad5ad46e4d0f81ef",
    "중량이 늘 때, 더 성장하는 것 같아요" : "633a75c0ad5ad46e4d0f81f1",
    "부상없이, 안전하게 운동하고 싶어요" : "633a75c0ad5ad46e4d0f81f3"
  };

  /**
   * @지역 데이터
   */
  Map<String, List<String>> locationMap = {
    "서울특별시": [
      "종로구",
      "중구",
      "용산구",
      "성동구",
      "광진구",
      "동대문구",
      "중랑구",
      "성북구",
      "강북구",
      "도봉구",
      "노원구",
      "은평구",
      "서대문구",
      "마포구",
      "양천구",
      "강서구",
      "구로구",
      "금천구",
      "영등포구",
      "동작구",
      "관악구",
      "서초구",
      "강남구",
      "송파구",
      "강동구"
    ],
    "부산광역시": [
      "중구",
      "서구",
      "동구",
      "영도구",
      "부산진구",
      "동래구",
      "남구",
      "북구",
      "강서구",
      "해운대구",
      "사하구",
      "금정구",
      "연제구",
      "수영구",
      "사상구",
      "기장군"
    ],
    "대구광역시": ["중구", "동구", "서구", "남구", "북구", "수성구", "달서구", "달성군"],
    "인청광역시": [
      "중구",
      "동구",
      "미추홀구",
      "연수구",
      "남동구",
      "부평구",
      "계양구",
      "서구",
      "강화군",
      "옹진군"
    ],
    "광주광역시": ["동구", "서구", "남구", "북구", "광산구"],
    "대전광역시": ["동구", "중구", "서구", "유성구", "대덕구"],
    "울산광역시": ["중구", "남구", "동구", "북구", "울주군"],
    "세종특별자치시": [""],
    "경기도": [
      "수원시",
      "성남시",
      "의정부시",
      "안양시",
      "부천시",
      "광명시",
      "동두천시",
      "평택시",
      "안산시",
      "고양시",
      "과천시",
      "구리시",
      "남양주시",
      "오산시",
      "시흥시",
      "군포시",
      "의왕시",
      "하남시",
      "용인시",
      "파주시",
      "이천시",
      "안성시",
      "김포시",
      "화성시",
      "광주시",
      "양주시",
      "포천시",
      "여주시",
      "연천군",
      "가평군",
      "양평군"
    ],
    "강원도": [
      "춘천시",
      "원주시",
      "강릉시",
      "동해시",
      "태백시",
      "속초시",
      "삼척시",
      "홍청군",
      "횡성군",
      "영월군",
      "평창군",
      "정선군",
      "철원군",
      "화천군",
      "양구군",
      "인제군",
      "고성군",
      "양양군"
    ],
    "충청북도": [
      "청주시",
      "충주시",
      "제천시",
      "보은군",
      "옥천군",
      "영동군",
      "증평군",
      "진천군",
      "괴산군",
      "음성군",
      "단양군"
    ],
    "충청남도": [
      "천안시",
      "공주시",
      "보령시",
      "아산시",
      "서산시",
      "논산시",
      "계룡시",
      "당진시",
      "금산군",
      "부여군",
      "서천군",
      "청양군",
      "홍성군",
      "예산군",
      "태안군"
    ],
    "전라북도": [
      "전주시",
      "군산시",
      "익산시",
      "정읍시",
      "남원시",
      "김제시",
      "완주군",
      "진안군",
      "무주군",
      "장수군",
      "임실군",
      "순창군",
      "고창군",
      "부안군"
    ],
    "전라남도": [
      "목포시",
      "여수시",
      "순천시",
      "나주시",
      "광양시",
      "담양군",
      "곡성군",
      "구례군",
      "고흥군",
      "보성군",
      "화순군",
      "장흥군",
      "강진군",
      "해남군",
      "영암군",
      "무안군",
      "함평군",
      "영광군",
      "장성군",
      "완도군",
      "진도군",
      "신안군"
    ],
    "경상북도": [
      "포항시",
      "경주시",
      "김천시",
      "안동시",
      "구미시",
      "영주시",
      "영천시",
      "상수시",
      "문경시",
      "경산시",
      "군위군",
      "의성군",
      "청송군",
      "영양군",
      "영덕군",
      "청도군",
      "고령군",
      "성주군",
      "칠곡군",
      "예천군",
      "봉화군",
      "울진군",
      "울릉군"
    ],
    "경상남도": [
      "창원시",
      "진주시",
      "통영시",
      "사천시",
      "김해시",
      "밀양시",
      "거제시",
      "양산시",
      "의령군",
      "함안군",
      "창녕군",
      "고성군",
      "남해군",
      "하동군",
      "산청군",
      "함양군",
      "거창군",
      "합천군"
    ],
    "제주특별자치도": ["제주시", "서귀포시"]
  };
}
