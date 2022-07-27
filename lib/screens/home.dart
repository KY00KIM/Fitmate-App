import 'dart:convert';

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


import 'chatList.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  //const HomePage({Key? key, required String this.idToken, required String this.userId}) : super(key: key);
  //final String idToken;
  //final String userId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List homeData = [];

  Future<List> getPosts() async{
    http.Response response = await http.get(Uri.parse("${baseUrl}posts"),
        headers: {"Authorization" : "$IdToken", "Content-Type": "application/json; charset=UTF-8"},
    );
    // ignore: unused_local_variable
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    
    if(resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();
      
      http.Response response = await http.post(Uri.parse("${baseUrl}posts"),
          headers: {'Authorization' : '$IdToken', 'Content-Type': 'application/json; charset=UTF-8',},
      );
    }
    if(response.statusCode == 400) return [];
    else {
      return resBody["data"];
    }
  }

  @override
  void initState() {
    super.initState();
    //homeData = getPosts() as List;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
          height: size.height * 0.08,
          child: Row(
            children: [
              SizedBox(
                //width: 15,
                width: size.width * 0.04,
              ),
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
              SizedBox(
                //width: 10.0,
                width: size.width * 0.025,
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
              SizedBox(
                //width: 80.0,
                width: size.width * 0.24,
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
                      Icons.fitness_center,
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
              SizedBox(
                width: size.width * 0.025,
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
      floatingActionButton: Container(
        margin: EdgeInsets.only(top: 30.0),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color(0xFF22232A),
        ),
        child: FloatingActionButton(
            child: Icon(
              Icons.add,
              size: 40,
            ),
            backgroundColor: Color(0xFF303037),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => WritingPage()));
            }
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.zero,
                  minimumSize: Size(size.width, 140),
                  maximumSize: Size(size.width, 140),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(0),
                  ),
                  primary: Color(0xFF22232A)
                ),
                onPressed: () {
                  print("버튼 클릭");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailMachingPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          'https://picsum.photos/250?image=9',                          
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 230,
                                  child: Flexible(
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      strutStyle: StrutStyle(fontSize: 16),
                                      text: TextSpan(
                                        text: '테스트테스트테스트테스틑테스트테스트',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  '6/25  |  나쁜개구리',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF757575),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Image.network(
                                    'https://picsum.photos/250?image=9',
                                    width: 25.0,
                                    height: 25.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '토마스 박',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF757575),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 2,
                width: size.width - 40,
                color: Color(0xFF303037),
              ),
              /*
              ListView.builder(
                itemCount: homeData.length, 
                itemBuilder: (BuildContext context, int index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.zero,
                      minimumSize: Size(size.width, 140),
                      maximumSize: Size(size.width, 140),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(0),
                      ),
                      primary: Color(0xFF22232A)
                    ),
                    onPressed: () {
                      print("버튼 클릭");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailMachingPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              '${homeData[index]["post_img"]}',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 230,
                                      child: Flexible(
                                        child: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          strutStyle: StrutStyle(fontSize: 16),
                                          text: TextSpan(
                                            text: '${homeData[index]["post_title"]}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '6/25  |  ${homeData[index]["promise_location"]}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF757575),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: Image.network(
                                        'https://picsum.photos/250?image=9',
                                        width: 25.0,
                                        height: 25.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '토마스 박',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF757575),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  Container(
                    height: 2,
                    width: size.width - 40,
                    color: Color(0xFF303037),
                  );
                }
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
