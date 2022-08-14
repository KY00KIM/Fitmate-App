//import 'dart:_http';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitmate/screens/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitmate/firebase_service/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/screens/home.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
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
                  opacity: 0.4,
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
                        height: 20.0,
                      ),
                      Text(
                        '계정으로 접속하고\nMate로 합류하세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 23.0),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                IdToken = await FirebaseAuthMethods(
                                        FirebaseAuth.instance)
                                    .signInWithGoogle(context);
                                IdToken = (await FirebaseAuth
                                        .instance.currentUser
                                        ?.getIdTokenResult(true))!
                                    .token
                                    .toString();

                                if (IdToken == 'error') {
                                  FlutterToastTop("알수 없는 에러가 발생하였습니다");
                                } else {
                                  String? deviceToken = await FirebaseMessaging
                                      .instance
                                      .getToken();
                                  var iosToken = await FirebaseMessaging
                                      .instance
                                      .getAPNSToken();
                                  print(
                                      'THIS IS ios APNS TOKEN :  ${iosToken}');

                                  print('deviceToken : ${deviceToken}');

                                  // ignore: avoid_print
                                  print("device token : ${deviceToken}");
                                  //토큰을 받는 단계에서 에러가 나지 않았다면
                                  http.Response response = await http.get(
                                      Uri.parse("${baseUrl}users/login"),
                                      headers: {
                                        'Authorization': 'bearer $IdToken',
                                        // ignore: unnecessary_brace_in_string_interps
                                        'device': '${deviceToken}'
                                      });
                                  var resBody = jsonDecode(
                                      utf8.decode(response.bodyBytes));
                                  print(resBody);

                                  if (response.statusCode == 200) {
                                    //사용자 정보가 완벽히 등록 되어있다면
                                    UserId = resBody['data']['user_id'];

                                    bool userdata = await UpdateUserData();

                                    if (userdata == true) {
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              HomePage(
                                            reload: true,
                                          ),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero,
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
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            SignupPage(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
                                  } else {
                                    //모르는 문제 시에는
                                    log(resBody);
                                    FlutterToastTop("알수 없는 에러가 발생하였습니다");
                                  }
                                }
                              },
                              child: Row(
                                //spaceEvenly: 요소들을 균등하게 배치하는 속성
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.network(
                                    'http://pngimg.com/uploads/google/google_PNG19635.png',
                                    width: 35.0,
                                    height: 35.0,
                                  ),
                                  Text(
                                    '구글로 시작하기',
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 0.54),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Opacity(
                                    opacity: 0.0,
                                    child: Image.asset(
                                        'assets/images/sign_up_facebook_icon.png'),
                                  ),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                    width: 0.0, color: Color(0xff878E97)),
                                primary: Color(0xFFffffff),
                                //shadowColor: Colors.black, 그림자 추가하는 속성

                                minimumSize: Size.fromHeight(50), // 높이만 50으로 설정
                                elevation: 1.0,
                                shape: RoundedRectangleBorder(
                                    // shape : 버튼의 모양을 디자인 하는 기능
                                    borderRadius: BorderRadius.circular(25.0)),
                              ),
                            ),

                            /*
                            SizedBox(
                              width: 300,
                              child: TextButton.icon(
                                onPressed: () async {
                                  IdToken = await FirebaseAuthMethods(FirebaseAuth.instance).signInWithGoogle(context);
                                  IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();

                                  if(IdToken == 'error') {
                                    FlutterToastTop("알수 없는 에러가 발생하였습니다");
                                  }
                                  else {
                                    String? deviceToken = await FirebaseMessaging.instance.getToken();
                                    //토큰을 받는 단계에서 에러가 나지 않았다면
                                    http.Response response = await http.get(Uri.parse("${baseUrl}users/login"), headers: {
                                      'Authorization' : 'bearer $IdToken',
                                      'deviceToken' : '${deviceToken}'
                                    });
                                    var resBody = jsonDecode(utf8.decode(response.bodyBytes));

                                    if(response.statusCode == 200) {
                                      //사용자 정보가 완벽히 등록 되어있다면
                                      UserId = resBody['data']['user_id'];

                                      bool userdata = await UpdateUserData();

                                      if(userdata == true) {
                                        Navigator.pushReplacement(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) => HomePage(reload: true,),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration: Duration.zero,
                                          ),
                                        );
                                      }
                                      else {
                                        print("else 문 에러");
                                        FlutterToastTop("알수 없는 에러가 발생하였습니다");
                                      }
                                    } else if(resBody['message'] == 404) {
                                      // 사용자 정보가 등록 안된 상황에서는
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) => SignupPage(),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero,
                                        ),
                                      );
                                    } else {
                                      //모르는 문제 시에는
                                      log(resBody);
                                      FlutterToastTop("알수 없는 에러가 발생하였습니다");
                                    }
                                  }
                                },
                                /*
                                child: Row(
                                  //spaceEvenly: 요소들을 균등하게 배치하는 속성
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    SizedBox(width: 25,),
                                    Text(
                                      '구글로 시작하기',
                                      style: TextStyle(color: Color(0xFF000000), fontSize: 18.0, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                */

                                icon: Container(
                                    width: 25,
                                    height: 25,
                                    // decoration: BoxDecoration(color: Colors.blue),
                                    child: Image.network(
                                        'http://pngimg.com/uploads/google/google_PNG19635.png',
                                        fit:BoxFit.cover
                                    )
                                ),
                                label: Text(
                                  '구글로 시작하기',
                                  style: TextStyle(color: Color(0xFF000000), fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),

                              ),
                            ),
                            TextButton(
                              onPressed: () async {

                              },
                              child: Text(
                                '구글 로그인',
                                style: TextStyle(color: Colors.white, fontSize: 18.0),
                              ),
                            ),
                            */
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
