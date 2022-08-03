// ignore_for_file: unnecessary_null_comparison, avoid_print, duplicate_ignore


import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/screens/home.dart';
import 'package:fitmate/screens/login.dart';
import 'package:fitmate/screens/profile.dart';
import 'package:fitmate/screens/review.dart';
import 'package:fitmate/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:fitmate/utils/data.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'firebase_service/firebase_auth_methods.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fitmate/utils/data.dart';
import 'dart:convert';
import 'dart:developer';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  //User? tokenResult = await FirebaseAuth.instance.currentUser;
  //var idToken = await tokenResult?.getIdToken();
  //print("id token : $idToken");  

  initializeDateFormatting().then((_) => runApp(const MyApp()));

  /*
  http.Response response = await http.post(Uri.parse("https://fitmate.co.kr/v1/posts"),
      headers: {"Authorization" : "$IdToken", "Content-Type": "application/json; charset=UTF-8"},
      body: body
  );
  var resBody = jsonDecode(utf8.decode(response.bodyBytes));
  */

  //IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();
  //print("token : $IdToken");

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  
  Future<bool> getToken() async {

    // ignore: await_only_futures
    
    User? tokenResult = await FirebaseAuth.instance.currentUser;
    //log(tokenResult.toString());
    if(tokenResult == null) return true;
    // ignore: unused_local_variable
    var idToken = await tokenResult.getIdToken();
    //log(idToken.toString());
    
    // ignore: avoid_print
    //print("idToken : $idToken");
    //if(idToken == null) return true;
    IdToken = idToken.toString();
    
    http.Response response = await http.get(Uri.parse("${baseUrl}users/login"), headers: {
      'Authorization' : 'bearer $IdToken'});
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    UserId = resBody['data']['user_id'];


    bool userdata = await UpdateUserData();

    // ignore: unrelated_type_equality_checks

    return IdToken == null || UserId == null || userdata == false;
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitMate',
      // ignore: unrelated_type_equality_checks, prefer_const_constructors
      //home: getToken() == true ? LoginPage() : HomePage(),
      home: FutureBuilder(
        future: getToken(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          if (snapshot.hasData == false) {
            return Center(child: CircularProgressIndicator());
          }
          //error가 발생하게 될 경우 반환하게 되는 부분
          else if (snapshot.hasError) {
            print("error");
            return LoginPage();
          }
          // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
          else {
            print("값 받아옴 : ${snapshot.hasData}");
            // ignore: avoid_print
            print(snapshot.hasData);
            return snapshot.hasData == true ? LoginPage() : HomePage();
          }

          //return SignupPage();
        },
      ),
    );
  }
}

class $ {
}

class $idToken {
}



/*
// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:fitmate/screens/matching.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/events_example.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TableCalendar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            ElevatedButton(
              child: Text('Events'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TableEventsExample()),
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: Text('매칭 페이지'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MatchingPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 */