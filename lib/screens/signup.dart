import 'dart:convert';
import 'dart:developer';
//import 'dart:developer';
//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/screens/login.dart';
import 'package:fitmate/screens/writeCenter.dart';
import 'package:fitmate/screens/writeLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

import '../firebase_service/firebase_auth_methods.dart';
import '../utils/data.dart';
import 'home.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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

    Position position = await DeterminePosition();
    double latitude = position.latitude;
    double longitude = position.longitude;

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
      "user_longitude": longitude,
      "user_latitude": latitude,
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
    //log(IdToken);
    //if (IdToken != null)IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();

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
            pageBuilder: (context, animation, secondaryAnimation) => HomePage(reload : true),
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
              pageBuilder: (context, animation, secondaryAnimation) => HomePage(reload : true),
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
        backgroundColor: const Color(0xff22232A),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '회원가입',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.0),
                  child: Text(
                    '프로필',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width - 165,
                      height: 45,
                      child: TextField(
                        onChanged: (value) {
                          nickname = value;
                        },
                        style: TextStyle(color: Color(0xff878E97)),
                        decoration: InputDecoration(
                          hintText: '닉네임',
                          contentPadding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                          hintStyle: TextStyle(
                            color: Color(0xff878E97),
                          ),
                          labelStyle: TextStyle(color: Color(0xff878E97)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                            borderSide:
                                BorderSide(width: 1, color: Color(0xff878E97)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                            borderSide:
                                BorderSide(width: 1, color: Color(0xff878E97)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 110,
                      height: 45,
                      margin: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Color(0xFF878E97),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      ),
                      child: Center(
                        child: ToggleButtons(
                          color: Color(0xFF878E97),
                          selectedColor: Color(0xFFffffff),
                          //selectedBorderColor: Color(0xFF6200EE),
                          fillColor: Color(0xFF22232A).withOpacity(0.08),
                          splashColor: Color(0xFF22232A).withOpacity(0.12),
                          //hoverColor: Color(0xFF6200EE).withOpacity(0.04),
                          borderColor: Color(0xFF22232A),
                          borderRadius: BorderRadius.circular(4.0),
                          renderBorder: false,
                          constraints: BoxConstraints(minHeight: 36.0),
                          isSelected: isSelectedSex,
                          onPressed: (index) {
                            // Respond to button selection
                            setState(() {
                              if (!isSelectedSex[0] & !isSelectedSex[1]) {
                                isSelectedSex[index] = !isSelectedSex[index];
                              } else {
                                isSelectedSex[index] = !isSelectedSex[index];
                                isSelectedSex[index == 1 ? 0 : 1] =
                                    !isSelectedSex[index == 1 ? 1 : 0];
                              }
                            });
                          },
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                '남',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: isSelectedSex[0] == true
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                '여',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: isSelectedSex[1] == true
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '운동 스케쥴',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14.0),
                        ),
                        Container(
                          width: 150,
                          height: 25,
                          margin: EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Color(0xFF878E97),
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                          ),
                          child: Center(
                            child: ToggleButtons(
                              color: Color(0xFF878E97),
                              selectedColor: Color(0xFFffffff),
                              //selectedBorderColor: Color(0xFF6200EE),
                              fillColor: Color(0xFF22232A).withOpacity(0.08),
                              splashColor: Color(0xFF22232A).withOpacity(0.12),
                              //hoverColor: Color(0xFF6200EE).withOpacity(0.04),
                              borderColor: Color(0xFF22232A),
                              borderRadius: BorderRadius.circular(4.0),
                              renderBorder: false,
                              constraints: BoxConstraints(minHeight: 36.0),
                              isSelected: isSelectedTime,
                              onPressed: (index) {
                                // Respond to button selection
                                setState(() {
                                  if (isSelectedTime[index]) {
                                  } else if (!isSelectedTime[0] &
                                      !isSelectedTime[1] &
                                      !isSelectedTime[2]) {
                                    isSelectedTime[index] =
                                        !isSelectedTime[index];
                                  } else {
                                    isSelectedTime[index] =
                                        !isSelectedTime[index];
                                    if (index == 0) {
                                      isSelectedTime[1] = false;
                                      isSelectedTime[2] = false;
                                    } else if (index == 1) {
                                      isSelectedTime[0] = false;
                                      isSelectedTime[2] = false;
                                    } else if (index == 2) {
                                      isSelectedTime[1] = false;
                                      isSelectedTime[0] = false;
                                    }
                                  }
                                });
                              },
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    '오전',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelectedTime[0] == true
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    '오후',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelectedTime[1] == true
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    '저녁',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelectedTime[2] == true
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '월',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay['mon'] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay['mon'] =
                                !isSelectedWeekDay['mon'];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(40, 40),
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.only(right: 0),
                          shape: const CircleBorder(),
                          primary: isSelectedWeekDay['mon'] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay['mon'] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '화',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["tue"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["tue"] =
                                !isSelectedWeekDay["tue"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.only(right: 0),
                          fixedSize: const Size(40, 40),
                          shape: const CircleBorder(),
                          primary: isSelectedWeekDay["tue"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["tue"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '수',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["wed"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["wed"] =
                                !isSelectedWeekDay["wed"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.only(right: 0),
                          fixedSize: const Size(40, 40),
                          shape: const CircleBorder(),
                          primary: isSelectedWeekDay["wed"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["wed"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '목',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["thu"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["thu"] =
                                !isSelectedWeekDay["thu"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.only(right: 0),
                          fixedSize: const Size(40, 40),
                          shape: const CircleBorder(),
                          primary: isSelectedWeekDay["thu"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["thu"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '금',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["fri"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["fri"] =
                                !isSelectedWeekDay["fri"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.only(right: 0),
                          fixedSize: const Size(40, 40),
                          shape: const CircleBorder(),
                          primary: isSelectedWeekDay["fri"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["fri"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '토',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["sat"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["sat"] =
                                !isSelectedWeekDay["sat"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.only(right: 0),
                          fixedSize: const Size(40, 40),
                          shape: const CircleBorder(),
                          primary: isSelectedWeekDay["sat"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["sat"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '일',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["sun"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["sun"] =
                                !isSelectedWeekDay["sun"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.only(right: 0),
                          fixedSize: const Size(40, 40),
                          shape: const CircleBorder(),
                          primary: isSelectedWeekDay["sun"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["sun"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.0),
                  child: Text(
                    '지역 등록',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14.0),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: Color(0xFF878E97),
                            size: 17.0,
                          ),
                          Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              strutStyle: StrutStyle(fontSize: 15),
                              text: TextSpan(
                                text: ' $location',
                                style: TextStyle(
                                  color: Color(0xFF878E97),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        primary: Color(0xFF22232A),
                        shape: RoundedRectangleBorder(
                          // 테두리를 라운드하게 만들기
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        side: BorderSide(
                          width: 1.0,
                          color: Color(0xFF878E97),
                        ),
                        minimumSize: Size((size.width - 55) / 2, 45),
                        maximumSize: Size((size.width - 55) / 2, 45),
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WriteLocationPage()),
                        ).then((onValue) {
                          onValue == null
                              ? null
                              : setState(() {
                                  location = onValue;
                                });
                        });
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                      child: Row(
                        children: [
                          Icon(
                            Icons.fitness_center,
                            color: Color(0xFF878E97),
                            size: 17.0,
                          ),
                          Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              strutStyle: StrutStyle(fontSize: 15),
                              text: TextSpan(
                                text: ' $centerName',
                                style: TextStyle(
                                  color: Color(0xFF878E97),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        primary: Color(0xFF22232A),
                        shape: RoundedRectangleBorder(
                          // 테두리를 라운드하게 만들기
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        side: BorderSide(
                          width: 1.0,
                          color: Color(0xFF878E97),
                        ),
                        minimumSize: Size((size.width - 55) / 2, 45),
                        maximumSize: Size((size.width - 55) / 2, 45),
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WriteCenterPage()),
                        ).then((onValue) {
                          onValue == null
                              ? null
                              : setState(() {
                                  center = onValue;
                                  centerName = onValue['place_name'];
                                });
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: nickname == '' ||
                            isSelectedSex[0] == false &&
                                isSelectedSex[1] == false ||
                            isSelectedTime[0] == false &&
                                isSelectedTime[1] == false &&
                                isSelectedTime[2] == false ||
                            isSelectedWeekDay[0] == false &&
                                isSelectedWeekDay[1] == false &&
                                isSelectedWeekDay[2] == false &&
                                isSelectedWeekDay[3] == false &&
                                isSelectedWeekDay[4] == false &&
                                isSelectedWeekDay[5] == false &&
                                isSelectedWeekDay[6] == false ||
                            location == '동네 입력'
                        ? Color(0xFF878E97)
                        : Color(0xFF3889D1),
                    minimumSize: Size(size.width - 40, 45),
                  ),
                  onPressed: () {
                    createUserInFirestore();
                    nickname == '' ||
                            isSelectedSex[0] == false &&
                                isSelectedSex[1] == false ||
                            isSelectedTime[0] == false &&
                                isSelectedTime[1] == false &&
                                isSelectedTime[2] == false ||
                            isSelectedWeekDay[0] == false &&
                                isSelectedWeekDay[1] == false &&
                                isSelectedWeekDay[2] == false &&
                                isSelectedWeekDay[3] == false &&
                                isSelectedWeekDay[4] == false &&
                                isSelectedWeekDay[5] == false &&
                                isSelectedWeekDay[6] == false ||
                            location == '동네 입력'
                        ? FlutterToastBottom("센터 등록 외의 모든 항목을 입력하여주세요")
                        : SignPost();
                  },
                  child: Text(
                    '가입하기',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
