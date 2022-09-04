import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/svg.dart';

import '../../../data/firebase_service/firebase_auth_methods.dart';
import '../../../domain/util.dart';
import '../../../ui/show_toast.dart';
import '../../home/home.dart';
import '../../post/post.dart';
import '../../signup.dart';

class GoogleLoginWidget extends StatelessWidget {
  const GoogleLoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Row(
          //spaceEvenly: 요소들을 균등하게 배치하는 속성
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.asset(
                      'assets/icon/google-logo.png',
                    ),
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFFffffff)),
                ),
              ],
            ),
            Text(
              'Google로 로그인',
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.54),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox()
          ],
        ),
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
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
      ),
      onTap: () async {
        IdToken = await FirebaseAuthMethods(FirebaseAuth.instance)
            .signInWithGoogle(context);
        IdToken =
            (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
                .token
                .toString();

        if (IdToken == 'error') {
          FlutterToastTop("알수 없는 에러가 발생하였습니다");
        } else {
          String? deviceToken = await FirebaseMessaging.instance.getToken();

          //토큰을 받는 단계에서 에러가 나지 않았다면
          http.Response response = await http
              .get(Uri.parse("${baseUrl}users/login"), headers: {
            'Authorization': 'bearer $IdToken',
            'device': '${deviceToken}'
          });
          var resBody = jsonDecode(utf8.decode(response.bodyBytes));
          print("서버 로그인 응답 $resBody");

          if (response.statusCode == 200) {
            //사용자 정보가 완벽히 등록 되어있다면
            UserId = resBody['data']['user_id'];

            bool userdata = await UpdateUserData();

            if (userdata == true) {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      HomePage(
                    reload: true,
                  ),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            } else {
              print("else 문 에러");
              FlutterToastTop("알수 없는 에러가 발생하였습니다");
            }
          } else if (resBody['message'] == 404) {
            // 사용자 정보가 등록 안된 상황에서는
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    SignupPage1(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else {
            //모르는 문제 시에는
            FlutterToastTop("알수 없는 에러가 발생하였습니다");
          }
        }
      },
    );
  }
}
