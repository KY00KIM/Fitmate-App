import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../domain/model/post.dart';
import '../../../domain/util.dart';
import '../../chat/chat.dart';
import 'package:http/http.dart' as http;

import '../../fitness_center/fitness_center.dart';


class DetailContentWidget extends StatelessWidget {
  Post post;
  String makerUserUid;
  DetailContentWidget({Key? key, required this.post, required this.makerUserUid}) : super(key: key);

  String chatId = '';

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
          resBody['data'][i]['chat_join_id'] == post.userId.id) ||
          (resBody['data'][i]['chat_join_id'] == UserData['_id'] &&
              resBody['data'][i]['chat_start_id'] == post.userId.id)) {
        //이미 채팅방이 있을 때
        chatId = resBody['data'][i]['_id'];
        return true;
      }
    }

    Map data = {"chat_join_id": "${post.userId.id}"};
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
      chatId = resBody2['data']['_id'];
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    String? time = post.promiseDate.toString().substring(11, 13);
    String slot = int.parse(time) > 12 ? '오후' : '오전';

    String fitnessPartContent = '';
    for(int i = 0; i < post.postFitnessPart.length; i++) {
      fitnessPartContent = fitnessPartContent + "#${fitnessPart[post.postFitnessPart[i]]} ";
    }

    return Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
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
        width: size.width,
        padding: EdgeInsets.fromLTRB(20, 32, 20, 32),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: SvgPicture.asset(
                        "assets/icon/fitness_icon.svg",
                        width: 18,
                        height: 18,
                      ),
                      margin: EdgeInsets.only(top : 3),
                    ),
                    SizedBox(
                      width : 18,
                    ),
                    Container(
                      width: size.width - 108,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '피트니스 클럽',
                            style: TextStyle(
                              color: Color(0xFF6E7995),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 14,),
                          Text(
                            '${post.promiseLocation.centerName}',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12,),
                          Text(
                            '${post.promiseLocation.centerAddress}',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                        "assets/icon/right_arrow_icon.svg",
                        width: 16,
                        height: 16,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FitnessCenterPage(fitnessId: '${post.promiseLocation.id}',)));
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: SvgPicture.asset(
                    "assets/icon/calender_icon.svg",
                    width: 18,
                    height: 18,
                  ),
                  margin: EdgeInsets.only(top : 3),
                ),
                SizedBox(
                  width : 18,
                ),
                Container(
                  width: size.width - 108,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '매칭',
                        style: TextStyle(
                          color: Color(0xFF6E7995),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 14,),
                      Text(
                        '${post.promiseDate.toString().substring(0, 4)}년 ${post.promiseDate.toString().substring(5, 7)}월 ${post.promiseDate.toString().substring(8, 10)}일  ${slot} ${int.parse(time) > 12 ? '${int.parse(time) - 12}' : '${int.parse(time)}'}시 ${post.promiseDate.toString().substring(14, 16)}분',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: SvgPicture.asset(
                    "assets/icon/Indicators_icon.svg",
                    width: 18,
                    height: 18,
                  ),
                  margin: EdgeInsets.only(top : 3),
                ),
                SizedBox(
                  width : 18,
                ),
                Container(
                  width: size.width - 108,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '운동부위',
                        style: TextStyle(
                          color: Color(0xFF6E7995),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 14,),
                      Text(
                        '$fitnessPartContent',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 0,
                primary: Color(0xFF3F51B5),
              ),
              onPressed: () async {
                if (post.userId.id != UserData['_id']) {
                  bool addChatAnswer = await addChat();
                  if (addChatAnswer == true) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(
                              name: post.userId.userNickname,
                              imageUrl: post.userId.userProfileImg,
                              uid: makerUserUid,
                              userId: post.userId.id,
                              chatId: chatId,
                            )));
                  }
                }
              },
              child: Text(
                '1:1 채팅',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      );
  }
}
