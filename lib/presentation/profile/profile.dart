import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/presentation/profile_edit/profile_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import '../../domain/instance_preference/location.dart';
import '../../domain/util.dart';

import '../../data/firebase_service/firebase_auth_methods.dart';
import '../../domain/util.dart';
import '../../ui/bar_widget.dart';
import '../login/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> reviewName = [];
  List<String> reviewImg = [];
  List<String> reviewContext = [];
  final barWidget = BarWidget();

  String getSchedule() {
    if (UserData["user_schedule_time"] == 0)
      return "오전";
    else if (UserData["user_schedule_time"] == 1)
      return "오후";
    else
      return "저녁";
  }

  @override
  void initState() {
    super.initState();
  }

  Future<int> getReviewProfile() async {
    http.Response response = await http.get(
      Uri.parse("${baseUrlV1}reviews/${UserData['_id']}"),
      headers: {
        "Authorization": "bearer $IdToken",
        "userId": "${UserData['_id']}"
      },
    );
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200 &&
        resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();

      response = await http.get(
        Uri.parse("${baseUrlV1}reviews/${UserData['_id']}"),
        headers: {
          "Authorization": "bearer $IdToken",
          "userId": "${UserData['_id']}"
        },
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }
    for (int i = 0; i < resBody['data'].length; i++) {
      reviewContext.add(resBody['data'][i]['review_body']);
      reviewImg.add(resBody["data"][i]["review_send_id"]['user_profile_img']);
      reviewName.add(resBody['data'][i]['review_send_id']['user_nickname']);
    }

    print("반환 준비 : ${response.statusCode}");
    if (response.statusCode == 200) {
      print("반환 갑니다잉");
      return resBody["data"].length;
    } else {
      print("what the fuck");
      throw Exception('Failed to load post');
    }
  }

  /*
  
            iconSize: 30,
            color: Color(0xFF22232A),
            shape: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF757575),
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            elevation: 40,
            onSelected: (value) async {
              if (value == '/edit')
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileEditPage()));
              else if (value == '/logout') {
                print('로그아웃');
                locator.pauseListener();

                await FirebaseAuthMethods(FirebaseAuth.instance).signOut();
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        LoginPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              } else if (value == '/signout') {
                CollectionReference users =
                    FirebaseFirestore.instance.collection('users');
                users.doc(UserData['social']['user_id']).delete();
                User? user = FirebaseAuth.instance.currentUser;
                user?.delete();
                locator.pauseListener();
                http.Response response = await http.delete(
                  Uri.parse("${baseUrlV1}users"),
                  headers: {
                    "Authorization": "bearer $IdToken",
                  },
                );
                var resBody = jsonDecode(utf8.decode(response.bodyBytes));
                if (response.statusCode != 200 &&
                    resBody["error"]["code"] == "auth/id-token-expired") {
                  IdToken = (await FirebaseAuth.instance.currentUser
                          ?.getIdTokenResult(true))!
                      .token
                      .toString();

                  response = await http.delete(
                    Uri.parse("${baseUrlV1}users"),
                    headers: {
                      "Authorization": "bearer $IdToken",
                    },
                  );
                  resBody = jsonDecode(utf8.decode(response.bodyBytes));
                }

                await FirebaseAuthMethods(FirebaseAuth.instance).signOut();
                // Firebase 로그아웃
                //await _auth.signOut();
                //await _googleSignIn.signOut();

                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        LoginPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              }
            },
            itemBuilder: (BuildContext bc) {
              return [
                PopupMenuItem(
                  child: Text(
                    '수정하기',
                    style: TextStyle(
                      color: Color(0xFFffffff),
                    ),
                  ),
                  value: '/edit',
                ),
                PopupMenuItem(
                  child: Text(
                    '로그아웃',
                    style: TextStyle(
                      color: Color(0xFFffffff),
                    ),
                  ),
                  value: '/logout',
                ),
                PopupMenuItem(
                  child: Text(
                    '회원탈퇴',
                    style: TextStyle(
                      color: Color(0xFFffffff),
                    ),
                  ),
                  value: '/signout',
                ),
              ];
            },
          ),
  
   */

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    log(UserData.toString());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffF2F3F7),
      appBar: barWidget.appBar(context),
      bottomNavigationBar: barWidget.bottomNavigationBar(context, 5),
      body: SafeArea(
        child: FutureBuilder<int>(
          future: getReviewProfile(),
          builder: (context, snapshot) {
            print('snapshot data : ${snapshot.hasData}');
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'assets/icon/profIcon.png',
                            width: 24,
                            height: 24,
                            fit: BoxFit.fill,
                          ),
                          Text(
                            "내 정보",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 100,
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xFFF2F3F7),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFffffff),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: Offset(-2, -2),
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(55, 84, 170, 0.1),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Theme(
                              data: ThemeData(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  "assets/icon/writeProfile.svg",
                                  width: 18,
                                  height: 18,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xFFF2F3F7),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFffffff),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: Offset(-2, -2),
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(55, 84, 170, 0.1),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Theme(
                              data: ThemeData(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  'assets/icon/noProfileIcon.svg',
                                  width: 18,
                                  height: 18,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text('나쁜 녀석들',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          width: double.infinity,
                          height: 108,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFF2F3F7),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFffffff),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(-2, -2),
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(55, 84, 170, 0.1),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
                              child: Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          "한줄소개",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    SingleChildScrollView(
                                      child: Text(
                                        "운동 뉴비입니다. 같이 운동할 친구 사귀고 싶어요! 반갑습니다.aaaaaaaaaaaaaaaaaaaaaaaaa",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff6E7995)),
                                        maxLines: 5,
                                      ),
                                    )
                                  ],
                                ),
                              ))),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                          width: double.infinity,
                          height: 175,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFF2F3F7),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFffffff),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(-2, -2),
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(55, 84, 170, 0.1),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "기본정보",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 0.16), // shadow color
                                          ),
                                          const BoxShadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 6,
                                            color: Color(0xFFfFfFfF),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icon/profileLocationIcon.svg',
                                        width: 12,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text(
                                      "우리동네",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6E7995)),
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(9, 2, 10, 1),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xFF00C6FB),
                                                Color(0xFF005BEA)
                                              ])),
                                      child: Text(
                                        "서울특별시 송파구 석촌1동",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFFFFFFF)),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 17),
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 0.16), // shadow color
                                          ),
                                          const BoxShadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 6,
                                            color: Color(0xFFfFfFfF),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icon/dumbellProfileIcon.svg',
                                        width: 12,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text(
                                      "내 피트니스장",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6E7995)),
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(9, 2, 10, 1),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xFF00C6FB),
                                                Color(0xFF005BEA)
                                              ])),
                                      child: Text(
                                        "아크로짐 구의점",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFFFFFFF)),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 17),
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 0.16), // shadow color
                                          ),
                                          const BoxShadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 6,
                                            color: Color(0xFFfFfFfF),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icon/matchingProfileIcon.svg',
                                        width: 12,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text(
                                      "매칭 수",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6E7995)),
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(9, 2, 10, 1),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xFF00C6FB),
                                                Color(0xFF005BEA)
                                              ])),
                                      child: Text(
                                        "3 회",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFFFFFFF)),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                          width: double.infinity,
                          height: 95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFF2F3F7),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFffffff),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(-2, -2),
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(55, 84, 170, 0.1),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "기본 루틴",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 0.16), // shadow color
                                          ),
                                          const BoxShadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 6,
                                            color: Color(0xFFfFfFfF),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icon/weekdayProfileIcon.svg',
                                        width: 12,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text(
                                      "운동 요일",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6E7995)),
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xFF00C6FB),
                                                Color(0xFF005BEA)
                                              ])),
                                      child: Text(
                                        "화",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFFFFFFF)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xFF00C6FB),
                                                Color(0xFF005BEA)
                                              ])),
                                      child: Text(
                                        "목",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFFFFFFF)),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 32,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icon/reviewProfileIcon.svg",
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "메이트 리뷰",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xFFF2F3F7),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFffffff),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: Offset(-2, -2),
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(55, 84, 170, 0.1),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Theme(
                              data: ThemeData(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  "assets/icon/right_arrow_icon.svg",
                                  width: 18,
                                  height: 18,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(20, 24, 20, 20),
                          width: double.infinity,
                          height: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFF2F3F7),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFffffff),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(-2, -2),
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(55, 84, 170, 0.1),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "총 평점",
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Color(0xff6E7995),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      "리뷰 46",
                                      style: TextStyle(
                                          color: Color(0xff6E7995),
                                          fontSize: 16),
                                    ),
                                    Spacer(),
                                    Text(
                                      "3.5",
                                      style: TextStyle(
                                          color: Color(0xffF27F22),
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ]),
                              SizedBox(
                                height: 21,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 8,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromRGBO(
                                              0, 0, 0, 0.16), // shadow color
                                        ),
                                        const BoxShadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 6,
                                          color: Color(0xFFEFEFEF),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Container(
                                      width: 120,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Color(0xFF00C6FB),
                                              Color(0xFF005BEA)
                                            ]),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "12",
                                    style: TextStyle(
                                      color: Color(0xff6E7995),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "별로에요",
                                    style: TextStyle(
                                        color: Color(0xff6E7995),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 21,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 8,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromRGBO(
                                              0, 0, 0, 0.16), // shadow color
                                        ),
                                        const BoxShadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 6,
                                          color: Color(0xFFEFEFEF),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Container(
                                      width: 120,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Color(0xFF00C6FB),
                                              Color(0xFF005BEA)
                                            ]),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "12",
                                    style: TextStyle(
                                      color: Color(0xff6E7995),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "별로에요",
                                    style: TextStyle(
                                        color: Color(0xff6E7995),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 21,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 8,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromRGBO(
                                              0, 0, 0, 0.16), // shadow color
                                        ),
                                        const BoxShadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 6,
                                          color: Color(0xFFEFEFEF),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Container(
                                      width: 120,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Color(0xFF00C6FB),
                                              Color(0xFF005BEA)
                                            ]),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "12",
                                    style: TextStyle(
                                      color: Color(0xff6E7995),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "별로에요",
                                    style: TextStyle(
                                        color: Color(0xff6E7995),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 21,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 8,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromRGBO(
                                              0, 0, 0, 0.16), // shadow color
                                        ),
                                        const BoxShadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 6,
                                          color: Color(0xFFEFEFEF),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Container(
                                      width: 120,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Color(0xFF00C6FB),
                                              Color(0xFF005BEA)
                                            ]),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "12",
                                    style: TextStyle(
                                      color: Color(0xff6E7995),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "별로에요",
                                    style: TextStyle(
                                        color: Color(0xff6E7995),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 21,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 8,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromRGBO(
                                              0, 0, 0, 0.16), // shadow color
                                        ),
                                        const BoxShadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 6,
                                          color: Color(0xFFEFEFEF),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Container(
                                      width: 120,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Color(0xFF00C6FB),
                                              Color(0xFF005BEA)
                                            ]),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "12",
                                    style: TextStyle(
                                      color: Color(0xff6E7995),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "별로에요",
                                    style: TextStyle(
                                        color: Color(0xff6E7995),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          )),
                      SizedBox(
                        height: 34,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icon/settingsProfileIcon.png',
                            width: 24,
                            height: 24,
                            fit: BoxFit.scaleDown,
                          ),
                          Text(
                            "설정",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 100,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          width: double.infinity,
                          height: 64,
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFF2F3F7),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFffffff),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(-2, -2),
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(55, 84, 170, 0.1),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text("버전",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff6E7995))),
                              Spacer(),
                              new SizedBox(
                                  height: 18.0,
                                  width: 18.0,
                                  child: new IconButton(
                                    padding: new EdgeInsets.all(0.0),
                                    color: Color(0xFFF2F3F7),
                                    icon: SvgPicture.asset(
                                      "assets/icon/right_arrow_icon.svg",
                                      width: 16,
                                      height: 16,
                                    ),
                                    onPressed: () {},
                                  ))
                            ],
                          )),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                          width: double.infinity,
                          height: 64,
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFF2F3F7),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFffffff),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(-2, -2),
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(55, 84, 170, 0.1),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text("이용약관",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff6E7995))),
                              Spacer(),
                              new SizedBox(
                                  height: 18.0,
                                  width: 18.0,
                                  child: new IconButton(
                                    padding: new EdgeInsets.all(0.0),
                                    color: Color(0xFFF2F3F7),
                                    icon: SvgPicture.asset(
                                      "assets/icon/right_arrow_icon.svg",
                                      width: 16,
                                      height: 16,
                                    ),
                                    onPressed: () {},
                                  ))
                            ],
                          )),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                          width: double.infinity,
                          height: 64,
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xFFF2F3F7),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFffffff),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(-2, -2),
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(55, 84, 170, 0.1),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text("로그아웃",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff6E7995))),
                              Spacer(),
                              new SizedBox(
                                  height: 18.0,
                                  width: 18.0,
                                  child: new IconButton(
                                    padding: new EdgeInsets.all(0.0),
                                    color: Color(0xFFF2F3F7),
                                    icon: SvgPicture.asset(
                                      "assets/icon/right_arrow_icon.svg",
                                      width: 16,
                                      height: 16,
                                    ),
                                    onPressed: () {},
                                  ))
                            ],
                          )),
                      SizedBox(height: 32),
                      TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                            textStyle: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "회원탈퇴",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Color(0xFF3F51B5)),
                          )),
                      Container(
                        width: size.width - 34,
                        padding: EdgeInsets.all(0),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Container(
                                    width: size.width - 40,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF2F3F7),
                                      border: Border.all(
                                          width: 1, color: Colors.black),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 55,
                                        ),
                                        Text(
                                          '${UserData["user_nickname"]}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          '${UserData["user_gender"] == true ? '남' : '여'} · ${UserData["user_address"]}',
                                          style: TextStyle(
                                            color: Color(0xFFA4A5A8),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        UserData['user_introduce'] == null
                                            ? SizedBox(
                                                height: 10,
                                              )
                                            : SizedBox(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Container(
                                                      width: size.width - 80,
                                                      child: Text(
                                                          '${UserData['user_introduce']}',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.network(
                                  '${UserData['user_profile_img']}',
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Image.asset(
                                      'assets/images/profile_null_image.png',
                                      width: 70.0,
                                      height: 70.0,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              right: 18,
                              top: 60,
                              child: ClipOval(
                                child: Material(
                                  color: Colors.blue, // button color
                                  child: InkWell(
                                    splashColor: Colors.red, // inkwell color
                                    child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileEditPage()));
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: size.width - 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              ' 기본 정보',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: size.width - 40,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Color(0xFF292A2E),
                          border:
                              Border.all(width: 1, color: Color(0xFF5A595C)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(22, 15, 22, 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.fitness_center,
                                          color: Color(0xFF2975CF),
                                          size: 17,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          '내 피트니스장',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${UserCenterName}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFffffff),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.groups,
                                          color: Color(0xFF2975CF),
                                          size: 17,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          '매칭 수',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${snapshot.data.toString()}회',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFffffff),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_pin,
                                          color: Color(0xFF2975CF),
                                          size: 17,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          '운동 시간대',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${getSchedule()}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFffffff),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: size.width - 80,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: UserData["user_weekday"]
                                                    ["mon"] ==
                                                true
                                            ? Color(0xFF2975CF)
                                            : Color(0xFF22232A),
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                          width: 1,
                                          color: UserData["user_weekday"]
                                                      ["mon"] ==
                                                  true
                                              ? Color(0xFF2975CF)
                                              : Color(0xFF878E97),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '월',
                                        style: TextStyle(
                                            color: UserData["user_weekday"]
                                                        ["mon"] ==
                                                    true
                                                ? Color(0xFFffffff)
                                                : Color(0xFF878E97),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: UserData["user_weekday"]
                                                    ["tue"] ==
                                                true
                                            ? Color(0xFF2975CF)
                                            : Color(0xFF22232A),
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                          width: 1,
                                          color: UserData["user_weekday"]
                                                      ["tue"] ==
                                                  true
                                              ? Color(0xFF2975CF)
                                              : Color(0xFF878E97),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '화',
                                        style: TextStyle(
                                            color: UserData["user_weekday"]
                                                        ["tue"] ==
                                                    true
                                                ? Color(0xFFffffff)
                                                : Color(0xFF878E97),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: UserData["user_weekday"]
                                                    ["wed"] ==
                                                true
                                            ? Color(0xFF2975CF)
                                            : Color(0xFF22232A),
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                          width: 1,
                                          color: UserData["user_weekday"]
                                                      ["wed"] ==
                                                  true
                                              ? Color(0xFF2975CF)
                                              : Color(0xFF878E97),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '수',
                                        style: TextStyle(
                                            color: UserData["user_weekday"]
                                                        ["wed"] ==
                                                    true
                                                ? Color(0xFFffffff)
                                                : Color(0xFF878E97),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: UserData["user_weekday"]
                                                    ["thu"] ==
                                                true
                                            ? Color(0xFF2975CF)
                                            : Color(0xFF22232A),
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                          width: 1,
                                          color: UserData["user_weekday"]
                                                      ["thu"] ==
                                                  true
                                              ? Color(0xFF2975CF)
                                              : Color(0xFF878E97),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '목',
                                        style: TextStyle(
                                            color: UserData["user_weekday"]
                                                        ["thu"] ==
                                                    true
                                                ? Color(0xFFffffff)
                                                : Color(0xFF878E97),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: UserData["user_weekday"]
                                                    ["fri"] ==
                                                true
                                            ? Color(0xFF2975CF)
                                            : Color(0xFF22232A),
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                          width: 1,
                                          color: UserData["user_weekday"]
                                                      ["fri"] ==
                                                  true
                                              ? Color(0xFF2975CF)
                                              : Color(0xFF878E97),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '금',
                                        style: TextStyle(
                                            color: UserData["user_weekday"]
                                                        ["fri"] ==
                                                    true
                                                ? Color(0xFFffffff)
                                                : Color(0xFF878E97),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: UserData["user_weekday"]
                                                    ["sat"] ==
                                                true
                                            ? Color(0xFF2975CF)
                                            : Color(0xFF22232A),
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                          width: 1,
                                          color: UserData["user_weekday"]
                                                      ["sat"] ==
                                                  true
                                              ? Color(0xFF2975CF)
                                              : Color(0xFF878E97),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '토',
                                        style: TextStyle(
                                            color: UserData["user_weekday"]
                                                        ["sat"] ==
                                                    true
                                                ? Color(0xFFffffff)
                                                : Color(0xFF878E97),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: UserData["user_weekday"]
                                                    ["sun"] ==
                                                true
                                            ? Color(0xFF2975CF)
                                            : Color(0xFF22232A),
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                          width: 1,
                                          color: UserData["user_weekday"]
                                                      ["sun"] ==
                                                  true
                                              ? Color(0xFF2975CF)
                                              : Color(0xFF878E97),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '일',
                                        style: TextStyle(
                                            color: UserData["user_weekday"]
                                                        ["sun"] ==
                                                    true
                                                ? Color(0xFFffffff)
                                                : Color(0xFF878E97),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: size.width - 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              ' 메이트 리뷰',
                              style: TextStyle(
                                color: Color(0xFFffffff),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      snapshot.data == 0
                          ? SizedBox()
                          : Container(
                              width: size.width - 40,
                              decoration: BoxDecoration(
                                color: Color(0xFF292A2E),
                                border: Border.all(
                                    width: 1, color: Color(0xFF5A595C)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 8, 15, 8),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: size.width - 40,
                                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: Image.network(
                                                  '${reviewImg[index]}',
                                                  width: 35.0,
                                                  height: 35.0,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    return Image.asset(
                                                      'assets/images/profile_null_image.png',
                                                      fit: BoxFit.cover,
                                                      width: 35.0,
                                                      height: 35.0,
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Text(
                                                '${reviewName[index]}',
                                                style: TextStyle(
                                                  color: Color(0xFFffffff),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 45),
                                            child: Container(
                                              width: size.width - 85,
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: RichText(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 100,
                                                      strutStyle: StrutStyle(
                                                          fontSize: 16),
                                                      text: TextSpan(
                                                        text:
                                                            '${reviewContext[index]}',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return SizedBox();
            }
            // 기본적으로 로딩 Spinner를 보여줍니다.
            //return Center(child: CircularProgressIndicator());
            return SizedBox();
          },
        ),
      ),
    );
  }
}
