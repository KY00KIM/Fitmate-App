import 'package:fitmate/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:fitmate/screens/writing.dart';
import 'chatList.dart';
import 'home.dart';
import 'notice.dart';

class MatchingPage extends StatefulWidget {
  const MatchingPage({Key? key}) : super(key: key);

  @override
  State<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends State<MatchingPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    initializeDateFormatting(Localizations.localeOf(context).languageCode);

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
            "매칭",
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
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => NoticePage()));
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
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.fitness_center,
                      color: Color(0xFFffffff),
                      //size: 30.0,
                      size: size.width * 0.0763,
                    ),
                    Text(
                      '매칭',
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
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jul 2022',
                style: TextStyle(
                  color: Color(0xFFffffff),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: size.width - 50,
                child: TableCalendar(
                  locale: 'ko_KO',
                  focusedDay: DateTime.now(),
                  firstDay: DateTime(2022,7,1),
                  lastDay: DateTime(2022,7,31),
                  headerVisible: false,
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(
                      color: Color(0xFFDADADA),
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                    weekendTextStyle: TextStyle(
                      color: Color(0xFFDADADA),
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Color(0xFF2975CF),
                      shape: BoxShape.circle,

                    ),
                    todayTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFDADADA),
                      fontSize: 17,
                    ),
                    outsideDaysVisible: false,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 3,
                    color: Color(0xFF3D3D3D),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: size.width - 50,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFF2975CF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(25, 15, 25, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '우파루파님과 매칭 운동 Day입니다!',
                        style: TextStyle(
                          color: Color(0xFFffffff),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        '장소 : 우릉 피트니스장      시간 : 3:20pm',
                        style: TextStyle(
                          color: Color(0xFFDADADA),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.network(
                              'https://picsum.photos/250?image=9',
                              width: 20.0,
                              height: 20.0,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            '토마스 박',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFFDADADA),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
