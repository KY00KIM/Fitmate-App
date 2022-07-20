// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/screens/home.dart';
import 'package:fitmate/screens/login.dart';
import 'package:fitmate/screens/matching.dart';
import 'package:fitmate/screens/profile.dart';
import 'package:fitmate/screens/profileEdit.dart';
import 'package:fitmate/screens/signup.dart';
import 'package:fitmate/screens/test.dart';
import 'package:fitmate/screens/writing.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'package:fitmate/screens/writeCenter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  /*
  print("서버 통신 시작");
  //String url = "http://fitmate.co.kr:8000/v1/users/oauth/";
  String url = "https://dapi.kakao.com/v2/local/search/keyword.json?size=15&sort=accuracy&query=YB휘트니스";
  var body = jsonEncode({
    "user_nickname": "우민",
    "user_gender" : true,
    "user_weekday" : {
      "fri":  true
    },
    "user_schedule_time": 0,
    "user_address" : "서울특별시 강남구 송정동 상무대로 312",
    "user_latitude" : 35.142905,
    "user_longitude": 126.800562,
    "fitness_center" : {
      "center_name":"무야호짐",
      "center_address":"서울시 강남구 구의로 579 B104호",
      "center_latitude": 123.5,
      "center_longitude": 123.2334
    },
    "name": "김보석",
    "picture": "https://graph.facebook.com/1626030847797342/picture",
    "iss": "https://securetoken.google.com/fitmate-cf118",
    "aud": "fitmate-cf118",
    "auth_time": 1657436473,
    "user_id": "q6KlqMtj18NFpWHvOB2tQs24PvM2",
    "sub": "q6KlqMtj18NFpWHvOB2tQs24PvM2",
    "iat": 1657436473,
    "exp": 1657440073,
    "email": "hihi@gmail.com",
    "email_verified": false,
    "firebase": {
      "identities": { "facebook.com": [], "email": [] },
      "sign_in_provider": "google.com"
    },
    "uid": "q6KlqMtj18NFpWHvOB2tQs24PvM2"
  });

  http.Response response = await http.get(Uri.parse(url), headers:{"Authorization": "KakaoAK 281e3d7d678f26ad3b6020d8fc517852"});
  print('서버 통신 완료');
  print("status : ${response.statusCode}");
  print("response : ${response.body}");

   */

  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'FitMate',
        home: AnimatedSplashScreen(
        splash: Image.asset('assets/images/fitmate_logo.png'),
        nextScreen: StreamBuilder (
          stream:FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            /*
            if (snapshot.hasData) {
              print("user hasData");
              return HomePage();
            } else {
              print("user login page");
              return LoginPage();
            }
            */

            return HomePage();
          },
        ),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: const Color(0xff22232A),
        duration: 1,
      ),
    );
  }
}
