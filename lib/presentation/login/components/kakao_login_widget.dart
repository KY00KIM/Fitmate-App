import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import '../../../data/firebase_service/firebase_auth_methods.dart';
import '../../../domain/util.dart';
import '../../../ui/show_toast.dart';
import '../../home/home.dart';
import '../../signup.dart';

class KakaoLoginWidget extends StatelessWidget {
  KakaoLoginWidget({Key? key}) : super(key: key);
  kakao.User? user;
  bool isKakaoLogined = false;

  Future<bool> kakaoLogin() async {
    try {
      bool isInstalled = await kakao.isKakaoTalkInstalled();
      if (isInstalled) {
        try {
          await kakao.UserApi.instance.loginWithKakaoTalk();
          user = await kakao.UserApi.instance.me();
          print("카카오톡 로그인 성공");
          return true;
        } catch (error) {
          print("카카오 로그인 실패 : $error");
          return false;
        }
      } else {
        try {
          await kakao.UserApi.instance.loginWithKakaoAccount();
          user = await kakao.UserApi.instance.me();
          log(await kakao.UserApi.instance.toString());
          print("instance to String : ");
          log(await kakao.UserApi.instance.toString());
          print("instance>accessTokenInfo to String : ");
          log(await kakao.UserApi.instance.accessTokenInfo().toString());

          print("카카오계정 로그인 성공");
          return true;
        } catch (error) {
          print("카카오계정 로그인 실패 : $error");
          return false;
        }
      }
    } catch (error) {
      print("카카오톡 설치안됨 + 에러 : $error");
      return false;
    }
  }

  Future<bool> kakaoLogout() async {
    try {
      await kakao.UserApi.instance.unlink();
      print("카카오 로그아웃 성공");
      return true;
    } catch (error) {
      print("카카오 로그아웃 실패");
      return false;
    }
  }

  Future<String> login(BuildContext context) async {
    isKakaoLogined = await kakaoLogin();
    log(user.toString());
    if (isKakaoLogined) {
      final customToken =
          await FirebaseAuthMethods(FirebaseAuth.instance).createCustomToken({
        'uid': user!.id.toString(),
        'displayName': user!.kakaoAccount!.profile!.nickname,
        'email': user!.kakaoAccount!.email!,
        'photoURL': user!.kakaoAccount!.profile!.profileImageUrl!,
      });
      String access_token = await FirebaseAuthMethods(FirebaseAuth.instance)
          .signInWithCustomToken(context, customToken);
      return access_token;
    }
    return 'error';
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        IdToken = await login(context);
        print("IdToken : $IdToken");

        if (IdToken == 'error') {
          FlutterToastTop("알수 없는 에러가 발생하였습니다");
        } else {
          String? deviceToken = await FirebaseMessaging.instance.getToken();
          var iosToken = await FirebaseMessaging.instance.getAPNSToken();
          print('THIS IS ios APNS TOKEN :  ${iosToken}');

          print('deviceToken : ${deviceToken}');

          // ignore: avoid_print
          print("device token : ${deviceToken}");
          //토큰을 받는 단계에서 에러가 나지 않았다면
          http.Response response =
              await http.get(Uri.parse("${baseUrlV1}users/login"), headers: {
            'Authorization': 'bearer $IdToken',
            // ignore: unnecessary_brace_in_string_interps
            'device': '${deviceToken}'
          });
          var resBody = jsonDecode(utf8.decode(response.bodyBytes));
          print(resBody);

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
            '카카오로 로그인',
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