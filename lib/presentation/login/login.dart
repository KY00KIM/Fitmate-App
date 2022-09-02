import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitmate/presentation/login/components/apple_login_widget.dart';
import 'package:fitmate/presentation/login/components/google_login_widget.dart';
import 'package:fitmate/presentation/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/presentation/home/home.dart';

import '../../data/firebase_service/firebase_auth_methods.dart';
import '../../domain/util.dart';
import '../../ui/show_toast.dart';

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
                            GoogleLoginWidget(),
                            SizedBox(height: 5,),
                            AppleLoginWidget(),
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
            ],
          ),
        ),
      ),
    );
  }
}
