import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/presentation/profile/profile_edit.dart';
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
import '../review/review_list.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> reviewName = [];
  List<String> reviewImg = [];
  List<String> reviewContext = [];
  List reviewData = [];
  final barWidget = BarWidget();
  int point = 0;
  int reviewTotal = 0;
  Map reviewPoint = {
    "62c66ead4b8212e4674dbe1f": 0,
    "62c66ef64b8212e4674dbe20": 0,
    "62c66f0b4b8212e4674dbe21": 0,
    "62c66f224b8212e4674dbe22": 0,
    "62dbb2e126e97374cf97aec7": 0,
    "62dbb2fb26e97374cf97aec8": 0,
    "62dbb30f26e97374cf97aec9": 0
  };

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
    log(IdToken);
  }

  Future<int> getReviewProfile() async {
    point = 0;
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
    print("2");

    reviewData = resBody['data'];

    for (int i = 0; i < resBody['data'].length; i++) {
      point += reviewData[i]['user_rating'] as int;
      reviewContext.add(resBody['data'][i]['review_body']);
      reviewImg.add(resBody["data"][i]["review_send_id"]['user_profile_img']);
      reviewName.add(resBody['data'][i]['review_send_id']['user_nickname']);
      for (int j = 0; j < reviewData[i]['review_candidates'].length; j++) {
        reviewTotal += 1;

        reviewPoint[reviewData[i]['review_candidates'][j]["_id"]] += 1;
      }
    }
    print("3");
    print("reviewData.length : ${reviewData.length}");
    print("point : ${point}");

    if (reviewData.length != 0) {
      point = point ~/ reviewData.length;
    }

    print("4");

    print("review data : $reviewData");

    if (response.statusCode == 200) {
      return resBody["data"].length;
    } else {
      print("error loading review : ${resBody}");
      throw Exception('Failed to load post');
    }
  }

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
              return ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    width: size.width,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/icon/profIcon.png',
                              width: 24,
                              height: 24,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              "내 정보",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
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
                                    "assets/icon/writeProfile.svg",
                                    width: 18,
                                    height: 18,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileEditPage()));
                                  },
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
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: CachedNetworkImageProvider(
                                    '${UserData['user_profile_img']}',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text('${UserData["user_nickname"]}',
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
                            child: Column(
                              children: [
                                Expanded(
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
                                        child: UserData['user_introduce'] == "" ||
                                            UserData['user_introduce'] == null
                                            ? SizedBox(
                                          height: 10,
                                        )
                                            : Text(
                                          "${UserData['user_introduce']}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff6E7995)),
                                          maxLines: 5,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          width: double.infinity,
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
                                          fontSize: 12, color: Color(0xFF6E7995), fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(9, 2, 10, 1),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xFF00C6FB),
                                                Color(0xFF005BEA)
                                              ])),
                                      child: Text(
                                        "${UserData["user_address"]}",
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
                                      "피트니스 센터",
                                      style: TextStyle(
                                          fontSize: 12, color: Color(0xFF6E7995), fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(9, 2, 10, 1),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xFF00C6FB),
                                                Color(0xFF005BEA)
                                              ])),
                                      child: Text(
                                        "${UserCenterName}",
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
                                          fontSize: 12, color: Color(0xFF6E7995), fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(9, 2, 10, 1),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xFF00C6FB),
                                                Color(0xFF005BEA)
                                              ])),
                                      child: Text(
                                        "${snapshot.data.toString()} 회",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFFFFFFF)),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          width: double.infinity,
                          //height: 95,
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
                                          fontSize: 12, color: Color(0xFF6E7995), fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    Row(
                                      children: userWeekdayList
                                          .map((item) => Container(
                                        margin: EdgeInsets.fromLTRB(
                                            2, 0, 2, 0),
                                        padding: EdgeInsets.fromLTRB(
                                            4, 2, 4, 2),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(50),
                                            gradient: LinearGradient(
                                                begin:
                                                Alignment.topCenter,
                                                end: Alignment
                                                    .bottomCenter,
                                                colors: [
                                                  Color(0xFF00C6FB),
                                                  Color(0xFF005BEA)
                                                ])),
                                        child: Text(
                                          "${weekdayEngToKor[item]}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFFFFFFFF)),
                                        ),
                                      ))
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ReviewListPage(
                                              reviewData: reviewData,
                                              title: '메이트',
                                              profileImg: reviewImg,
                                              nickName: reviewName)),
                                    );
                                  },
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
                            //height: 280,
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
                                        "리뷰 ${reviewData.length}",
                                        style: TextStyle(
                                            color: Color(0xff6E7995),
                                            fontSize: 16),
                                      ),
                                      Spacer(),
                                      Text(
                                        "${point}.0",
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
                                    Stack(children: [
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
                                      ),
                                      Container(
                                        width: reviewTotal == 0
                                            ? 0
                                            : (120 / reviewTotal) *
                                            (reviewPoint[
                                            '62c66ead4b8212e4674dbe1f'] +
                                                reviewPoint[
                                                '62c66ef64b8212e4674dbe20']),
                                        height: 8,
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
                                    ]),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "${(reviewPoint['62c66ead4b8212e4674dbe1f'] + reviewPoint['62c66ef64b8212e4674dbe20']).toString()}",
                                      style: TextStyle(
                                        color: Color(0xff6E7995),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "매너있고 친절해요",
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
                                    Stack(children: [
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
                                      ),
                                      Container(
                                        width: reviewTotal == 0
                                            ? 0
                                            : (120 / reviewTotal) *
                                            (reviewPoint[
                                            '62c66f224b8212e4674dbe22']),
                                        height: 8,
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
                                    ]),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "${reviewPoint['62c66f224b8212e4674dbe22'].toString()}",
                                      style: TextStyle(
                                        color: Color(0xff6E7995),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "열정적이에요",
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
                                    Stack(children: [
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
                                      ),
                                      Container(
                                        width: reviewTotal == 0
                                            ? 0
                                            : (120 / reviewTotal) *
                                            (reviewPoint[
                                            '62dbb30f26e97374cf97aec9'] +
                                                reviewPoint[
                                                "62dbb2fb26e97374cf97aec8"]),
                                        height: 8,
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
                                    ]),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "${(reviewPoint['62dbb30f26e97374cf97aec9'] + reviewPoint["62dbb2fb26e97374cf97aec8"]).toString()}",
                                      style: TextStyle(
                                        color: Color(0xff6E7995),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "운동을 잘 알려줘요",
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
                                    Stack(children: [
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
                                      ),
                                      Container(
                                        width: reviewTotal == 0
                                            ? 0
                                            : (120 / reviewTotal) *
                                            (reviewPoint[
                                            '62dbb2e126e97374cf97aec7']),
                                        height: 8,
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
                                    ]),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "${reviewPoint['62dbb2e126e97374cf97aec7'].toString()}",
                                      style: TextStyle(
                                        color: Color(0xff6E7995),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "응답이 빨라요",
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
                                    Stack(children: [
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
                                      ),
                                      Container(
                                        width: reviewTotal == 0
                                            ? 0
                                            : (120 / reviewTotal) *
                                            (reviewPoint[
                                            '62c66f0b4b8212e4674dbe21']),
                                        height: 8,
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
                                    ]),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "${reviewPoint['62c66f0b4b8212e4674dbe21'].toString()}",
                                      style: TextStyle(
                                        color: Color(0xff6E7995),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "약속을 잘 지켜요",
                                      style: TextStyle(
                                          color: Color(0xff6E7995),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
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
                            SizedBox(width: 12,),
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
                                        color: Color(0xff6E7995),
                                        fontWeight: FontWeight.bold)),
                                Spacer(),
                                Text(
                                  "ver_${version}",
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xff6E7995), fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
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
                        GestureDetector(
                          onTap: () async {
                            print('로그아웃');
                            locator.pauseListener();

                            await FirebaseAuthMethods(
                                FirebaseAuth
                                    .instance)
                                .signOut();
                            Navigator
                                .pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context,
                                    animation,
                                    secondaryAnimation) =>
                                    LoginPage(),
                                transitionDuration:
                                Duration.zero,
                                reverseTransitionDuration:
                                Duration.zero,
                              ),
                            );
                          },
                          child: Container(
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
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              barrierDismissible:
                                              true, // 바깥 영역 터치시 닫을지 여부
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text("로그아웃 하시겠습니까?",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                  insetPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      50, 80, 20, 80),
                                                  actions: [
                                                    Container(
                                                      margin: EdgeInsets.fromLTRB(
                                                          0, 0, 0, 10),
                                                      width: 40,
                                                      height: 32,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                        color: Color(0xFFF2F3F7),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                            Color(0xFFffffff),
                                                            spreadRadius: 2,
                                                            blurRadius: 8,
                                                            offset: Offset(-2, -2),
                                                          ),
                                                          BoxShadow(
                                                            color: Color.fromRGBO(
                                                                55, 84, 170, 0.1),
                                                            spreadRadius: 2,
                                                            blurRadius: 2,
                                                            offset: Offset(2, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Theme(
                                                        data: ThemeData(
                                                          splashColor:
                                                          Colors.transparent,
                                                          highlightColor:
                                                          Colors.transparent,
                                                        ),
                                                        child: TextButton(
                                                          child: Text(
                                                            "확인",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.black,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          onPressed: () async {
                                                            print('로그아웃');
                                                            locator.pauseListener();

                                                            await FirebaseAuthMethods(
                                                                FirebaseAuth
                                                                    .instance)
                                                                .signOut();
                                                            Navigator
                                                                .pushReplacement(
                                                              context,
                                                              PageRouteBuilder(
                                                                pageBuilder: (context,
                                                                    animation,
                                                                    secondaryAnimation) =>
                                                                    LoginPage(),
                                                                transitionDuration:
                                                                Duration.zero,
                                                                reverseTransitionDuration:
                                                                Duration.zero,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.fromLTRB(
                                                          0, 0, 20, 10),
                                                      width: 60,
                                                      height: 32,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                        color: Color(0xFFF2F3F7),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                            Color(0xFFffffff),
                                                            spreadRadius: 2,
                                                            blurRadius: 8,
                                                            offset: Offset(-2, -2),
                                                          ),
                                                          BoxShadow(
                                                            color: Color.fromRGBO(
                                                                55, 84, 170, 0.1),
                                                            spreadRadius: 2,
                                                            blurRadius: 2,
                                                            offset: Offset(2, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Theme(
                                                        data: ThemeData(
                                                          splashColor:
                                                          Colors.transparent,
                                                          highlightColor:
                                                          Colors.transparent,
                                                        ),
                                                        child: TextButton(
                                                          child: Text(
                                                            '아니오',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.black,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                      ))
                                ],
                              )),
                        ),
                        SizedBox(height: 32),
                        TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.black,
                              textStyle: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text("회원탈퇴 하시겠습니까?",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      insetPadding: const EdgeInsets.fromLTRB(
                                          50, 80, 20, 80),
                                      actions: [
                                        Container(
                                          margin:
                                          EdgeInsets.fromLTRB(0, 0, 0, 10),
                                          width: 40,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            color: Color(0xFFF2F3F7),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xFFffffff),
                                                spreadRadius: 2,
                                                blurRadius: 8,
                                                offset: Offset(-2, -2),
                                              ),
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                    55, 84, 170, 0.1),
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
                                            child: TextButton(
                                              child: Text(
                                                "확인",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              onPressed: () async {
                                                CollectionReference users =
                                                FirebaseFirestore.instance
                                                    .collection('users');
                                                users
                                                    .doc(UserData['social']
                                                ['user_id'])
                                                    .delete();
                                                User? user = FirebaseAuth
                                                    .instance.currentUser;
                                                user?.delete();
                                                locator.pauseListener();
                                                http.Response response =
                                                await http.delete(
                                                  Uri.parse("${baseUrlV1}users"),
                                                  headers: {
                                                    "Authorization":
                                                    "bearer $IdToken",
                                                  },
                                                );
                                                var resBody = jsonDecode(utf8
                                                    .decode(response.bodyBytes));
                                                if (response.statusCode != 200 &&
                                                    resBody["error"]["code"] ==
                                                        "auth/id-token-expired") {
                                                  IdToken = (await FirebaseAuth
                                                      .instance.currentUser
                                                      ?.getIdTokenResult(
                                                      true))!
                                                      .token
                                                      .toString();

                                                  response = await http.delete(
                                                    Uri.parse(
                                                        "${baseUrlV1}users"),
                                                    headers: {
                                                      "Authorization":
                                                      "bearer $IdToken",
                                                    },
                                                  );
                                                  resBody = jsonDecode(
                                                      utf8.decode(
                                                          response.bodyBytes));
                                                }

                                                await FirebaseAuthMethods(
                                                    FirebaseAuth.instance)
                                                    .signOut();
                                                // Firebase 로그아웃
                                                //await _auth.signOut();
                                                //await _googleSignIn.signOut();

                                                Navigator.pushReplacement(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) =>
                                                        LoginPage(),
                                                    transitionDuration:
                                                    Duration.zero,
                                                    reverseTransitionDuration:
                                                    Duration.zero,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          margin:
                                          EdgeInsets.fromLTRB(0, 0, 20, 10),
                                          width: 60,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            color: Color(0xFFF2F3F7),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xFFffffff),
                                                spreadRadius: 2,
                                                blurRadius: 8,
                                                offset: Offset(-2, -2),
                                              ),
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                    55, 84, 170, 0.1),
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
                                            child: TextButton(
                                              child: Text(
                                                '아니오',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                              "회원탈퇴",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Color(0xFF3F51B5),
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return SizedBox();
            }
            // 기본적으로 로딩 Spinner를 보여줍니다.
            //return Center(child: CircularProgressIndicator());
            return ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  width: size.width,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'assets/icon/profIcon.png',
                            width: 24,
                            height: 24,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "내 정보",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
                                  "assets/icon/writeProfile.svg",
                                  width: 18,
                                  height: 18,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileEditPage()));
                                },
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
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: CachedNetworkImageProvider(
                                  '${UserData['user_profile_img']}',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text('${UserData["user_nickname"]}',
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
                          child: Column(
                            children: [
                              Expanded(
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
                                      child: UserData['user_introduce'] == "" ||
                                          UserData['user_introduce'] == null
                                          ? SizedBox(
                                        height: 10,
                                      )
                                          : Text(
                                        "${UserData['user_introduce']}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff6E7995)),
                                        maxLines: 5,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: double.infinity,
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
                                        fontSize: 12, color: Color(0xFF6E7995), fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(9, 2, 10, 1),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xFF00C6FB),
                                              Color(0xFF005BEA)
                                            ])),
                                    child: Text(
                                      "${UserData["user_address"]}",
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
                                    "피트니스 센터",
                                    style: TextStyle(
                                        fontSize: 12, color: Color(0xFF6E7995), fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(9, 2, 10, 1),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xFF00C6FB),
                                              Color(0xFF005BEA)
                                            ])),
                                    child: Text(
                                      "${UserCenterName}",
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
                                        fontSize: 12, color: Color(0xFF6E7995), fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(9, 2, 10, 1),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xFF00C6FB),
                                              Color(0xFF005BEA)
                                            ])),
                                    child: Text(
                                      "0 회",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFFFFFFFF)),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: double.infinity,
                        //height: 95,
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
                                        fontSize: 12, color: Color(0xFF6E7995), fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: userWeekdayList
                                        .map((item) => Container(
                                      margin: EdgeInsets.fromLTRB(
                                          2, 0, 2, 0),
                                      padding: EdgeInsets.fromLTRB(
                                          4, 2, 4, 2),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(50),
                                          gradient: LinearGradient(
                                              begin:
                                              Alignment.topCenter,
                                              end: Alignment
                                                  .bottomCenter,
                                              colors: [
                                                Color(0xFF00C6FB),
                                                Color(0xFF005BEA)
                                              ])),
                                      child: Text(
                                        "${weekdayEngToKor[item]}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFFFFFFF)),
                                      ),
                                    ))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReviewListPage(
                                            reviewData: reviewData,
                                            title: '메이트',
                                            profileImg: reviewImg,
                                            nickName: reviewName)),
                                  );
                                },
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
                          //height: 280,
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
                                      "리뷰 0",
                                      style: TextStyle(
                                          color: Color(0xff6E7995),
                                          fontSize: 16),
                                    ),
                                    Spacer(),
                                    Text(
                                      "0.0",
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
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "0",
                                    style: TextStyle(
                                      color: Color(0xff6E7995),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "매너있고 친절해요",
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
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "0",
                                    style: TextStyle(
                                      color: Color(0xff6E7995),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "열정적이에요",
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
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "0",
                                    style: TextStyle(
                                      color: Color(0xff6E7995),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "운동을 잘 알려줘요",
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
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "0",
                                    style: TextStyle(
                                      color: Color(0xff6E7995),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "응답이 빨라요",
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
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "0",
                                    style: TextStyle(
                                      color: Color(0xff6E7995),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "약속을 잘 지켜요",
                                    style: TextStyle(
                                        color: Color(0xff6E7995),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
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
                          SizedBox(width: 12,),
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
                                      color: Color(0xff6E7995),
                                      fontWeight: FontWeight.bold)),
                              Spacer(),
                              Text(
                                "ver_${version}",
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xff6E7995), fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
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
                      GestureDetector(
                        onTap: () async {
                          print('로그아웃');
                          locator.pauseListener();

                          await FirebaseAuthMethods(
                              FirebaseAuth
                                  .instance)
                              .signOut();
                          Navigator
                              .pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context,
                                  animation,
                                  secondaryAnimation) =>
                                  LoginPage(),
                              transitionDuration:
                              Duration.zero,
                              reverseTransitionDuration:
                              Duration.zero,
                            ),
                          );
                        },
                        child: Container(
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
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            barrierDismissible:
                                            true, // 바깥 영역 터치시 닫을지 여부
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Text("로그아웃 하시겠습니까?",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.bold)),
                                                insetPadding:
                                                const EdgeInsets.fromLTRB(
                                                    50, 80, 20, 80),
                                                actions: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 0, 0, 10),
                                                    width: 40,
                                                    height: 32,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          8),
                                                      color: Color(0xFFF2F3F7),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                          Color(0xFFffffff),
                                                          spreadRadius: 2,
                                                          blurRadius: 8,
                                                          offset: Offset(-2, -2),
                                                        ),
                                                        BoxShadow(
                                                          color: Color.fromRGBO(
                                                              55, 84, 170, 0.1),
                                                          spreadRadius: 2,
                                                          blurRadius: 2,
                                                          offset: Offset(2, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Theme(
                                                      data: ThemeData(
                                                        splashColor:
                                                        Colors.transparent,
                                                        highlightColor:
                                                        Colors.transparent,
                                                      ),
                                                      child: TextButton(
                                                        child: Text(
                                                          "확인",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.black,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                        onPressed: () async {
                                                          print('로그아웃');
                                                          locator.pauseListener();

                                                          await FirebaseAuthMethods(
                                                              FirebaseAuth
                                                                  .instance)
                                                              .signOut();
                                                          Navigator
                                                              .pushReplacement(
                                                            context,
                                                            PageRouteBuilder(
                                                              pageBuilder: (context,
                                                                  animation,
                                                                  secondaryAnimation) =>
                                                                  LoginPage(),
                                                              transitionDuration:
                                                              Duration.zero,
                                                              reverseTransitionDuration:
                                                              Duration.zero,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 0, 20, 10),
                                                    width: 60,
                                                    height: 32,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          8),
                                                      color: Color(0xFFF2F3F7),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                          Color(0xFFffffff),
                                                          spreadRadius: 2,
                                                          blurRadius: 8,
                                                          offset: Offset(-2, -2),
                                                        ),
                                                        BoxShadow(
                                                          color: Color.fromRGBO(
                                                              55, 84, 170, 0.1),
                                                          spreadRadius: 2,
                                                          blurRadius: 2,
                                                          offset: Offset(2, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Theme(
                                                      data: ThemeData(
                                                        splashColor:
                                                        Colors.transparent,
                                                        highlightColor:
                                                        Colors.transparent,
                                                      ),
                                                      child: TextButton(
                                                        child: Text(
                                                          '아니오',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.black,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ))
                              ],
                            )),
                      ),
                      SizedBox(height: 32),
                      TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                            textStyle: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text("회원탈퇴 하시겠습니까?",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    insetPadding: const EdgeInsets.fromLTRB(
                                        50, 80, 20, 80),
                                    actions: [
                                      Container(
                                        margin:
                                        EdgeInsets.fromLTRB(0, 0, 0, 10),
                                        width: 40,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          color: Color(0xFFF2F3F7),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFFffffff),
                                              spreadRadius: 2,
                                              blurRadius: 8,
                                              offset: Offset(-2, -2),
                                            ),
                                            BoxShadow(
                                              color: Color.fromRGBO(
                                                  55, 84, 170, 0.1),
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
                                          child: TextButton(
                                            child: Text(
                                              "확인",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () async {
                                              CollectionReference users =
                                              FirebaseFirestore.instance
                                                  .collection('users');
                                              users
                                                  .doc(UserData['social']
                                              ['user_id'])
                                                  .delete();
                                              User? user = FirebaseAuth
                                                  .instance.currentUser;
                                              user?.delete();
                                              locator.pauseListener();
                                              http.Response response =
                                              await http.delete(
                                                Uri.parse("${baseUrlV1}users"),
                                                headers: {
                                                  "Authorization":
                                                  "bearer $IdToken",
                                                },
                                              );
                                              var resBody = jsonDecode(utf8
                                                  .decode(response.bodyBytes));
                                              if (response.statusCode != 200 &&
                                                  resBody["error"]["code"] ==
                                                      "auth/id-token-expired") {
                                                IdToken = (await FirebaseAuth
                                                    .instance.currentUser
                                                    ?.getIdTokenResult(
                                                    true))!
                                                    .token
                                                    .toString();

                                                response = await http.delete(
                                                  Uri.parse(
                                                      "${baseUrlV1}users"),
                                                  headers: {
                                                    "Authorization":
                                                    "bearer $IdToken",
                                                  },
                                                );
                                                resBody = jsonDecode(
                                                    utf8.decode(
                                                        response.bodyBytes));
                                              }

                                              await FirebaseAuthMethods(
                                                  FirebaseAuth.instance)
                                                  .signOut();
                                              // Firebase 로그아웃
                                              //await _auth.signOut();
                                              //await _googleSignIn.signOut();

                                              Navigator.pushReplacement(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context,
                                                      animation,
                                                      secondaryAnimation) =>
                                                      LoginPage(),
                                                  transitionDuration:
                                                  Duration.zero,
                                                  reverseTransitionDuration:
                                                  Duration.zero,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        margin:
                                        EdgeInsets.fromLTRB(0, 0, 20, 10),
                                        width: 60,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          color: Color(0xFFF2F3F7),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFFffffff),
                                              spreadRadius: 2,
                                              blurRadius: 8,
                                              offset: Offset(-2, -2),
                                            ),
                                            BoxShadow(
                                              color: Color.fromRGBO(
                                                  55, 84, 170, 0.1),
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
                                          child: TextButton(
                                            child: Text(
                                              '아니오',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "회원탈퇴",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Color(0xFF3F51B5),
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}