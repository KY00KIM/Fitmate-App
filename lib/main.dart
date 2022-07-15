// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/screens/home.dart';
import 'package:fitmate/screens/profile.dart';
import 'package:fitmate/screens/writing.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting().then((_) => runApp(MyApp()));
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
        nextScreen: StreamBuilder (
          stream:FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            /*
            if (snapshot.hasData) {
              print("user hasData");
              return HomePage();
            } else {
              print("user login page");
              return LoginPage();
            }
            */
            return HomePage();
          },
        ),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: const Color(0xff22232A),
        duration: 1,
      ),
    );
  }
}
