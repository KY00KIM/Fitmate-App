// ignore_for_file: unnecessary_null_comparison, avoid_print, duplicate_ignore

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/presentation/home/home.dart';
import 'package:fitmate/presentation/login/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'domain/util.dart';
import 'domain/firebase_options.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'dart:convert';

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

  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables

  Future<bool> getToken() async {
    // ignore: await_only_futures

    User? tokenResult = await FirebaseAuth.instance.currentUser;
    //log(tokenResult.toString());
    if (tokenResult == null) return true;
    // ignore: unused_local_variable
    var idToken = await tokenResult.getIdToken();

    IdToken = idToken.toString();
    log("IdToken : $IdToken");
    http.Response response = await http.get(Uri.parse("${baseUrl}users/login"),
        headers: {'Authorization': 'bearer $IdToken'});
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    print(resBody);

    UserId = resBody['data']['user_id'];
    bool userdata = await UpdateUserData();

    return IdToken == null || UserId == null || userdata == false;
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitMate',
      // ignore: unrelated_type_equality_checks, prefer_const_constructors
      //home: getToken() == true ? LoginPage() : HomePage(),
      // initialBinding: BindingsBuilder(
      //   () {
      //     Get.put(NotificationController());
      //   },
      // ),
      home: FutureBuilder(
        future: getToken(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return Center(child: CircularProgressIndicator());
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
          //return FirstRoute();
        },
      ),
    );
  }
}

class $ {}

class $idToken {}
