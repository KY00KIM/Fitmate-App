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
  late String otherId;
  late String otherName;

  List<String> reviewName = [];
  List<String> reviewImg = [];
  List<String> reviewContext = [];

  //int reviewNumber = 0;
  String reportContent = '';

  /*
  Future<int> getReviewProfile(String otherId) async {
    http.Response response = await http.get(Uri.parse("${baseUrl}reviews/${otherId}"),
      headers: {
        "Authorization" : "bearer $IdToken",
        "userId" : "bearer ${otherId}"
      },
    );
    print("response 완료 : ${response.statusCode}");
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    print("아 몰라 : ${resBody}");
    if(response.statusCode != 200 && resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();

      response = await http.get(Uri.parse("${baseUrl}reviews/${otherId}"),
        headers: {
          "Authorization" : "bearer $IdToken",
          "userId" : "bearer ${otherId}"
        },
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    for(int i = 0; i < resBody['data'].length; i++) {
      reviewContext.add(resBody['data'][i]['review_body']);
      reviewImg.add(resBody["data"][i]["review_send_id"]['user_profile_img']);
      reviewName.add(resBody['data'][i]['review_send_id']['user_nickname']);
    }

    print("반환 준비 : ${response.statusCode}");
    if(response.statusCode == 200) {
      print("반환 갑니다잉");
      return resBody["data"].length;
    }
    else {
      print("what the fuck");
      throw Exception('Failed to load post');
    }
  }

   */

  Future<Map> getOtherProfile() async {
    http.Response response = await http.get(Uri.parse("${baseUrl}users/${widget.profileId.toString()}"), headers: {
      // ignore: unnecessary_string_interpolations
      "Authorization" : "bearer $IdToken",
      "Content-Type" : "application/json; charset=UTF-8",
      "userId" : "${widget.profileId.toString()}"});
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));

    if(response.statusCode != 200 && resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();

      http.Response response = await http.get(Uri.parse("${baseUrl}users/${widget.profileId.toString()}"), headers: {
        // ignore: unnecessary_string_interpolations
        "Authorization" : "bearer $IdToken",
        "Content-Type" : "application/json; charset=UTF-8",
        "userId" : "${widget.profileId.toString()}"});
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    otherId = resBody['data']['_id'].toString();

    if (response.statusCode == 200) {
      print("성공입니다");
      if (resBody['data']['user_schedule_time'] == 0) schedule = '오전';
      else if (resBody['data']['user_schedule_time'] == 1) schedule = '오후';
      else schedule = '저녁';
      otherName = resBody['data']['user_nickname'];

      print('resbody : ${resBody}');

      http.Response responseFitness = await http.get(Uri.parse("${baseUrl}fitnesscenters/${resBody['data']['fitness_center_id'].toString()}"), headers: {
        // ignore: unnecessary_string_interpolations
        "Authorization" : "bearer ${IdToken.toString()}",
        "fitnesscenterId" : "${resBody['data']['fitness_center_id'].toString()}"});
      print("status : ${responseFitness.statusCode}");
      if(responseFitness.statusCode == 200) {
        var resBody2 = jsonDecode(utf8.decode(responseFitness.bodyBytes));
        print("center name : ${resBody2['data']['center_name']}");
        otherFitnessCenter = resBody2["data"]["center_name"];
      }

      http.Response response2 = await http.get(Uri.parse("${baseUrl}reviews/${otherId}"),
        headers: {
          "Authorization" : "bearer $IdToken",
          "userId" : "bearer ${otherId}"
        },
      );
      print("response 완료 : ${response2.statusCode}");
      var resBody2 = jsonDecode(utf8.decode(response2.bodyBytes));
      print("아 몰라 : ${resBody2}");

      reviewContext.clear();
      reviewImg.clear();
      reviewName.clear();

      for(int i = 0; i < resBody2['data'].length; i++) {
        reviewContext.add(resBody2['data'][i]['review_body']);
        reviewImg.add(resBody2["data"][i]["review_send_id"]['user_profile_img']);
        reviewName.add(resBody2['data'][i]['review_send_id']['user_nickname']);
      }

      return resBody['data'];
    } else {
      print("앙 실패띠");
      throw Exception('Failed to load post');
    }
  }

  void ReportPosets() async {
    Map data = {
      "reportedUserId": "${otherId}",
      "reported_content": "$reportContent"
    };
    print(data);
    var body = json.encode(data);

    http.Response response = await http.post(Uri.parse("${baseUrl}report/user"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'bearer $IdToken',
      },
      body: body
    );
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    print(resBody);

    if(response.statusCode == 201) {
      FlutterToastBottom("신고가 접수되었습니다");
      Navigator.of(context).pop();
    } else if (resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();
      FlutterToastBottom("오류가 발생했습니다. 한번 더 시도해 주세요");
    } else {
      FlutterToastBottom("오류가 발생하였습니다");
    }

  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Color(0xFF22232A),
          title: new Text(
            "사용자 신고",
            style: TextStyle(
              color: Color(0xFFffffff),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
              color: Color(0xFF15161B),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Color(0xFF878E97), //                   <--- border color
                width: 1.0,
              ),
            ),
            child: TextField(
              onChanged: (value) {
                reportContent = value;
              },
              keyboardType: TextInputType.multiline,
              maxLines: 15,
              minLines: 1,
              style: TextStyle(
                color: Color(0xFF757575)
              ),
              decoration: InputDecoration(
                fillColor: Color(0xFF15161B),
                border: InputBorder.none,
              ),
            ),
            padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
          ),
          actions: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 130,
                    child: ElevatedButton(
                      child: Text(
                        "신고 내용 보내기",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        ReportPosets();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
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
        backgroundColor: Color(0xFF22232A),
        title: Center(
          child: Text(
            //"${widget.profileName}",
            "프로필",
            style: TextStyle(
              color: Color(0xFFffffff),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          PopupMenuButton(
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
              if (value == '/report') {
                _showDialog();
              }
            },
            itemBuilder: (BuildContext bc) {
              return [
                PopupMenuItem(
                  child: Text(
                    '신고하기',
                    style: TextStyle(
                      color: Color(0xFFffffff),
                    ),
                  ),
                  value: '/report',
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        /*
        child : FutureBuilder<Map> (
          future: getOtherProfile(),
          builder: (context, snapshot) {
            print('snapshot data : ${snapshot.hasData}');
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: Column(
                    children: [
                      Container(
                        width: size.width - 34,
                        padding: EdgeInsets.all(0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.network(
                                '${snapshot.data!["user_profile_img"]}',
                                width: 70.0,
                                height: 70.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${otherName}(${snapshot.data!["user_gender"] == false ? '남' : '여'})',
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
                                '${schedule}',
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
                                    '${reviewNumber.toString()}회',
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data,
                        itemBuilder: (context, index) {
                          return Container(
                            width: size.width - 40,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100.0),
                                      child: Image.network(
                                        '${reviewImg[index]}',
                                        width: 35.0,
                                        height: 35.0,
                                        fit: BoxFit.cover,
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
                                  padding: const EdgeInsets.only(left: 45),
                                  child: Container(
                                    width: size.width - 85,
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 100,
                                            strutStyle: StrutStyle(fontSize: 16),
                                            text: TextSpan(
                                              text: '${reviewContext[index]}',
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
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return SizedBox();
            }
            // 기본적으로 로딩 Spinner를 보여줍니다.
            return Center(child: CircularProgressIndicator());
          },
        ),
         */
        child: FutureBuilder<Map>(
          future: getOtherProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
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
                                        color: Color(0xFF292A2E),
                                        border: Border.all(
                                            width: 1, color: Color(0xFF5A595C)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 55,
                                          ),
                                          Text(
                                            '${otherName}',
                                            style: TextStyle(
                                              color: Color(0xFFffffff),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            '${snapshot.data!["user_gender"] == false ? '남' : '여'} · ${snapshot.data!["user_address"]}',
                                            style: TextStyle(
                                              color: Color(0xFFA4A5A8),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          snapshot.data!['user_introduce'] == null
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
                                                      '${snapshot.data!['user_introduce']}',
                                                      style: TextStyle(
                                                        color: Color(0xFFFFFFFF),
                                                        fontSize: 12,
                                                      ),
                                                      textAlign: TextAlign.center),
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
                                    '${snapshot.data!["user_profile_img"]}',
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
                                  color: Color(0xFFffffff),
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
                            border: Border.all(
                                width: 1, color: Color(0xFF5A595C)),
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
                                      '${otherFitnessCenter}',
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
                                      '${reviewContext.length.toString()}회',
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
                                      '${schedule}',
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
                                /*
                                Container(
                                  width: size.width - 80,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: UserData["user_weekday"]["mon"] == true
                                              ? Color(0xFF2975CF)
                                              : Color(0xFF22232A),
                                          borderRadius: BorderRadius.circular(40),
                                          border: Border.all(
                                            width: 1,
                                            color: UserData["user_weekday"]["mon"] == true
                                                ? Color(0xFF2975CF)
                                                : Color(0xFF878E97),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '월',
                                          style: TextStyle(
                                              color:
                                              UserData["user_weekday"]["mon"] == true
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
                                          color: UserData["user_weekday"]["tue"] == true
                                              ? Color(0xFF2975CF)
                                              : Color(0xFF22232A),
                                          borderRadius: BorderRadius.circular(40),
                                          border: Border.all(
                                            width: 1,
                                            color: UserData["user_weekday"]["tue"] == true
                                                ? Color(0xFF2975CF)
                                                : Color(0xFF878E97),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '화',
                                          style: TextStyle(
                                              color:
                                              UserData["user_weekday"]["tue"] == true
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
                                          color: UserData["user_weekday"]["wed"] == true
                                              ? Color(0xFF2975CF)
                                              : Color(0xFF22232A),
                                          borderRadius: BorderRadius.circular(40),
                                          border: Border.all(
                                            width: 1,
                                            color: UserData["user_weekday"]["wed"] == true
                                                ? Color(0xFF2975CF)
                                                : Color(0xFF878E97),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '수',
                                          style: TextStyle(
                                              color:
                                              UserData["user_weekday"]["wed"] == true
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
                                          color: UserData["user_weekday"]["thu"] == true
                                              ? Color(0xFF2975CF)
                                              : Color(0xFF22232A),
                                          borderRadius: BorderRadius.circular(40),
                                          border: Border.all(
                                            width: 1,
                                            color: UserData["user_weekday"]["thu"] == true
                                                ? Color(0xFF2975CF)
                                                : Color(0xFF878E97),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '목',
                                          style: TextStyle(
                                              color:
                                              UserData["user_weekday"]["thu"] == true
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
                                          color: UserData["user_weekday"]["fri"] == true
                                              ? Color(0xFF2975CF)
                                              : Color(0xFF22232A),
                                          borderRadius: BorderRadius.circular(40),
                                          border: Border.all(
                                            width: 1,
                                            color: UserData["user_weekday"]["fri"] == true
                                                ? Color(0xFF2975CF)
                                                : Color(0xFF878E97),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '금',
                                          style: TextStyle(
                                              color:
                                              UserData["user_weekday"]["fri"] == true
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
                                          color: UserData["user_weekday"]["sat"] == true
                                              ? Color(0xFF2975CF)
                                              : Color(0xFF22232A),
                                          borderRadius: BorderRadius.circular(40),
                                          border: Border.all(
                                            width: 1,
                                            color: UserData["user_weekday"]["sat"] == true
                                                ? Color(0xFF2975CF)
                                                : Color(0xFF878E97),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '토',
                                          style: TextStyle(
                                              color:
                                              UserData["user_weekday"]["sat"] == true
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
                                          color: UserData["user_weekday"]["sun"] == true
                                              ? Color(0xFF2975CF)
                                              : Color(0xFF22232A),
                                          borderRadius: BorderRadius.circular(40),
                                          border: Border.all(
                                            width: 1,
                                            color: UserData["user_weekday"]["sun"] == true
                                                ? Color(0xFF2975CF)
                                                : Color(0xFF878E97),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '일',
                                          style: TextStyle(
                                              color:
                                              UserData["user_weekday"]["sun"] == true
                                                  ? Color(0xFFffffff)
                                                  : Color(0xFF878E97),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                 */
                                Container(
                                  width: size.width - 80,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 35,
                                        height: 35,
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
                                        width: 35,
                                        height: 35,
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
                                        width: 35,
                                        height: 35,
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
                                        width: 35,
                                        height: 35,
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
                                        width: 35,
                                        height: 35,
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
                                        width: 35,
                                        height: 35,
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
                                        width: 35,
                                        height: 35,
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
                        reviewContext.length == 0 ? SizedBox() :
                        Container(
                          width: size.width - 40,
                          decoration: BoxDecoration(
                            color: Color(0xFF292A2E),
                            border: Border.all(
                                width: 1, color: Color(0xFF5A595C)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 15, 8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: reviewContext.length,
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
                                            BorderRadius.circular(100.0),
                                            child: Image.network(
                                              '${reviewImg[index]}',
                                              width: 35.0,
                                              height: 35.0,
                                              fit: BoxFit.cover,
                                              errorBuilder: (BuildContext context,
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
                                        padding: const EdgeInsets.only(left: 45),
                                        child: Container(
                                          width: size.width - 85,
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: RichText(
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 100,
                                                  strutStyle:
                                                  StrutStyle(fontSize: 16),
                                                  text: TextSpan(
                                                    text: '${reviewContext[index]}',
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
                    );
                  },
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
