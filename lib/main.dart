// ignore_for_file: unnecessary_null_comparison, avoid_print, duplicate_ignore

import 'dart:developer';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitmate/domain/facebook_pref.dart';
import 'package:fitmate/presentation/calender/calender.dart';
import 'package:fitmate/presentation/chat_list/chat_list.dart';
import 'package:fitmate/presentation/home/home.dart';
import 'package:fitmate/presentation/login/login.dart';
import 'package:fitmate/presentation/map/map.dart';
import 'package:fitmate/presentation/post/post.dart';
import 'package:fitmate/presentation/profile/profile.dart';
import 'package:fitmate/screens/First.dart';
import 'package:fitmate/screens/Home.dart';
import 'package:fitmate/screens/Second.dart';
import 'package:fitmate/ui/colors.dart';
import 'package:loader_overlay/loader_overlay.dart';
import './background_isolate.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'domain/util.dart';
import 'domain/firebase_options.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'dart:convert';

/*
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    PostPage(
      reload: false,
    ),
    ChatListPage(),
    MapPage(),
    CalenderPage(),
    ProfilePage(),
  ];

  void _onTap(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: _children,
          //physics: NeverScrollableScrollPhysics(), // No sliding
        ),
        bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            onTap: _onTap,
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mail),
                label: 'First',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Second'
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mail),
                label: 'First',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Second'
              )
            ]
        )
    );
  }
}

 */


//this is main
void main() async {
  //Constants.setEnvironment(Environment.PROD);
  await dotenv.load(fileName: ".env");
  KakaoSdk.init(nativeAppKey: '${dotenv.env['KAKAO_APP_KEY']}');

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'fitmate',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // initTrackManager();
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // startTrackManager();
      facebookAppEvents.getApplicationId().then((value) {
        print("facebook_app_id :  $value");
      });
    });
    super.initState();
  }

  Future<bool> getToken() async {
    // ignore: await_only_futures

    //1. storage에 있는지 확인 -> 있으면 그걸로 바로 home이동
    //2. 없으면 로그인 Idtoken 받고 그걸로 로그인 진행 후에 -> token들 storage에 저장 경우에 따라 페이지 이동

    User? tokenResult = await FirebaseAuth.instance.currentUser;
    print("1");
    log("token result : ${tokenResult.toString()}");
    if (tokenResult == null) return true;
    print("1.5");
    // ignore: unused_local_variable
    var idToken = await tokenResult.getIdToken();
    print('2 : ${idToken}');

    IdToken = idToken.toString();
    log("IdToken : $IdToken");
    http.Response response = await http.get(
        Uri.parse("${baseUrlV1}users/login"),
        headers: {'Authorization': 'bearer $IdToken'});
    print("3 : ${response.body}");
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    print("?? : ${resBody}");
    if (resBody['message'] == 404) return true;
    UserId = resBody['data']['user_id'];
    bool userdata = await UpdateUserData();
    print("4");

    String? token = await FirebaseMessaging.instance.getToken();
    log("device token : ${token}");

    return IdToken == null || UserId == null || userdata == false;
  }

  // 로딩 시에 현재 위치 바로 받아오고 맵 핀을 한번 받아오고 맵으로 넘어갈 때 바로 보여지도록(처음만)

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: GetMaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
          ),
        ),
        debugShowCheckedModeBanner: false,
        title: 'FitMate',
        // ignore: unrelated_type_equality_checks, prefer_const_constructors
        //home: getToken() == true ? LoginPage() : HomePage(),
        // initialBinding: BindingsBuilder(
        //   () {
        //     Get.put(NotificationController());
        //   },
        // ),
        // home: PolicyAgreementPage(user_object: user_object),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        home: FutureBuilder(
          future: getToken(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData == false) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: whiteTheme,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            //error가 발생하게 될 경우 반환하게 되는 부분
            else if (snapshot.hasError) {
              return LoginPage();
            }
            // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
            else {
              // ignore: avoid_print

              return snapshot.data == true
                  ? LoginPage()
                  : HomePage();
            }
            //return BaseMapPage();
          },
        ),
      ),
    );
  }
}

class $ {}

class $idToken {}