// ignore_for_file: unnecessary_null_comparison, avoid_print, duplicate_ignore

import 'dart:developer';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/domain/facebook_pref.dart';
import 'package:fitmate/presentation/home/home.dart';
import 'package:fitmate/presentation/login/login.dart';
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
// Import package
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

void main() async {
  //Constants.setEnvironment(Environment.PROD);
  await dotenv.load(fileName: ".env");
  KakaoSdk.init(nativeAppKey: '${dotenv.env['KAKAO_APP_KEY']}');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

// Show tracking authorization dialog and ask for permission
  // final appTrackStatus =
  //     await AppTrackingTransparency.requestTrackingAuthorization();
  // final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  // print("app_track_status : ${appTrackStatus}");
  // print("app_track_id(uuid): ${uuid}");
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
      print("Facebook_App Initializing...");
      facebookAppEvents.getApplicationId().then((value) {
        print("facebook_app_id :  $value");
        if (Platform.isIOS) {
          facebookAppEvents.clearUserData();
          checkAndRequestTrackingPermission();
        }
        ;
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
    log(tokenResult.toString());
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
                  : HomePage(
                      reload: true,
                    );
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



/*
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shimmer',
      routes: <String, WidgetBuilder>{
        'loading': (_) => LoadingListPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shimmer'),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: const Text('Loading List'),
            onTap: () => Navigator.of(context).pushNamed('loading'),
          ),
          ListTile(
            title: const Text('Slide To Unlock'),
            onTap: () => Navigator.of(context).pushNamed('slide'),
          )
        ],
      ),
    );
  }
}

class LoadingListPage extends StatefulWidget {
  @override
  _LoadingListPageState createState() => _LoadingListPageState();
}

class _LoadingListPageState extends State<LoadingListPage> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading List'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                enabled: _enabled,
                child: ListView.builder(
                  itemBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 48.0,
                          height: 48.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: 40.0,
                                height: 8.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  itemCount: 6,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _enabled = !_enabled;
                    });
                  },
                  child: Text(
                    _enabled ? 'Stop' : 'Play',
                    style: Theme.of(context).textTheme.button?.copyWith(
                        fontSize: 18.0,
                        color: _enabled ? Colors.redAccent : Colors.green),
                  )),
            )
          ],
        ),
      ),
    );
  }
}


 */
