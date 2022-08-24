import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitmate/screens/login.dart';
import 'package:fitmate/screens/profileEdit.dart';
import 'package:fitmate/utils/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:fitmate/screens/writing.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../firebase_service/firebase_auth_methods.dart';
import '../utils/bottomNavigationBar.dart';
import 'chatList.dart';
import 'home.dart';
import 'map.dart';
import 'matching.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  List<String> reviewName = [];
  List<String> reviewImg = [];
  List<String> reviewContext = [];

  String getSchedule() {
    if(UserData["user_schedule_time"] == 0) return "오전";
    else if(UserData["user_schedule_time"] == 1) return "오후";
    else return "저녁";
  }

  @override
  void initState() {
    super.initState();
    var sl = 'sefes';
    print("지금 내 유전 _id : ${UserData['_id']}");
    print("유저 정보 : ${UserData}");
  }

  Future<int> getReviewProfile() async {
    http.Response response = await http.get(Uri.parse("${baseUrl}reviews/${UserData['_id']}"),
      headers: {
        "Authorization" : "bearer $IdToken",
        "userId" : "${UserData['_id']}"
      },
    );
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    if(response.statusCode != 200 && resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();

      response = await http.get(Uri.parse("${baseUrl}reviews/${UserData['_id']}"),
        headers: {
          "Authorization" : "bearer $IdToken",
          "userId" : "${UserData['_id']}"
        },
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }
    for(int i = 0; i < resBody['data'].length; i++) {
      reviewContext.add(resBody['data'][i]['review_body']);
      reviewImg.add(resBody["data"][i]["review_send_id"]['user_profile_img']);
      reviewName.add(resBody['data'][i]['review_send_id']['user_nickname']);
    }

    print("반환 준비 : ${response.statusCode}");
    if(response.statusCode == 200) {
      print("반환 갑니다잉");
      return resBody["data"].length;
    }
    else {
      print("what the fuck");
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF22232A),
      appBar: AppBar(
        elevation: 0.0,
        shape: Border(
          bottom: BorderSide(
            color: Color(0xFF3D3D3D),
            width: 1,
          ),
        ),
        backgroundColor: Color(0xFF22232A),
        title: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Text(
            "내 정보",
            style: TextStyle(
              color: Color(0xFFffffff),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          PopupMenuButton(
            iconSize: 30,
            color: Color(0xFF22232A),
            shape: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF757575),
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            elevation: 40,
            onSelected: (value) async {
              if (value == '/edit') Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileEditPage()));
              else if (value == '/logout'){
                print('로그아웃');
                await FirebaseAuthMethods(FirebaseAuth.instance).signOut();
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              } else if(value == '/signout') {
                CollectionReference users = FirebaseFirestore.instance.collection('users');
                users.doc(UserData['social']['user_id']).delete();
                User? user = FirebaseAuth.instance.currentUser;
                user?.delete();

                await FirebaseAuthMethods(FirebaseAuth.instance).signOut();
                // Firebase 로그아웃
                //await _auth.signOut();
                //await _googleSignIn.signOut();

                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              }
            },
            itemBuilder: (BuildContext bc) {
              return [
                PopupMenuItem(
                  child: Text(
                    '수정하기',
                    style: TextStyle(
                      color: Color(0xFFffffff),
                    ),
                  ),
                  value: '/edit',
                ),
                PopupMenuItem(
                  child: Text(
                    '로그아웃',
                    style: TextStyle(
                      color: Color(0xFFffffff),
                    ),
                  ),
                  value: '/logout',
                ),
                PopupMenuItem(
                  child: Text(
                    '회원탈퇴',
                    style: TextStyle(
                      color: Color(0xFFffffff),
                    ),
                  ),
                  value: '/signout',
                ),
              ];
            },
          ),
        ],
      ),
      /*
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF22232A),
        child: Container(
          width: size.width,
          //height: 60.0,
          height: size.height * 0.085,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                  //Route route = MaterialPageRoute(builder: (context) => HomePage());
                  //Navigator.pushReplacement(context, route);
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => HomePage(reload: false,),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                  /*
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );

                   */
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.home_filled,
                      color: Color(0xFF757575),
                      //size: 30.0,
                      size: size.width * 0.0763,
                    ),
                    Text(
                      '홈',
                      style: TextStyle(
                        color: Color(0xFF757575),
                        //fontSize: 10.0,
                        fontSize: size.width * 0.0253,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                  //Route route = MaterialPageRoute(builder: (context) => ChatListPage());
                  //Navigator.pushReplacement(context, route);
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => ChatListPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                  /*
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => ChatListPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );

                   */
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Color(0xFF757575),
                      //size: 30.0,
                      size: size.width * 0.0763,
                    ),
                    Text(
                      '내 대화',
                      style: TextStyle(
                        color: Color(0xFF757575),
                        //fontSize: 10.0,
                        fontSize: size.width * 0.0253,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                  //Route route = MaterialPageRoute(builder: (context) => MatchingPage());
                  //Navigator.pushReplacement(context, route);
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => MapPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                  /*
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => MatchingPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );

                   */
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.map,
                      color: Color(0xFF757575),
                      //size: 30.0,
                      size: size.width * 0.0763,
                    ),
                    Text(
                      '피트니스장',
                      style: TextStyle(
                        color: Color(0xFF757575),
                        //fontSize: 10.0,
                        fontSize: size.width * 0.0253,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                  //Route route = MaterialPageRoute(builder: (context) => MatchingPage());
                  //Navigator.pushReplacement(context, route);
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => MatchingPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                  /*
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => MatchingPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );

                   */
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Color(0xFF757575),
                      //size: 30.0,
                      size: size.width * 0.0763,
                    ),
                    Text(
                      '매칭',
                      style: TextStyle(
                        color: Color(0xFF757575),
                        //fontSize: 10.0,
                        fontSize: size.width * 0.0253,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                  //Route route = MaterialPageRoute(builder: (context) => ProfilePage());
                  //Navigator.pushReplacement(context, route);
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.person,
                      color: Color(0xFFffffff),
                      size: size.width * 0.0763,
                    ),
                    Text(
                      '프로필',
                      style: TextStyle(
                        color: Color(0xFFffffff),
                        //fontSize: 10.0,
                        fontSize: size.width * 0.0253,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

       */
      bottomNavigationBar: bottomNavigationBar(context, 5),
      body: SafeArea(
        child : FutureBuilder<int> (
          future: getReviewProfile(),
          builder: (context, snapshot) {
            print('snapshot data : ${snapshot.hasData}');
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: Column(
                    children: [
                      Container(
                        width: size.width - 34,
                        padding: EdgeInsets.all(0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.network(
                                '${UserData['user_profile_img']}',
                                width: 70.0,
                                height: 70.0,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return Image.asset(
                                    'assets/images/profile_null_image.png',
                                    width: 70.0,
                                    height: 70.0,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${UserData["user_nickname"]}(${UserData["user_gender"] == true ? '남' : '여'})',
                              style: TextStyle(
                                color: Color(0xFFffffff),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: size.width - 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '기본 루틴',
                              style: TextStyle(
                                color: Color(0xFFffffff),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                '${getSchedule()}',
                                style: TextStyle(
                                  color: Color(0xFF2975CF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: size.width - 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: UserData["user_weekday"]["mon"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  width: 1,
                                  color: UserData["user_weekday"]["mon"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                                ),
                              ),

                              alignment: Alignment.center,
                              child: Text(
                                '월',
                                style: TextStyle(
                                    color: UserData["user_weekday"]["mon"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: UserData["user_weekday"]["tue"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  width: 1,
                                  color: UserData["user_weekday"]["tue"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '화',
                                style: TextStyle(
                                    color: UserData["user_weekday"]["tue"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: UserData["user_weekday"]["wed"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  width: 1,
                                  color: UserData["user_weekday"]["wed"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '수',
                                style: TextStyle(
                                    color: UserData["user_weekday"]["wed"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: UserData["user_weekday"]["thu"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  width: 1,
                                  color: UserData["user_weekday"]["thu"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '목',
                                style: TextStyle(
                                    color: UserData["user_weekday"]["thu"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: UserData["user_weekday"]["fri"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  width: 1,
                                  color: UserData["user_weekday"]["fri"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '금',
                                style: TextStyle(
                                    color: UserData["user_weekday"]["fri"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: UserData["user_weekday"]["sat"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  width: 1,
                                  color: UserData["user_weekday"]["sat"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '토',
                                style: TextStyle(
                                    color: UserData["user_weekday"]["sat"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: UserData["user_weekday"]["sun"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  width: 1,
                                  color: UserData["user_weekday"]["sun"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '일',
                                style: TextStyle(
                                    color: UserData["user_weekday"]["sun"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: size.width - 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '기본 정보',
                              style: TextStyle(
                                color: Color(0xFFffffff),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: size.width - 40,
                        height: 112,
                        decoration: BoxDecoration(
                          color: Color(0xFF22232A),
                          border: Border.all(width: 1, color: Color(0xFF757575)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(22, 15, 22, 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_pin,
                                          color: Color(0xFF2975CF),
                                          size: 17,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          '내 동네',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${UserData["user_address"]}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFffffff),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.fitness_center,
                                          color: Color(0xFF2975CF),
                                          size: 17,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          '내 피트니스장',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${UserCenterName}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFffffff),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.groups,
                                          color: Color(0xFF2975CF),
                                          size: 17,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          '매칭 수',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${snapshot.data.toString()}회',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFffffff),
                                    ),
                                  ),
                                ],
                              ),
                              /*
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.thumb_up_alt,
                                  color: Color(0xFF2975CF),
                                  size: 17,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  '매칭 후기',
                                  style: TextStyle(
                                    color: Color(0xFFffffff),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '좋아요',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFffffff),
                            ),
                          ),
                        ],
                      ),
                      */
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: size.width - 40,
                        height: 1,
                        color: Color(0xFF757575),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: size.width - 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '메이트 리뷰',
                              style: TextStyle(
                                color: Color(0xFFffffff),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data,
                        itemBuilder: (context, index) {
                          return Container(
                            width: size.width - 40,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100.0),
                                      child: Image.network(
                                        '${reviewImg[index]}',
                                        width: 35.0,
                                        height: 35.0,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                          return Image.asset(
                                            'assets/images/profile_null_image.png',
                                            fit: BoxFit.cover,
                                            width: 35.0,
                                            height: 35.0,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      '${reviewName[index]}',
                                      style: TextStyle(
                                        color: Color(0xFFffffff),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 45),
                                  child: Container(
                                    width: size.width - 85,
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 100,
                                            strutStyle: StrutStyle(fontSize: 16),
                                            text: TextSpan(
                                              text: '${reviewContext[index]}',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return SizedBox();
            }
            // 기본적으로 로딩 Spinner를 보여줍니다.
            return Center(child: CircularProgressIndicator());
          },
        ),
        /*
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: size.width - 34,
                padding: EdgeInsets.all(0),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.network(
                        '${UserData['user_profile_img']}',
                        width: 70.0,
                        height: 70.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${UserData["user_nickname"]}(${UserData["user_gender"] == true ? '남' : '여'})',
                      style: TextStyle(
                        color: Color(0xFFffffff),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: size.width - 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '기본 루틴',
                      style: TextStyle(
                        color: Color(0xFFffffff),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        '${getSchedule()}',
                        style: TextStyle(
                          color: Color(0xFF2975CF),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: size.width - 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: UserData["user_weekday"]["mon"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          width: 1,
                          color: UserData["user_weekday"]["mon"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                        ),
                      ),

                      alignment: Alignment.center,
                      child: Text(
                        '월',
                        style: TextStyle(
                            color: UserData["user_weekday"]["mon"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: UserData["user_weekday"]["tue"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          width: 1,
                          color: UserData["user_weekday"]["tue"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '화',
                        style: TextStyle(
                            color: UserData["user_weekday"]["tue"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: UserData["user_weekday"]["wed"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          width: 1,
                          color: UserData["user_weekday"]["wed"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '수',
                        style: TextStyle(
                            color: UserData["user_weekday"]["wed"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: UserData["user_weekday"]["thu"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          width: 1,
                          color: UserData["user_weekday"]["thu"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '목',
                        style: TextStyle(
                            color: UserData["user_weekday"]["thu"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: UserData["user_weekday"]["fri"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          width: 1,
                          color: UserData["user_weekday"]["fri"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '금',
                        style: TextStyle(
                            color: UserData["user_weekday"]["fri"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: UserData["user_weekday"]["sat"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          width: 1,
                          color: UserData["user_weekday"]["sat"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '토',
                        style: TextStyle(
                            color: UserData["user_weekday"]["sat"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: UserData["user_weekday"]["sun"] == true ? Color(0xFF2975CF) : Color(0xFF22232A),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          width: 1,
                          color: UserData["user_weekday"]["sun"] == true ? Color(0xFF2975CF) : Color(0xFF878E97),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '일',
                        style: TextStyle(
                            color: UserData["user_weekday"]["sun"] == true ? Color(0xFFffffff) : Color(0xFF878E97),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: size.width - 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '기본 정보',
                      style: TextStyle(
                        color: Color(0xFFffffff),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: size.width - 40,
                height: 112,
                decoration: BoxDecoration(
                  color: Color(0xFF22232A),
                  border: Border.all(width: 1, color: Color(0xFF757575)),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 15, 22, 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Color(0xFF2975CF),
                                  size: 17,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  '내 동네',
                                  style: TextStyle(
                                    color: Color(0xFFffffff),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${UserData["user_address"]}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFffffff),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.fitness_center,
                                  color: Color(0xFF2975CF),
                                  size: 17,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  '내 피트니스장',
                                  style: TextStyle(
                                    color: Color(0xFFffffff),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${UserCenterName}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFffffff),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.groups,
                                  color: Color(0xFF2975CF),
                                  size: 17,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  '매칭 수',
                                  style: TextStyle(
                                    color: Color(0xFFffffff),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${reviewNumber.toString()}회',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFffffff),
                            ),
                          ),
                        ],
                      ),
                      /*
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.thumb_up_alt,
                                  color: Color(0xFF2975CF),
                                  size: 17,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  '매칭 후기',
                                  style: TextStyle(
                                    color: Color(0xFFffffff),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '좋아요',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFffffff),
                            ),
                          ),
                        ],
                      ),
                      */
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                width: size.width - 40,
                height: 1,
                color: Color(0xFF757575),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: size.width - 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '메이트 리뷰',
                      style: TextStyle(
                        color: Color(0xFFffffff),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              FutureBuilder<int> (
                future: getReviewProfile(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data,
                      itemBuilder: (context, index) {
                        return Container(
                          width: size.width - 40,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: Image.network(
                                      '${reviewImg[index]}',
                                      width: 35.0,
                                      height: 35.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    '${reviewName[index]}',
                                    style: TextStyle(
                                      color: Color(0xFFffffff),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 45),
                                child: Container(
                                  width: size.width - 85,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 100,
                                          strutStyle: StrutStyle(fontSize: 16),
                                          text: TextSpan(
                                            text: '${reviewContext[index]}',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return SizedBox();
                  }
                  // 기본적으로 로딩 Spinner를 보여줍니다.
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),

         */
      ),
    );
  }
}

