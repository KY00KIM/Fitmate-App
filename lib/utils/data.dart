import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

late String IdToken;
late String UserId;
//late String FirebasePlatform = "Facebook";

String baseUrl = "https://fitmate.co.kr/v1/";
late Map UserData = {
  "success": true,
  "message": "",
  "data": {
    "_id": "",
    "user_name": "",
    "user_address": "",
    "user_nickname": "",
    "user_email": "",
    "user_profile_img": "",
    "user_schedule_time": 0,
    "user_weekday": {
      "mon": false,
      "tue": false,
      "wed": false,
      "thu": false,
      "fri": false,
      "sat": false,
      "sun": false
    },
    "user_introduce": "",
    "user_fitness_part": [
      ""
    ],
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
      "device_token": [
        ""
      ],
      "firebase_info": {}
    },
    "is_deleted": false,
    "createdAt": "",
    "updatedAt": ""
  }
};


// ignore: non_constant_identifier_names
Future<bool> UpdateUserData() async {
  http.Response response = await http.get(Uri.parse("https://fitmate.co.kr/v1/users/${UserId.toString()}"), headers: {
    // ignore: unnecessary_string_interpolations
    "Authorization" : "${IdToken.toString()}",
    "Content-Type" : "application/json; charset=UTF-8",
    "userId" : "${UserId.toString()}"});
  if (response.statusCode == 200) {
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    print('status code : ${response.statusCode}');
    print('resBody : $resBody');
    
    UserData = resBody;
    print("return true");
    return true;
  } else {
    print("return false");
    return false;
  }
  
  
}


void FlutterToastTop(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

void FlutterToastBottom(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0
  );
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
