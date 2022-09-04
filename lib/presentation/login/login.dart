import 'package:fitmate/presentation/login/components/apple_login_widget.dart';
import 'package:fitmate/presentation/login/components/google_login_widget.dart';
import 'package:fitmate/presentation/login/components/kakao_login_widget.dart';
import 'package:fitmate/presentation/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/presentation/home/home.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/firebase_service/firebase_auth_methods.dart';
import '../../domain/util.dart';
import '../../ui/bar_widget.dart';
import '../../ui/show_toast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final barWidget = BarWidget();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: barWidget.signUpAppBar(context),
        backgroundColor: const Color(0xfff2f3f7),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 84,
                    width: 84,
                    child: Image.asset(
                      "assets/icon/icon-round.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 109,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '로그인',
                        style: TextStyle(
                          color: Color(0xFF6E7995),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 27,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      KakaoLoginWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      GoogleLoginWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      AppleLoginWidget(),
                      SizedBox(
                        height: 25,
                      ),
                      TextButton(onPressed: () {}, child: Text("로그인 없이 둘러보기"))
                    ],
                  )
                  /*
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
                                GoogleLoginWidget(),
                                SizedBox(
                                  height: 5,
                                ),
                                AppleLoginWidget(),
                                SizedBox(
                                  height: 5,
                                ),
                                KakaoLoginWidget()
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  */
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
