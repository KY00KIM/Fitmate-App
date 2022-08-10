import 'dart:convert';
//import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/screens/matching.dart';
import 'package:fitmate/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitmate/screens/writing.dart';
import 'package:fitmate/screens/detail.dart';
import 'package:fitmate/screens/notice.dart';
import 'package:http/http.dart' as http;
import 'package:fitmate/utils/data.dart';
import 'dart:developer';


import 'chatList.dart';
import 'map.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  //const HomePage({Key? key, required String this.idToken, required String this.userId}) : super(key: key);
  //final String idToken;
  //final String userId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List usersName = [];
  List userImage = [];
  List centerName = [];

  Future<List> getPost() async {
    print("idtoken : $IdToken");
    print("skflsjeifslf");
    http.Response response = await http.get(Uri.parse("${baseUrl}posts"),
      headers: {"Authorization" : "bearer $IdToken", "Content-Type": "application/json; charset=UTF-8"},
    );
    print("response 완료");
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    print("아 몰라");
    if(response.statusCode != 200 && resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();

      http.Response response = await http.post(Uri.parse("${baseUrl}posts"),
        headers: {'Authorization' : 'bearer $IdToken', 'Content-Type': 'application/json; charset=UTF-8',},
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    for(int i = 0; i < resBody['data'].length; i++) {
      http.Response responseFitness = await http.get(Uri.parse("${baseUrl}fitnesscenters/${resBody['data'][i]['promise_location'].toString()}"), headers: {
        // ignore: unnecessary_string_interpolations
        "Authorization" : "bearer ${IdToken.toString()}",
        "fitnesscenterId" : "${resBody['data'][i]['promise_location'].toString()}"});

      if(responseFitness.statusCode == 200) {
        var resBody2 = jsonDecode(utf8.decode(responseFitness.bodyBytes));

        centerName.add(resBody2["data"]["center_name"]);
      }

      http.Response responseUser = await http.get(Uri.parse("${baseUrl}users/${resBody['data'][i]['user_id'].toString()}"), headers: {
        // ignore: unnecessary_string_interpolations
        "Authorization" : "bearer ${IdToken.toString()}",
        "Content-Type" : "application/json; charset=UTF-8",
        "userId" : "${resBody['data'][i]['user_id'].toString()}"});
      var resBody3 = jsonDecode(utf8.decode(responseUser.bodyBytes));

      userImage.add(resBody3['data']['user_profile_img']);
      usersName.add(resBody3['data']['user_nickname']);
    }

    print("반환 준비 : ${response.statusCode}");
    if(response.statusCode == 200) {
      print("반환 갑니다잉");
      return resBody["data"];
    }
    else {
      print("what the fuck");
      throw Exception('Failed to load post');
    }
  }


  @override
  void initState() {
    super.initState();
  }
  // Text('${snapshot.data?[index]['post_title']}');
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    print(UserData);
    return Scaffold(
      backgroundColor: Color(0xFF22232A),
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
          padding: EdgeInsets.only(left: 7.0),
          child: Image.asset(
            'assets/images/fitmate_logo.png',
            height: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder : (context) => NoticePage()));
            },
            icon: Padding(
              padding: EdgeInsets.only(right: 200),
              child: Icon(
                Icons.notifications_none,
                color: Color(0xFFffffff),
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
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
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.home_filled,
                      color: Color(0xFFffffff),
                      //size: 30.0,
                      size: size.width * 0.0763,
                    ),
                    Text(
                      '홈',
                      style: TextStyle(
                        color: Color(0xFFffffff),
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
                      Icons.fitness_center,
                      color: Color(0xFF757575),
                      //size: 30.0,
                      size: size.width * 0.0763,
                    ),
                    Text(
                      '헬스장',
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
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                  /*
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
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
                      Icons.person,
                      color: Color(0xFF757575),
                      size: size.width * 0.0763,
                    ),
                    Text(
                      '프로필',
                      style: TextStyle(
                        color: Color(0xFF757575),
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
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 40,
          ),
          backgroundColor: Color(0xFF303037),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => WritingPage()));
          }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: FutureBuilder<List> (
          future: getPost(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.zero,
                        minimumSize: Size(size.width, 144),
                        maximumSize: Size(size.width, 144),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(0),
                        ),
                        primary: Color(0xFF22232A)
                    ),
                    onPressed: () {
                      print("버튼 클릭 : ${snapshot.data?[index]['_id']}");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailMachingPage('${snapshot.data?[index]['_id']}')));
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  "${snapshot.data?[index]['post_img']}",
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    return Image.asset(
                                        'assets/images/dummy.jpg',
                                      width: 100.0,
                                      height: 100.0,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                height: 100.0,
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: size.width - 155,
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: RichText(
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  strutStyle: StrutStyle(fontSize: 16),
                                                  text: TextSpan(
                                                    text: '${snapshot.data?[index]['post_title']}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Container(
                                          width: size.width - 155,
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: RichText(
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  strutStyle: StrutStyle(fontSize: 16),
                                                  text: TextSpan(
                                                    text: '${snapshot.data?[index]['promise_date'].toString().substring(5,7)}/${snapshot.data?[index]['promise_date'].toString().substring(8,10)}  |  ${centerName[index]}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF757575),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(50.0),
                                          child: Image.network(
                                            '${userImage[index]}',
                                            width: 25.0,
                                            height: 25.0,
                                            fit: BoxFit.cover,
                                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                              return Image.asset(
                                                'assets/images/dummy.jpg',
                                                width: 25.0,
                                                height: 25.0,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: size.width - 190,
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: RichText(
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  strutStyle: StrutStyle(fontSize: 16),
                                                  text: TextSpan(
                                                    text: '${usersName[index]}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF757575),
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 2,
                            width: size.width - 40,
                            color: Color(0xFF303037),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // 기본적으로 로딩 Spinner를 보여줍니다.
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}


/*

 */