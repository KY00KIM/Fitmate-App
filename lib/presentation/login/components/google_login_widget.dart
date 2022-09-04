import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../data/firebase_service/firebase_auth_methods.dart';
import '../../../domain/util.dart';
import '../../../ui/show_toast.dart';
import '../../home/home.dart';
import '../../signup.dart';

class GoogleLoginWidget extends StatelessWidget {
  const GoogleLoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
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
              .get(Uri.parse("${baseUrlV1}users/login"), headers: {
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
                    SignupPage(),
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
      child: Row(
        //spaceEvenly: 요소들을 균등하게 배치하는 속성
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/icon/google-logo.png',
            width: 20.0,
            height: 20.0,
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
      style: ElevatedButton.styleFrom(
        side: BorderSide(width: 0.0, color: Color(0xff878E97)),
        primary: Color(0xFFffffff),
        //shadowColor: Colors.black, 그림자 추가하는 속성

        minimumSize: Size.fromHeight(40), // 높이만 50으로 설정
        elevation: 1.0,
        shape: RoundedRectangleBorder(
            // shape : 버튼의 모양을 디자인 하는 기능
            borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }
}
