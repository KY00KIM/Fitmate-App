import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/presentation/chat/chat.dart';
import 'package:fitmate/presentation/profile/component/otherProfileAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import '../../domain/util.dart';
import '../../ui/show_toast.dart';
import '../review/review_list.dart';

String OtherUserCenterName = '';

class OtherProfilePage extends StatefulWidget {
  String profileId;
  String profileName;
  bool chatButton;

  OtherProfilePage(
      {Key? key,
      required String this.profileId,
      required String this.profileName,
      required bool this.chatButton})
      : super(key: key);

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  BarWidget barWidget = BarWidget();
  String schedule = '';
  String otherFitnessCenter = '';
  int otherMatching = 0;
  late String otherId;
  late String otherName;
  bool imageError = false;
  bool other_certificated = false;

  List<String> reviewName = [];
  List<String> reviewImg = [];
  List<String> reviewContext = [];
  int reviewCount = 0;
  int reviewTotal = 0;
  int point = 0;
  List reviewData = [];

  Map reviewPoint = {
    "62c66ead4b8212e4674dbe1f": 0,
    "62c66ef64b8212e4674dbe20": 0,
    "62c66f0b4b8212e4674dbe21": 0,
    "62c66f224b8212e4674dbe22": 0,
    "62dbb2e126e97374cf97aec7": 0,
    "62dbb2fb26e97374cf97aec8": 0,
    "62dbb30f26e97374cf97aec9": 0
  };

  //int reviewNumber = 0;
  String reportContent = '';
  String chatId = '';

  Future<Map> getOtherProfile() async {
    point = 0;

    print("loading user");
    http.Response response = await http.get(
        Uri.parse("${baseUrlV1}users/${widget.profileId.toString()}"),
        headers: {
          // ignore: unnecessary_string_interpolations
          "Authorization": "bearer $IdToken",
          "Content-Type": "application/json; charset=UTF-8",
          "userId": "${widget.profileId.toString()}"
        });
    var userRes = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode != 200 &&
        userRes["error"]["code"] == "auth/id-token-expired") {
      IdToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();

      http.Response response = await http.get(
          Uri.parse("${baseUrlV1}users/${widget.profileId.toString()}"),
          headers: {
            // ignore: unnecessary_string_interpolations
            "Authorization": "bearer $IdToken",
            "Content-Type": "application/json; charset=UTF-8",
            "userId": "${widget.profileId.toString()}"
          });
      userRes = jsonDecode(utf8.decode(response.bodyBytes));
    }

    otherId = userRes['data']['_id'].toString();
    other_certificated = userRes['data']['is_certificated'];

    if (response.statusCode == 200) {
      print("성공입니다");
      if (userRes['data']['user_schedule_time'] == 0)
        schedule = '오전';
      else if (userRes['data']['user_schedule_time'] == 1)
        schedule = '오후';
      else
        schedule = '저녁';
      otherName = userRes['data']['user_nickname'];

      print("loading fitness-center");
      http.Response responseFitness = await http.get(
          Uri.parse(
              "${baseUrlV1}fitnesscenters/${userRes['data']['fitness_center_id'].toString()}"),
          headers: {
            // ignore: unnecessary_string_interpolations
            "Authorization": "bearer ${IdToken.toString()}",
            "fitnesscenterId":
                "${userRes['data']['fitness_center_id'].toString()}"
          });
      if (responseFitness.statusCode == 200) {
        print("loaded fitness-center");
        var centerRes = jsonDecode(utf8.decode(responseFitness.bodyBytes));
        otherFitnessCenter = centerRes["data"]["center_name"];
      }

      print("loading review");
      http.Response response2 = await http.get(
        Uri.parse("${baseUrlV1}reviews/${otherId}"),
        headers: {
          "Authorization": "bearer $IdToken",
          "userId": "bearer ${otherId}"
        },
      );
      var reviewRes = jsonDecode(utf8.decode(response2.bodyBytes));
      reviewData = reviewRes['data'];

      print("loaded reivew");

      reviewContext.clear();
      reviewImg.clear();
      reviewName.clear();
      print("review res length : ${reviewRes['data'].length}");
      reviewCount = reviewRes['data'].length;

      for (int i = 0; i < reviewRes['data'].length; i++) {
        point += reviewData[i]['user_rating'] as int;

        print("review res body : ${reviewRes['data'][i]['review_body']}");
        reviewContext.add(reviewRes['data'][i]['review_body']);
        reviewImg
            .add(reviewRes["data"][i]["review_send_id"]['user_profile_img']);
        reviewName.add(reviewRes['data'][i]['review_send_id']['user_nickname']);
        for (int j = 0; j < reviewData[i]['review_candidates'].length; j++) {
          reviewTotal += 1;

          reviewPoint[reviewData[i]['review_candidates'][j]["_id"]] += 1;
        }
      }

      if (reviewData.length != 0) {
        point = point ~/ reviewData.length;
      }

      return userRes['data'];
    } else {
      print("앙 실패띠");
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<bool> addChat() async {
    //기존 채팅방이 있는지 확인
    http.Response response = await http.get(
      Uri.parse("${baseUrlV1}chats/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $IdToken',
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
        Uri.parse("${baseUrlV1}chats/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer $IdToken',
        },
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    for (int i = 0; i < resBody['data'].length; i++) {
      if ((resBody['data'][i]['chat_start_id'] == UserData['_id'] &&
              resBody['data'][i]['chat_join_id'] == otherId) ||
          (resBody['data'][i]['chat_join_id'] == UserData['_id'] &&
              resBody['data'][i]['chat_start_id'] == otherId)) {
        //이미 채팅방이 있을 때
        chatId = resBody['data'][i]['_id'];
        return true;
      }
    }

    Map data = {"chat_join_id": "${otherId}"};
    var body = json.encode(data);
    http.Response response2 = await http.post(Uri.parse("${baseUrlV1}chats/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer $IdToken',
        }, // this header is essential to send json data
        body: body);
    var resBody2 = jsonDecode(utf8.decode(response2.bodyBytes));
    print('오우 : ${response.body}');
    if (response.statusCode != 200 &&
        resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();

      response2 = await http.post(Uri.parse("${baseUrlV1}chats/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'bearer $IdToken',
          }, // this header is essential to send json data
          body: body);
      resBody2 = jsonDecode(utf8.decode(response2.bodyBytes));
    }

    if (response2.statusCode == 201) {
      log("log : ${resBody2['data']['_id']}");
      chatId = resBody2['data']['_id'];
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffF2F3F7),
      appBar: barWidget.otherProfileAppBar(context, widget.profileId),
      body: SafeArea(
        child: FutureBuilder<Map>(
          future: getOtherProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            width: size.width - 40,
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Column(
                              children: [
                                Row(
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
                                      "회원 프로필",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
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
                                            color:
                                                Color.fromRGBO(55, 84, 170, 0.1),
                                            spreadRadius: 2,
                                            blurRadius: 2,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                        image: !imageError
                                            ? DecorationImage(
                                                fit: BoxFit.fill,
                                                image: CachedNetworkImageProvider(
                                                  '${snapshot.data!["user_profile_img"]}',
                                                ),
                                                onError: (error, StackTrace? st) {
                                                  print(
                                                      " loading image ${error.toString()}");
                                                  setState(() {
                                                    imageError = true;
                                                  });
                                                },
                                              )
                                            : DecorationImage(
                                                image: AssetImage(
                                                    'assets/icon/noProfileImage.png'),
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text('${otherName}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold))
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
                                            '${snapshot.data!['user_introduce'] == null ? '' : snapshot.data!['user_introduce']}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff6E7995)),
                                            maxLines: 5,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  width: double.infinity,
                                  //height: 175,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color.fromRGBO(
                                                          0,
                                                          0,
                                                          0,
                                                          0.16), // shadow color
                                                    ),
                                                    const BoxShadow(
                                                      offset: Offset(2, 2),
                                                      blurRadius: 6,
                                                      color: Color(0xFFfFfFfF),
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(50),
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
                                            ]),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  9, 2, 10, 1),
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
                                                "${snapshot.data!["user_address"]}",
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
                                                        0,
                                                        0,
                                                        0,
                                                        0.16), // shadow color
                                                  ),
                                                  const BoxShadow(
                                                    offset: Offset(2, 2),
                                                    blurRadius: 6,
                                                    color: Color(0xFFfFfFfF),
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(50),
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
                                                  fontSize: 12,
                                                  color: Color(0xFF6E7995)),
                                            ),
                                            Spacer(),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  9, 2, 10, 1),
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
                                                        0,
                                                        0,
                                                        0,
                                                        0.16), // shadow color
                                                  ),
                                                  const BoxShadow(
                                                    offset: Offset(2, 2),
                                                    blurRadius: 6,
                                                    color: Color(0xFFfFfFfF),
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(50),
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
                                              padding: EdgeInsets.fromLTRB(
                                                  9, 2, 10, 1),
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
                                                "${reviewCount} 회",
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
                                                        0,
                                                        0,
                                                        0,
                                                        0.16), // shadow color
                                                  ),
                                                  const BoxShadow(
                                                    offset: Offset(2, 2),
                                                    blurRadius: 6,
                                                    color: Color(0xFFfFfFfF),
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(50),
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
                                            Row(
                                              children: userWeekdayList
                                                  .map((item) => Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                2, 0, 2, 0),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                4, 2, 4, 2),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(50),
                                                            gradient: LinearGradient(
                                                                begin: Alignment
                                                                    .topCenter,
                                                                end: Alignment
                                                                    .bottomCenter,
                                                                colors: [
                                                                  Color(
                                                                      0xFF00C6FB),
                                                                  Color(
                                                                      0xFF005BEA)
                                                                ])),
                                                        child: Text(
                                                          "${weekdayEngToKor[item]}",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0xFFFFFFFF)),
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
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                          widget.chatButton ? SizedBox() : GestureDetector(
                            onTap: () async {
                              print("USER DATA :");
                              log(UserData["social"]["user_id"].toString());
                              if (otherId != UserData['_id']) {
                                bool addChatAnswer = await addChat();
                                if (addChatAnswer == true) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                            name: otherName,
                                            imageUrl: snapshot
                                                .data!['user_profile_img'],
                                            uid: UserData["social"]
                                            ["user_id"],
                                            userId: otherId,
                                            chatId: chatId,
                                          )));
                                }
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xff3F51B5),
                              ),
                              child: Center(
                                child: Text(
                                  "1:1 채팅",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: size.width,
                            padding: EdgeInsets.fromLTRB(0, widget.chatButton ? 0 : 35, 0, 0),
                            child: Column(
                              children: [
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
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
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
                                            color:
                                                Color.fromRGBO(55, 84, 170, 0.1),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
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
                                                          0,
                                                          0,
                                                          0,
                                                          0.16), // shadow color
                                                    ),
                                                    const BoxShadow(
                                                      offset: Offset(2, 2),
                                                      blurRadius: 6,
                                                      color: Color(0xFFEFEFEF),
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
                                                          0,
                                                          0,
                                                          0,
                                                          0.16), // shadow color
                                                    ),
                                                    const BoxShadow(
                                                      offset: Offset(2, 2),
                                                      blurRadius: 6,
                                                      color: Color(0xFFEFEFEF),
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
                                                          0,
                                                          0,
                                                          0,
                                                          0.16), // shadow color
                                                    ),
                                                    const BoxShadow(
                                                      offset: Offset(2, 2),
                                                      blurRadius: 6,
                                                      color: Color(0xFFEFEFEF),
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
                                                          0,
                                                          0,
                                                          0,
                                                          0.16), // shadow color
                                                    ),
                                                    const BoxShadow(
                                                      offset: Offset(2, 2),
                                                      blurRadius: 6,
                                                      color: Color(0xFFEFEFEF),
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
                                                          0,
                                                          0,
                                                          0,
                                                          0.16), // shadow color
                                                    ),
                                                    const BoxShadow(
                                                      offset: Offset(2, 2),
                                                      blurRadius: 6,
                                                      color: Color(0xFFEFEFEF),
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
                              ],
                            ),
                          ),
                          // Container(
                          //   width: size.width - 40,
                          //   child: Column(children: [
                          //     Row(
                          //       children: [
                          //         Image.asset(
                          //           "assets/icon/profileFeedIcon.png",
                          //           width: 24,
                          //           height: 24,
                          //         ),
                          //         SizedBox(
                          //           width: 12,
                          //         ),
                          //         Text(
                          //           "게시글",
                          //           style: TextStyle(
                          //               fontSize: 20,
                          //               fontWeight: FontWeight.bold),
                          //         ),
                          //       ],
                          //     ),
                          //     SizedBox(
                          //       height: 18,
                          //     ),
                          //     GridView.builder(
                          //       itemCount: 10, //item 개수
                          //       gridDelegate:
                          //           SliverGridDelegateWithFixedCrossAxisCount(
                          //         crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                          //         childAspectRatio:
                          //             1 / 1, //item 의 가로 1, 세로 2 의 비율
                          //       ),
                          //       itemBuilder: (BuildContext context, int index) {
                          //         return Container(
                          //             color: Colors.lightGreen,
                          //             child: Text(' Item : $index'));
                          //       }, //item 의 반목문 항목 형성
                          //     )
                          //   ]),
                          // ),
                          /**
                           *
                           *
                           * MAIN COLUMN BOTTOM
                           *
                           *
                           *
                           */

                          // reviewContext.length == 0
                          //     ? SizedBox()
                          //     : Container(
                          //         width: size.width - 40,
                          //         decoration: BoxDecoration(
                          //           color: Color(0xFF292A2E),
                          //           border: Border.all(
                          //               width: 1, color: Color(0xFF5A595C)),
                          //           borderRadius: BorderRadius.circular(10),
                          //         ),
                          //         child: Padding(
                          //           padding:
                          //               const EdgeInsets.fromLTRB(20, 8, 15, 8),
                          //           child: ListView.builder(
                          //             shrinkWrap: true,
                          //             physics: NeverScrollableScrollPhysics(),
                          //             itemCount: reviewContext.length,
                          //             itemBuilder: (context, index) {
                          //               return Container(
                          //                 width: size.width - 40,
                          //                 margin:
                          //                     EdgeInsets.fromLTRB(0, 10, 0, 10),
                          //                 child: Column(
                          //                   children: [
                          //                     Row(
                          //                       children: [
                          //                         ClipRRect(
                          //                           borderRadius:
                          //                               BorderRadius.circular(
                          //                                   100.0),
                          //                           child: Image.network(
                          //                             '${reviewImg[index]}',
                          //                             width: 35.0,
                          //                             height: 35.0,
                          //                             fit: BoxFit.cover,
                          //                             errorBuilder:
                          //                                 (BuildContext context,
                          //                                     Object exception,
                          //                                     StackTrace?
                          //                                         stackTrace) {
                          //                               return Image.asset(
                          //                                 'assets/images/profile_null_image.png',
                          //                                 fit: BoxFit.cover,
                          //                                 width: 35.0,
                          //                                 height: 35.0,
                          //                               );
                          //                             },
                          //                           ),
                          //                         ),
                          //                         SizedBox(
                          //                           width: 12,
                          //                         ),
                          //                         Text(
                          //                           '${reviewName[index]}',
                          //                           style: TextStyle(
                          //                             color: Color(0xFFffffff),
                          //                             fontWeight: FontWeight.bold,
                          //                             fontSize: 14,
                          //                           ),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(
                          //                           left: 45),
                          //                       child: Container(
                          //                         width: size.width - 85,
                          //                         child: Row(
                          //                           children: [
                          //                             Flexible(
                          //                               child: RichText(
                          //                                 overflow: TextOverflow
                          //                                     .ellipsis,
                          //                                 maxLines: 100,
                          //                                 strutStyle: StrutStyle(
                          //                                     fontSize: 16),
                          //                                 text: TextSpan(
                          //                                   text:
                          //                                       '${reviewContext[index]}',
                          //                                   style: TextStyle(
                          //                                     fontSize: 16,
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               );
                          //             },
                          //           ),
                          //         ),
                          //       ),
                        ],
                      );
                    },
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // 기본적으로 로딩 Spinner를 보여줍니다.
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
