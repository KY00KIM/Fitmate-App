import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitmate/screens/login.dart';
import 'package:fitmate/screens/profileEdit.dart';
import 'package:fitmate/utils/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:fitmate/screens/writing.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'chatList.dart';
import 'home.dart';
import 'matching.dart';

String OtherUserCenterName = '';


class OtherProfilePage extends StatefulWidget {
  String profileId;
  String profileName;

  OtherProfilePage({Key? key, required String this.profileId, required String this.profileName}) : super(key: key);

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  String schedule = '';
  String otherFitnessCenter = '';
  int otherMatching = 0;

  Future<Map> getOtherProfile() async {
    http.Response response = await http.get(Uri.parse("${baseUrl}users/${widget.profileId.toString()}"), headers: {
      // ignore: unnecessary_string_interpolations
      "Authorization" : "$IdToken",
      "Content-Type" : "application/json; charset=UTF-8",
      "userId" : "${widget.profileId.toString()}"});
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));

    if(response.statusCode != 200 && resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();

      http.Response response = await http.get(Uri.parse("${baseUrl}users/${widget.profileId.toString()}"), headers: {
        // ignore: unnecessary_string_interpolations
        "Authorization" : "$IdToken",
        "Content-Type" : "application/json; charset=UTF-8",
        "userId" : "${widget.profileId.toString()}"});
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    if (response.statusCode == 200) {
      print("성공입니다");
      if (resBody['data']['user_schedule_time'] == 0) schedule = '오전';
      else if (resBody['data']['user_schedule_time'] == 1) schedule = '오후';
      else schedule = '저녁';
      print('resbody : ${resBody}');
      http.Response responseFitness = await http.get(Uri.parse("${baseUrl}fitnesscenters/${resBody['data']['fitness_center_id'].toString()}"), headers: {
        // ignore: unnecessary_string_interpolations
        "Authorization" : "${IdToken.toString()}",
        "fitnesscenterId" : "${resBody['data']['fitness_center_id'].toString()}"});
      print("status : ${responseFitness.statusCode}");
      if(responseFitness.statusCode == 200) {
        var resBody2 = jsonDecode(utf8.decode(responseFitness.bodyBytes));
        print("center name : ${resBody2['data']['center_name']}");
        otherFitnessCenter = resBody2["data"]["center_name"];
      }

      return resBody['data'];
    } else {
      print("앙 실패띠");
      throw Exception('Failed to load post');
    }
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF22232A),
      appBar: AppBar(
        elevation: 0.0,
        shape: Border(
          bottom: BorderSide(
            color: Color(0xFF3D3D3D),
            width: 1,
          ),
        ),
        backgroundColor: Color(0xFF22232A),
        title: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Text(
            "${widget.profileName}",
            style: TextStyle(
              color: Color(0xFFffffff),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<Map>(
          future: getOtherProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: size.width - 34,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.network(
                                '${snapshot.data!["user_profile_img"]}',
                                width: 70.0,
                                height: 70.0,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${widget.profileName}(${snapshot.data!["user_gender"] == false ? '남' : '여'})',
                              style: TextStyle(
                                color: Color(0xFFffffff),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: size.width - 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '기본 루틴',
                              style: TextStyle(
                                color: Color(0xFFffffff),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                '$schedule',
                                style: TextStyle(
                                  color: Color(0xFF2975CF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
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
                        width: size.width - 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: snapshot.data!["user_weekday"]["mon"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  width: 1,
                                  color: snapshot.data!["user_weekday"]["mon"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '월',
                                style: TextStyle(
                                    color: snapshot.data!["user_weekday"]["mon"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: snapshot.data!["user_weekday"]["tue"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  width: 1,
                                  color: snapshot.data!["user_weekday"]["tue"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '화',
                                style: TextStyle(
                                    color: snapshot.data!["user_weekday"]["tue"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: snapshot.data!["user_weekday"]["wed"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  width: 1,
                                  color: snapshot.data!["user_weekday"]["wed"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '수',
                                style: TextStyle(
                                    color: snapshot.data!["user_weekday"]["wed"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: snapshot.data!["user_weekday"]["thu"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  width: 1,
                                  color: snapshot.data!["user_weekday"]["thu"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '목',
                                style: TextStyle(
                                    color: snapshot.data!["user_weekday"]["thu"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: snapshot.data!["user_weekday"]["fri"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  width: 1,
                                  color: snapshot.data!["user_weekday"]["fri"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '금',
                                style: TextStyle(
                                    color: snapshot.data!["user_weekday"]["fri"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: snapshot.data!["user_weekday"]["sat"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  width: 1,
                                  color: snapshot.data!["user_weekday"]["sat"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '토',
                                style: TextStyle(
                                    color: snapshot.data!["user_weekday"]["sat"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: snapshot.data!["user_weekday"]["sun"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  width: 1,
                                  color: snapshot.data!["user_weekday"]["sun"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '일',
                                style: TextStyle(
                                    color: snapshot.data!["user_weekday"]["sun"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: size.width - 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '기본 정보',
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
                        height: 20,
                      ),
                      Container(
                        width: size.width - 40,
                        height: 112,
                        decoration: BoxDecoration(
                          color: Color(0xFF22232A),
                          border: Border.all(width: 1, color: Color(0xFF757575)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(22, 15, 22, 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          '내 동네',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${snapshot.data!["user_address"]}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFffffff),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    '$otherFitnessCenter',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFffffff),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    '3회',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFffffff),
                                    ),
                                  ),
                                ],
                              ),
                              /*
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.thumb_up_alt,
                                  color: Color(0xFF2975CF),
                                  size: 17,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  '매칭 후기',
                                  style: TextStyle(
                                    color: Color(0xFFffffff),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '좋아요',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFffffff),
                            ),
                          ),
                        ],
                      ),
                      */
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: size.width - 40,
                        height: 1,
                        color: Color(0xFF757575),
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
                              '메이트 리뷰',
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
                      Container(
                        width: size.width - 40,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: Image.network(
                                    'http://newsimg.hankookilbo.com/2018/03/07/201803070494276763_1.jpg',
                                    width: 35.0,
                                    height: 35.0,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  '우천류',
                                  style: TextStyle(
                                    color: Color(0xFFffffff),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 45),
                              child: Container(
                                width: size.width - 85,
                                child: Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 100,
                                    strutStyle: StrutStyle(fontSize: 16),
                                    text: TextSpan(
                                      text: '어깨 제대로 부수실 분앙아아아ㅇ러냐릔두ㅑ루디루댜sdfsfsfsfd아아',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: size.width - 40,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: Image.network(
                                    'http://newsimg.hankookilbo.com/2018/03/07/201803070494276763_1.jpg',
                                    width: 35.0,
                                    height: 35.0,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  '우천류',
                                  style: TextStyle(
                                    color: Color(0xFFffffff),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 45),
                              child: Container(
                                width: size.width - 85,
                                child: Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 100,
                                    strutStyle: StrutStyle(fontSize: 16),
                                    text: TextSpan(
                                      text: '어깨 제대로 부수실 분앙아아아ㅇ러냐릔두ㅑ루디루댜sdfsfsfsfd아아',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: size.width - 40,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: Image.network(
                                    'http://newsimg.hankookilbo.com/2018/03/07/201803070494276763_1.jpg',
                                    width: 35.0,
                                    height: 35.0,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  '우천류',
                                  style: TextStyle(
                                    color: Color(0xFFffffff),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 45),
                              child: Container(
                                width: size.width - 85,
                                child: Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 100,
                                    strutStyle: StrutStyle(fontSize: 16),
                                    text: TextSpan(
                                      text: '어깨 제대로 부수실 분앙아아아ㅇ러냐릔두ㅑ루디루댜sdfsfsfsfd아아',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // 기본적으로 로딩 Spinner를 보여줍니다.
            return CircularProgressIndicator();
          },

        ),
      ),
    );
  }
}
