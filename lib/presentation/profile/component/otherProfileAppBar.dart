import 'package:fitmate/presentation/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../ui/show_toast.dart';
import '../../../ui/colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;

import '../../../data/firebase_service/firebase_auth_methods.dart';
import '../../../domain/util.dart';
import 'dart:convert';

class BarWidget {
  final double iconSize = 32.0;
  final String iconSource = "assets/icon/";
  String reportContent = "";
  String userId = "";

  PreferredSizeWidget otherProfileAppBar(BuildContext context, String userId) {
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

    void _showDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            backgroundColor: Color(0xffF2F3F7),
            title: new Text(
              "사용자 신고",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Container(
              decoration: inset.BoxDecoration(
                color: const Color(0xffEFEFEF),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(width: 1.0, color: const Color(0xffffffff)),
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
              child: TextField(
                onChanged: (value) {
                  reportContent = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: 15,
                minLines: 1,
                style: TextStyle(color: Color(0xFF757575)),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: true,
                  hintText: '부적절한 닉네임 ..',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 183, 189, 198),
                  ),
                  labelStyle: TextStyle(color: Color(0xff878E97)),
                ),
              ),
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            ),
            actions: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: () async {
                    bool res = await ReportPosets(userId, reportContent);
                    print(res ? "신고 완료" : "신고 실패");
                    await UpdateUserData();
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  HomePage(reload: true),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 160,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xff3F51B5),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFffffff),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(-1, -1),
                        ),
                        BoxShadow(
                          color:
                              Color(0xff3F51B5), //.fromRGBO(55, 84, 170, 0.1),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Center(
                        child: Text(
                      "신고하기",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return AppBar(
      centerTitle: false,
      backgroundColor: whiteTheme,
      toolbarHeight: 60,
      elevation: 0,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: whiteTheme,
      ),
      title: Padding(
        padding: EdgeInsets.fromLTRB(6, 8, 6, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
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
                  child: SvgPicture.asset(
                    "${iconSource}x_icon.svg",
                    width: 16,
                    height: 16,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                }),
            Container(
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
                    "${iconSource}bar_icons/burger_icon.svg",
                    width: 18,
                    height: 18,
                  ),
                  onPressed: () async {
                    _showDialog();

                    // if (conditionalFunction != null &&
                    //     viewModel != null) {
                    //   createUserInFirestore();
                    //   if (await viewModel.sendSignUp()) {
                    //     await UpdateUserData();
                    //     Navigator.pushNamedAndRemoveUntil(
                    //         context, '/', (_) => false);
                    //     Navigator.pushReplacement(
                    //         context,
                    //         PageRouteBuilder(
                    //           pageBuilder: (context, animation,
                    //                   secondaryAnimation) =>
                    //               nextPage,
                    //           transitionDuration: Duration.zero,
                    //           reverseTransitionDuration: Duration.zero,
                    //         ));
                    //   } else {
                    //     FlutterToastTop("회원가입 중 문제가 발생했습니다");
                    //   }
                    // } else {
                    //   Navigator.push(
                    //       context,
                    //       PageRouteBuilder(
                    //         pageBuilder: (context, animation,
                    //                 secondaryAnimation) =>
                    //             nextPage,
                    //         transitionDuration: Duration.zero,
                    //         reverseTransitionDuration: Duration.zero,
                    //       ));
                    // }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
