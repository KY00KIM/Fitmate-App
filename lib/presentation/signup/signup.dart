import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/presentation/post/post.dart';
import 'package:fitmate/presentation/write_center.dart';
import 'package:fitmate/presentation/write_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitmate/ui/bar_widget.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;
import '../../domain/util.dart';
import '../../ui/show_toast.dart';
import '../home/home.dart';

class SignupPage1 extends StatefulWidget {
  const SignupPage1({Key? key}) : super(key: key);

  @override
  State<SignupPage1> createState() => _SignupPageState1();
}

class _SignupPageState1 extends State<SignupPage1> {
  final barWidget = BarWidget();

  bool gender = true;
  String nickname = '';
  final isSelectedSex = <bool>[false, false];
  Map isSelectedWeekDay = {
    "mon": false,
    "tue": false,
    "wed": false,
    "thu": false,
    "fri": false,
    "sat": false,
    "sun": false
  };
  final isSelectedTime = <bool>[false, false, false];
  String location = '동네 입력';
  String centerName = '센터 등록';
  late Map center;
  double latitude = 0;
  double longitude = 0;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  void createUserInFirestore() {
    users
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .limit(1)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          users.add({
            'name': UserData['user_name'],
            'uid': FirebaseAuth.instance.currentUser?.uid
          });
        }
      },
    ).catchError((error) {});
  }

  void SignPost() async {
    int schedule = 0;
    bool gender = true; //남자면 true, 여자면 false

    if (isSelectedTime[1]) {
      schedule = 1;
    } else if (isSelectedTime[2]) {
      schedule = 2;
    }

    if (isSelectedSex[1]) gender = false;

    LocationPermission permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      latitude = 0;
      longitude = 0;
    } else {
      Position position = await DeterminePosition();
      latitude = position.latitude;
      longitude = position.longitude;
    }

    final fcmToken = await FirebaseMessaging.instance.getToken();

    String? deviceToken = await FirebaseMessaging.instance.getToken();

    Map data = {
      "user_nickname": "$nickname",
      "user_address": "$location",
      "user_schedule_time": schedule,
      "user_weekday": {
        "mon": isSelectedWeekDay['mon'],
        "tue": isSelectedWeekDay['tue'],
        "wed": isSelectedWeekDay['wed'],
        "thu": isSelectedWeekDay['thu'],
        "fri": isSelectedWeekDay['fri'],
        "sat": isSelectedWeekDay['sat'],
        "sun": isSelectedWeekDay['sun']
      },
      "user_gender": gender,
      "user_longitude": 0,
      "user_latitude": 0,
      "fitness_center": {
        "center_name": "$centerName",
        "center_address": "${center['address_name']}",
        "fitness_longitude": center['y'],
        "fitness_latitude": center['x']
      },
      "device_token": "$deviceToken"
      /*
      "social" : {
        "device_token" : [
          "$deviceToken"
        ]
      }
       */
    };
    log(deviceToken!);
    var body = json.encode(data);
    log(data.toString());

    http.Response response =
        await http.post(Uri.parse("https://fitmate.co.kr/v1/users/oauth"),
            headers: {
              "Authorization": "bearer $IdToken",
              "Content-Type": "application/json; charset=UTF-8"
            },
            body: body);
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    print(response.statusCode);
    if (response.statusCode == 201) {
      UserId = resBody['data']['_id'];
      bool userdata = await UpdateUserData();
      print(userdata);
      if (userdata == true) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                HomePage(reload: true),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      } else {
        FlutterToastTop("알수 없는 에러가 발생하였습니다");
      }
    } else if (resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();

      http.Response response =
          await http.post(Uri.parse("${baseUrl}users/oauth"),
              headers: {
                'Authorization': 'bearer $IdToken',
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: body);
      var resBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 201) {
        UserId = resBody['data']['_id'];
        bool userdata = await UpdateUserData();

        if (userdata == true) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  HomePage(reload: true),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        } else {
          FlutterToastTop("알수 없는 에러가 발생하였습니다");
        }
      } else {
        FlutterToastTop("알수 없는 에러가 발생하였습니다");
      }
    } else {
      FlutterToastTop("알수 없는 에러가 발생하였습니다");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //widget.idToken;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: barWidget.nextBackAppBar(context),
        backgroundColor: const Color(0xffF2F3F7),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '회원가입',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff6e7995),
                      fontSize: 25.0,
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    '기본정보',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  Text("계정",
                      style: TextStyle(
                          color: Color(0xff6E7995),
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.5),
                  Container(
                    height: 52,
                    decoration: inset.BoxDecoration(
                      color: const Color(0xffd1d9e6),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                          width: 1.0, color: const Color(0xffffffff)),
                      boxShadow: const [
                        inset.BoxShadow(
                          offset: Offset(-20, -20),
                          blurRadius: 60,
                          color: Color.fromARGB(255, 192, 200, 212),
                          inset: true,
                        ),
                        inset.BoxShadow(
                          offset: Offset(3, 3),
                          blurRadius: 6,
                          spreadRadius: 1,
                          color: Color.fromARGB(255, 169, 176, 189),
                          inset: true,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("abcd@gmail.com",
                              style: TextStyle(
                                color: Color(0xff6E7995),
                                fontSize: 15,
                              )),
                          Text("카카오계정",
                              style: TextStyle(
                                color: Color(0xff6E7995),
                                fontSize: 15,
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 23.5,
                  ),
                  Text("닉네임",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff6E7995))),
                  SizedBox(height: 13.5),
                  Container(
                    height: 52,
                    decoration: inset.BoxDecoration(
                      color: const Color(0xffEFEFEF),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                          width: 1.0, color: const Color(0xffffffff)),
                      boxShadow: const [
                        inset.BoxShadow(
                          offset: Offset(-30, -30),
                          blurRadius: 100,
                          color: Color.fromARGB(0, 46, 46, 191),
                          inset: true,
                        ),
                        inset.BoxShadow(
                          offset: Offset(3, 3),
                          blurRadius: 6,
                          spreadRadius: 1,
                          color: Color.fromARGB(255, 169, 176, 189),
                          inset: true,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new Flexible(
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: '닉네임',
                                hintStyle: TextStyle(
                                  color: Color(0xffD1D9E6),
                                ),
                                labelStyle: TextStyle(color: Color(0xff878E97)),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                primary: Color(
                                    0xff3F51B5), // set the background color
                                textStyle: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                            child: Text(
                              "중복확인",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "성별",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(
                        0xff6E7995,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: ListTile(
                              title: const Text(
                                '남',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff6E7995)),
                              ),
                              leading: Radio<bool>(
                                value: true,
                                groupValue: gender,
                                onChanged: (bool? value) {
                                  setState(() {
                                    gender = value!;
                                    print("selectedSex is $gender");
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text(
                              '여',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff6E7995)),
                            ),
                            leading: Radio<bool>(
                              value: true,
                              groupValue: gender,
                              onChanged: (bool? value) {
                                setState(() {
                                  gender = value!;
                                  print("selectedSex is $gender");
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 150)
                      ]),
                  SizedBox(height: 33),
                  Text("한줄 소개",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff6E7995))),
                  SizedBox(height: 12),
                  Container(
                      height: 100,
                      decoration: inset.BoxDecoration(
                        color: const Color(0xffEFEFEF),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            width: 1.0, color: const Color(0xffffffff)),
                        boxShadow: const [
                          inset.BoxShadow(
                            offset: Offset(-30, -30),
                            blurRadius: 100,
                            color: Color.fromARGB(0, 46, 46, 191),
                            inset: true,
                          ),
                          inset.BoxShadow(
                            offset: Offset(3, 3),
                            blurRadius: 6,
                            spreadRadius: 1,
                            color: Color.fromARGB(255, 169, 176, 189),
                            inset: true,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.transparent,
                            filled: true,
                            hintText: '40자 이내',
                            hintStyle: TextStyle(
                              color: Color(0xffD1D9E6),
                            ),
                            labelStyle: TextStyle(color: Color(0xff878E97)),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
