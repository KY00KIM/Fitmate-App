import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import '../../domain/util.dart';
import '../../ui/colors.dart';
import '../../ui/show_toast.dart';

class UserReportPage extends StatefulWidget {
  String reportUserId;
  UserReportPage({Key? key, required this.reportUserId}) : super(key: key);

  @override
  State<UserReportPage> createState() => _UserReportPageState();
}

class _UserReportPageState extends State<UserReportPage> {
  @override
  void initState() {
    super.initState();
  }

  double alignHeight = 0;
  String inputText = '';

  Map<String, bool> user_report = {
    "부적절한 닉네임이예요": false,
    "욕설을 해요": false,
    "비매너 사용자예요": false,
    "성희롱을 해요": false,
    "다른 문제가 있어요": false
  };
  List<String> report_list = [
    "부적절한 닉네임이예요",
    "욕설을 해요",
    "비매너 사용자예요",
    "성희롱을 해요",
    "다른 문제가 있어요"
  ];

  Future<bool> ReportPosets(String userId, String reportContent) async {
    Map data = {
      "reported_user": "${userId}",
      "reported_content": "$reportContent"
    };
    print("SENDING REPORT DATA : ${data}");
    var body = json.encode(data);

    http.Response response =
    await http.post(Uri.parse("${baseUrlV1}report/user"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer $IdToken',
        },
        body: body);
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    print("RESPONSE : ");
    print(resBody);

    if (response.statusCode == 201) {
      FlutterToastBottom("신고가 접수되었습니다");
      return true;
    } else if (resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();
      FlutterToastBottom("오류가 발생했습니다. 한번 더 시도해 주세요");
      return false;
    } else {
      FlutterToastBottom("오류가 발생하였습니다");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: whiteTheme,
        toolbarHeight: 60,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: whiteTheme,
        ),
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Container(
            width: 44,
            height: 44,
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
                  "assets/icon/x_icon.svg",
                  width: 16,
                  height: 16,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 20, 8),
            child: Container(
              width: 44,
              height: 44,
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
                    "assets/icon/bar_icons/${user_report['부적절한 닉네임이예요'] == true || user_report['욕설을 해요'] == true || user_report['비매너 사용자예요'] == true || user_report['성희롱을 해요'] == true || (user_report['다른 문제가 있어요'] == true && inputText != '') ? 'write_check_icon' : 'non_color_check_icon'}.svg",
                    width: 18,
                    height: 18,
                  ),
                  onPressed: () async {
                    if(user_report['부적절한 닉네임이예요'] == true || user_report['욕설을 해요'] == true || user_report['비매너 사용자예요'] == true || user_report['성희롱을 해요'] == true || (user_report['다른 문제가 있어요'] == true && inputText != '')) {
                      String content;
                      if(user_report['부적절한 닉네임이예요'] == true) {
                        content = '부적절한 닉네임이예요';
                      } else if (user_report['욕설을 해요'] == true) {
                        content = '욕설을 해요';
                      } else if (user_report['비매너 사용자예요'] == true) {
                        content = '비매너 사용자예요';
                      } else if(user_report['성희롱을 해요'] == true) {
                        content = '성희롱을 해요';
                      } else {
                        content = inputText;
                      }
                      bool res = await ReportPosets(widget.reportUserId, content);
                      print(res ? "신고 완료" : "신고 실패");
                      if(res) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: const Color(0xffF2F3F7),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                width: size.width,
                child: Column(
                  children: [
                    Text(
                      '사용자 신고',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      '해당 유저의 불편한 점을\n알려주세요.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF6E7995),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: user_report.keys.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return Container(
                            width: size.width - 40,
                            height: 60,
                            padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                            child: ElevatedButton(
                              child: Text(
                                report_list[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: user_report[report_list[index]] == false
                                      ? Color(0xFF6E7995)
                                      : Color(0xFFffffff),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  for (int i = 0; i < report_list.length; i++) {
                                    user_report[report_list[i]] = false;
                                  }
                                  user_report[report_list[index]] = true;
                                  if (index == 4)
                                    alignHeight = 130;
                                  else
                                    alignHeight = 0;
                                });

                                print("index : $alignHeight");
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(40, 40),
                                minimumSize: Size(size.width - 40, 60),
                                maximumSize: Size(size.width - 40, 60),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8), // <-- Radius
                                ),
                                primary: user_report[report_list[index]] == false
                                    ? Color(0xFFF2F3F7)
                                    : Color(0xFF3F51B5),
                                elevation: 0,
                                side: BorderSide(
                                  color: Color(0xFFD1D9E6),
                                  width: user_report[report_list[index]] == false
                                      ? 1
                                      : 0,
                                ),
                              ),
                            ),
                          );
                        }),
                    SizedBox(height: 20,),
                    AnimatedContainer(
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
                        border: Border.all(
                          width: 1,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                      height: alignHeight,
                      width: size.width - 40,
                      duration: Duration(milliseconds: 100),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 10, 4),
                        child: TextField(
                          minLines: 1,
                          maxLines: 10,
                          decoration: InputDecoration(
                            hintText: "어떤 문제인지 알려주세요!",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFD1D9E6),
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (text) {
                            setState(() {
                              inputText = text;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
