//import 'dart:_http';
import 'dart:convert';
import 'dart:developer';

import 'package:fitmate/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:fitmate/firebase_service/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/screens/home.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:fitmate/utils/data.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xff22232A),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Opacity(
                  opacity: 0.6,
                  child: Image.asset(
                    "assets/images/sign_up_background.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/fitmate_logo.png',
                        width: 140,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        '계정으로 접속하고\nMate로 합류하세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                IdToken = await FirebaseAuthMethods(FirebaseAuth.instance).signInWithFacebook(context);
                                log(IdToken);
                                if(IdToken == 'error') {FlutterToastTop("알수 없는 에러가 발생하였습니다");}
                                else {
                                  //토큰을 받는 단계에서 에러가 나지 않았다면
                                  http.Response response = await http.get(Uri.parse("${baseUrl}users/login"), headers: {
                                    'Authorization' : 'bearer ${IdToken.toString()}'});
                                  var resBody = jsonDecode(utf8.decode(response.bodyBytes));

                                  if(response.statusCode == 200) {
                                    //사용자 정보가 완벽히 등록 되어있다면
                                    UserId = resBody['data']['user_id'];

                                    bool userdata = await UpdateUserData();

                                    if(userdata == true) {
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration: Duration.zero,
                                        ),
                                      );
                                    }
                                    else {
                                      FlutterToastTop("알수 없는 에러가 발생하였습니다");
                                    }
                                  } else if(resBody['message'] == 404) {
                                    // 사용자 정보가 등록 안된 상황에서는
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => SignupPage(),
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
                                    'assets/images/sign_up_facebook_icon.png',
                                    width: 40.0,
                                    height: 40.0,
                                  ),
                                  Text(
                                    '페이스북 로그인',
                                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                                  ),
                                  Opacity(
                                    opacity: 0.0,
                                    child: Image.asset('assets/images/sign_up_facebook_icon.png'),
                                  ),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(width: 1.0, color: Color(0xff878E97)),
                                primary: Color(0xFF15161B),
                                //shadowColor: Colors.black, 그림자 추가하는 속성

                                minimumSize: Size.fromHeight(60), // 높이만 50으로 설정
                                elevation: 1.0,
                                shape: RoundedRectangleBorder(
                                  // shape : 버튼의 모양을 디자인 하는 기능
                                    borderRadius: BorderRadius.circular(15.0)
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                IdToken = await FirebaseAuthMethods(FirebaseAuth.instance).signInWithGoogle(context);
                                log('$IdToken');

                                if(IdToken == 'error') {FlutterToastTop("알수 없는 에러가 발생하였습니다");}
                                else {
                                  //토큰을 받는 단계에서 에러가 나지 않았다면
                                  http.Response response = await http.get(Uri.parse("https://fitmate.co.kr/v1/users/login"), headers: {
                                    'Authorization' : 'bearer $IdToken'});
                                  var resBody = jsonDecode(utf8.decode(response.bodyBytes));

                                  if(response.statusCode == 200) {
                                    print("지금이니!");
                                    //사용자 정보가 완벽히 등록 되어있다면
                                    UserId = resBody['data']['user_id'];

                                    bool userdata = await UpdateUserData();

                                    if(userdata == true) {
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration: Duration.zero,
                                        ),
                                      );
                                    }
                                    else {
                                      FlutterToastTop("알수 없는 에러가 발생하였습니다");
                                    }
                                  } else if(resBody['message'] == 404) {
                                    // 사용자 정보가 등록 안된 상황에서는
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => SignupPage(),
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
                                    'assets/images/sign_up_google_icon.png',
                                    width: 40.0,
                                    height: 40.0,
                                  ),
                                  Text(
                                    '구글 로그인',
                                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                                  ),
                                  Opacity(
                                    opacity: 0.0,
                                    child: Image.asset('assets/images/sign_up_google_icon.png'),
                                  ),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(width: 1.0, color: Color(0xff878E97)),
                                primary: Color(0xFF15161B),

                                minimumSize: Size.fromHeight(60),
                                elevation: 1.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

