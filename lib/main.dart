// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitMate',
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/images/fitmate_logo.png'),
        nextScreen: MyHomePage(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: const Color(0xff22232A),
      ),
    );
  }
}


class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xff22232A),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/sign_up_background.png',
                  width: 280,
                  height: 160,
                  fit: BoxFit.fill,
                ),
                Image.asset(
                  'assets/images/fitmate_logo.png',
                  width: 90,
                  height: 45,
                  fit: BoxFit.fill,
                ),
                Text(
                  '계정으로 접속하고\nMate로 합류하세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25.0),
                ),
                ElevatedButton(
                    onPressed: () {

                    },
                    child: Row(

                    ),
                ),
                ElevatedButton(
                  onPressed: () {

                  },
                  child: Row(

                  ),
                ),
                TextButton(
                    onPressed: () {

                    },
                    child: Text('로그인 없이 둘러보기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
