import 'package:flutter/material.dart';
import 'package:fitmate/firebase_service/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/screens/home.dart';

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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 70.0,
                ),
                Image.asset(
                  'assets/images/sign_up_background.png',
                  width: 320,
                  height: 180,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 55.0,
                ),
                Image.asset(
                  'assets/images/fitmate_logo.png',
                  width: 50,
                  height: 12,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  '계정으로 접속하고\nMate로 합류하세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25.0),
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
                        onPressed: () {
                          FirebaseAuthMethods(FirebaseAuth.instance).signInWithFacebook(context);
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

                          minimumSize: Size.fromHeight(50), // 높이만 50으로 설정
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                            // shape : 버튼의 모양을 디자인 하는 기능
                              borderRadius: BorderRadius.circular(15.0)
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          var answer = FirebaseAuthMethods(FirebaseAuth.instance).signInWithGoogle(context);
                          Route route = MaterialPageRoute(builder: (context) => StreamBuilder (
                            stream:FirebaseAuth.instance.authStateChanges(),
                            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                              if (snapshot.hasData) {
                                print("user hasData");
                                return HomePage();
                              } else {
                                print("user login page");
                                return LoginPage();
                              }
                            },
                          ),);
                          Navigator.pushReplacement(context, route);
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


                          minimumSize: Size.fromHeight(50),
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
