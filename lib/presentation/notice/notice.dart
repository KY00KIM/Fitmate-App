import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../domain/util.dart';
import '../../ui/bar_widget.dart';
import 'components/notice_widget.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  final barWidget = BarWidget();
  List noticeData = [];

  Future getNotice() async {
    http.Response response = await http.get(
        Uri.parse(
            "https://fitmate.co.kr/v2/push"),
        headers: {
          "Authorization": "bearer ${IdToken.toString()}",
          "Content-Type": "application/json; charset=UTF-8",
        });
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode != 200 &&
        resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();

      response = await http.get(
          Uri.parse(
              "https://fitmate.co.kr/v2/push"),
          headers: {
            "Authorization": "bearer ${IdToken.toString()}",
            "Content-Type": "application/json; charset=UTF-8",
          });
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }


    if (response.statusCode == 200) {
      print("반환 갑니다잉");
      noticeData = List.from(resBody['data'].reversed);
      return true;
    } else {
      print("what the fuck");
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getNotice(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: barWidget.noticeAppBar(context),
            backgroundColor: whiteTheme,
            body: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '알림함',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF6E7995),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20,),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: noticeData.length,
                        itemBuilder: (context, index) {
                          log('notice : ${noticeData}');
                          String img = '';
                          String title = '';
                          if(noticeData[index]['pushType'] == "REVIEW") {
                            title = "${noticeData[index]['match_start_id']['_id'] == UserData['_id'] ? noticeData[index]['match_join_id']['user_nickname'] : noticeData[index]['match_start_id']['user_nickname']}님과의 매칭 DAY를 평가해 주세요.";
                            img = "${noticeData[index]['match_start_id']['_id'] == UserData['_id'] ? noticeData[index]['match_join_id']['user_profile_img'] : noticeData[index]['match_start_id']['user_profile_img']}";
                          } else if(noticeData[index]['pushType'] == "NOTICE") {
                            title = "[공지] ${noticeData[index]['notification_body']}";
                            img = '';
                          } else if(noticeData[index]['pushType'] == "APPOINTMENT") {
                            title = "${noticeData[index]['match_start_id']['_id'] == UserData['_id'] ? noticeData[index]['match_join_id']['user_nickname'] : noticeData[index]['match_start_id']['user_nickname']}님이 메이트 매칭을 잡았습니다.";
                            img = "${noticeData[index]['match_start_id']['_id'] == UserData['_id'] ? noticeData[index]['match_join_id']['user_profile_img'] : noticeData[index]['match_start_id']['user_profile_img']}";
                          } else {
                            title = "운동하셔야 합니다!";
                            img = "${UserData['user_profile_img']}";
                          }
                          return Container(
                            margin: EdgeInsets.only(bottom: 16),
                            width: size.width - 40,
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
                            padding: EdgeInsets.all(16),
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100.0),
                                      child: Image.network(
                                        img,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                          return Image.asset(
                                            'assets/images/profile_null_image.png',
                                            width: 40.0,
                                            height: 40.0,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 16,),
                                    Flexible(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 50,
                                        strutStyle: StrutStyle(fontSize: 14),
                                        text: TextSpan(
                                          text: title,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF000000),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 11,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${noticeData[index]['createdAt'].toString().substring(0, 10)} ${noticeData[index]['createdAt'].toString().substring(11, 16)}',
                                      style: TextStyle(
                                        color: Color(0xFF6E7995),
                                        fontSize: 12
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        // 기본적으로 로딩 Spinner를 보여줍니다.
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
