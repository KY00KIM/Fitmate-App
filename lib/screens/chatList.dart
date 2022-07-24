import 'package:fitmate/screens/chat.dart';
import 'package:fitmate/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitmate/screens/detail.dart';

import 'package:fitmate/screens/writing.dart';
import 'home.dart';
import 'matching.dart';
import 'notice.dart';


class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
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
          padding: EdgeInsets.only(left: 5.0),
          child: Text(
            "채팅",
            style: TextStyle(
              color: Color(0xFFffffff),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
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
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
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
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Color(0xFFffffff),
                      //size: 30.0,
                      size: size.width * 0.0763,
                    ),
                    Text(
                      '내 대화',
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
                  //Navigator.pushReplacement(context, route);
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                  /*
                  Navigator.of(context).push(
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
          child: ListBody(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.zero,
                    minimumSize: Size(size.width, 90),
                    maximumSize: Size(size.width, 90),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(0),
                    ),
                    primary: Color(0xFF22232A)
                ),
                onPressed: () {
                  //Route route = MaterialPageRoute(builder: (context) => ChatPage());
                  //Navigator.pushReplacement(context, route);
                  //Navigator.push(context, CupertinoPageRoute(builder : (context) => ChatPage()));
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => ChatPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.network(
                          'http://newsimg.hankookilbo.com/2018/03/07/201803070494276763_1.jpg',
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '토마스 박',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text(
                                '  광주 광산구',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF757575),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            width: size.width - 110,
                            child: Flexible(
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                strutStyle: StrutStyle(fontSize: 16),
                                text: TextSpan(
                                  text: '안녕하세요아아아아아아아ㅏ아아dkdkdk아아ㅏ~',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 1,
                width: size.width,
                color: Color(0xFF303037),
              ),
            ],
          ),
        ),
      ),
    );
  }
}