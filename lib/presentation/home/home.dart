import 'dart:io';

import 'package:fitmate/domain/facebook_pref.dart';
import 'package:fitmate/presentation/home/components/home_banner_widget.dart';
import 'package:fitmate/presentation/home/components/home_head_text.dart';
import 'package:fitmate/ui/bar_widget.dart';
import 'package:fitmate/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/util.dart';

import '../../data/post_api.dart';
import '../../domain/repository/home_api_repository.dart';
import '../../domain/util.dart';
import '../../main.dart';
import '../calender/calender.dart';
import '../chat_list/chat_list.dart';
import '../map/map.dart';
import '../post/post.dart';
import '../profile/profile.dart';
import '../writing/writing.dart';
import 'components/home_board_widget.dart';
import 'components/home_town_widget.dart';


class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {
  final barWidget = BarWidget();
  final homeApiRepo = HomeApiRepository();
  final double iconSize = 32.0;
  final String iconSource = "assets/icon/bar_icons/";

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // stopTrackManager();
      if (Platform.isIOS) checkAndRequestTrackingPermission();
    });
    super.initState();
    locator.initListner();
    log("췌구첵");
  }

  List _pages = [
    PostPage(
      reload: false,
    ),
    ChatListPage(),
    MapPage(),
    CalenderPage(),
    ProfilePage(),
  ];
  final _navigatorKeyList =
      List.generate(5, (index) => GlobalKey<NavigatorState>());
  int _currentIndex = 0;


  /*
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !(await _navigatorKeyList[_currentIndex]
            .currentState!
            .maybePop());
      },
      child: DefaultTabController(
        animationDuration: Duration(milliseconds: 0),
        length: 5,
        child: Scaffold(
          extendBody: true,
          body: new TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: _pages.map(
              (page) {
                int index = _pages.indexOf(page);
                return CustomNavigator(
                  page: page,
                  navigatorKey: _navigatorKeyList[index],
                );
              },
            ).toList(),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(55, 84, 170, 0.1),
                  spreadRadius: 4,
                  blurRadius: 12,
                ),
              ],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
              color: whiteTheme,
            ),
            height: 60.0,
            child: TabBar(
              indicator: BoxDecoration(
                color: whiteTheme,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
              ),
              isScrollable: false,
              automaticIndicatorColorAdjustment: false,
              onTap: (index) => setState(() {
                _currentIndex = index;
                print("index : $index");
              }),
              tabs: [
                Tab(
                  icon: _currentIndex == 0
                      ? SvgPicture.asset(
                    // 5
                    "${iconSource}home_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  )
                      : SvgPicture.asset(
                    // 5
                    "${iconSource}Inactive_home_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
                Tab(
                  icon : _currentIndex == 1
                      ? SvgPicture.asset(
                    // 5
                    "${iconSource}chatting_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  )
                      : SvgPicture.asset(
                    // 5
                    "${iconSource}Inactive_chatting_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
                Tab(
                  icon: _currentIndex == 2
                      ? SvgPicture.asset(
                    // 5
                    "${iconSource}map_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  )
                      : SvgPicture.asset(
                    // 5
                    "${iconSource}Inactive_map_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
                Tab(
                  icon: _currentIndex == 3
                      ? SvgPicture.asset(
                    // 5
                    "${iconSource}calender_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  )
                      : SvgPicture.asset(
                    // 5
                    "${iconSource}Inactive_calender_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
                Tab(
                  icon: _currentIndex == 4
                      ? SvgPicture.asset(
                    // 5
                    "${iconSource}profile_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  )
                      : SvgPicture.asset(
                    // 5
                    "${iconSource}Inactive_profile_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
              ],
            ),
          ),
          /*
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(55, 84, 170, 0.1),
                  spreadRadius: 4,
                  blurRadius: 12,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
              child: BottomAppBar(
                elevation: 10,
                color: whiteTheme,
                child: Container(
                  width: size.width,
                  height: 60.0,
                  child: Theme(
                    data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            /*
                            if (_currentIndex != 1) {
                              //Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                              if(_currentIndex == 3) {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) =>
                                        HomePage(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) =>
                                        HomePage(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              }
                            }
                             */
                            _currentIndex = 1;
                          },
                          icon: _currentIndex == 1
                              ? SvgPicture.asset(
                            // 5
                            "${iconSource}home_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          )
                              : SvgPicture.asset(
                            // 5
                            "${iconSource}Inactive_home_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            /*
                            if (_currentIndex != 2) {
                              //Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                              if(_currentIndex == 3) {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) =>
                                        ChatListPage(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) =>
                                        ChatListPage(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              }
                            }

                             */
                          },
                          icon: _currentIndex == 2
                              ? SvgPicture.asset(
                            // 5
                            "${iconSource}chatting_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          )
                              : SvgPicture.asset(
                            // 5
                            "${iconSource}Inactive_chatting_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            /*
                            if (_currentIndex != 3) {
                              //Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                              print("map : ${mapOpend}");
                              if(mapOpend) {
                                Navigator.pop(context);
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) =>
                                        MapPage(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              }
                              mapOpend = true;
                            }

                             */
                          },
                          icon: _currentIndex == 3
                              ? SvgPicture.asset(
                            // 5
                            "${iconSource}map_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          )
                              : SvgPicture.asset(
                            // 5
                            "${iconSource}Inactive_map_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            /*
                            if (_currentIndex != 4) {
                              //Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                              if(_currentIndex == 3) {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) =>
                                        CalenderPage(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) =>
                                        CalenderPage(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              }
                            }

                             */
                          },
                          icon: _currentIndex == 4
                              ? SvgPicture.asset(
                            // 5
                            "${iconSource}calender_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          )
                              : SvgPicture.asset(
                            // 5
                            "${iconSource}Inactive_calender_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            /*
                            if (_currentIndex != 5) {
                              //Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                              if(_currentIndex == 3) {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) =>
                                        ProfilePage(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) =>
                                        ProfilePage(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              }
                            }

                             */
                          },
                          icon: _currentIndex == 5
                              ? SvgPicture.asset(
                            // 5
                            "${iconSource}profile_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          )
                              : SvgPicture.asset(
                            // 5
                            "${iconSource}Inactive_profile_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              /*
              child: TabBar(
                isScrollable: false,
                automaticIndicatorColorAdjustment: true,
                onTap: (index) => setState(() {
                  _currentIndex = index;
                  print("index : $index");
                }),
                tabs: const [
                  Tab(
                    icon: Icon(
                      Icons.home,
                    ),
                    text: '플라토',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.calendar_today,
                    ),
                    text: '캘린더',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.email,
                    ),
                    text: '쪽지',
                  ),
                ],
              ),

               */
            ),
          ),

           */
        ),
      ),
    );
  }

   */


  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Size size = MediaQuery.of(context).size;
    print("방문 여부 : $visit");
    print("map 방문 여부 : $mapOpend");
    return Scaffold(
      backgroundColor: whiteTheme,
      appBar: barWidget.appBar(context),
      bottomNavigationBar: barWidget.bottomNavigationBar(context, 1),
      body: SafeArea(
        child: homeDataGet
            ? ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: [
                        HomeBannerWidget(
                          banner: banners,
                        ),
                        HomeHeadTextWidget(),
                        HomeBoardWidget(
                          posts: posts,
                        ),
                        /*
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icon/home_board_icon.svg",
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            '게시판',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xFFF2F3F7),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFffffff),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(-2, -2),
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(55, 84, 170, 0.1),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Theme(
                          data: ThemeData(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: IconButton(
                            icon: SvgPicture.asset(
                              "assets/icon/right_arrow_icon.svg",
                              width: 18,
                              height: 18,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostPage(
                                        reload: true,
                                      )));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  HomeBoardWidget(
                    posts: posts,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        "assets/icon/home_location_icon.svg",
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        '우리동네',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  HomeTownWidget(
                    fitness_center: myFitnessCenter,
                  ),

                   */
                      ],
                    ),
                  ),
                ),
              )
            : FutureBuilder<Map>(
                future: homeApiRepo.getHomeRepo(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ScrollConfiguration(
                      behavior:
                          const ScrollBehavior().copyWith(overscroll: false),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            children: [
                              HomeBannerWidget(
                                banner: snapshot.data!['banners'],
                              ),
                              HomeHeadTextWidget(),
                              HomeBoardWidget(
                                posts: snapshot.data!['posts'],
                              ),
                              /*
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icon/home_board_icon.svg",
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                const Text(
                                  '게시판',
                                  style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFFF2F3F7),
                                boxShadow: [
                                  const BoxShadow(
                                    color: Color(0xFFffffff),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: Offset(-2, -2),
                                  ),
                                  const BoxShadow(
                                    color: Color.fromRGBO(55, 84, 170, 0.1),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Theme(
                                data: ThemeData(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                ),
                                child: IconButton(
                                  icon: SvgPicture.asset(
                                    "assets/icon/right_arrow_icon.svg",
                                    width: 18,
                                    height: 18,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PostPage(
                                              reload: true,
                                            )));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        HomeBoardWidget(
                          posts: snapshot.data!['posts'],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              "assets/icon/home_location_icon.svg",
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            const Text(
                              '우리동네',
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        HomeTownWidget(
                          fitness_center: snapshot.data!['fitness_center'],
                        ),
                         */
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  // 기본적으로 로딩 Spinner를 보여줍니다.
                  if (myFitnessCenter != null)
                    return ScrollConfiguration(
                      behavior:
                          const ScrollBehavior().copyWith(overscroll: false),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            children: [
                              HomeBannerWidget(
                                banner: banners,
                              ),
                              HomeHeadTextWidget(),
                              HomeBoardWidget(
                                posts: posts,
                              ),
                              /*
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icon/home_board_icon.svg",
                                  width: 24,
                                  height: 24,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  '게시판',
                                  style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFFF2F3F7),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFffffff),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: Offset(-2, -2),
                                  ),
                                  BoxShadow(
                                    color: Color.fromRGBO(55, 84, 170, 0.1),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Theme(
                                data: ThemeData(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                ),
                                child: IconButton(
                                  icon: SvgPicture.asset(
                                    "assets/icon/right_arrow_icon.svg",
                                    width: 18,
                                    height: 18,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PostPage(
                                              reload: true,
                                            )));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        HomeBoardWidget(
                          posts: posts,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              "assets/icon/home_location_icon.svg",
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              '우리동네',
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        HomeTownWidget(
                          fitness_center: myFitnessCenter,
                        ),

                         */
                            ],
                          ),
                        ),
                      ),
                    );
                  else
                    return Container(
                        width: size.width,
                        height: size.height,
                        child: Center(child: CircularProgressIndicator()));
                },
              ),
      ),
    );
  }

}

class CustomNavigator extends StatefulWidget {
  final Widget page;
  final Key navigatorKey;

  const CustomNavigator(
      {Key? key, required this.page, required this.navigatorKey})
      : super(key: key);

  @override
  _CustomNavigatorState createState() => _CustomNavigatorState();
}

class _CustomNavigatorState extends State<CustomNavigator>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (context) => widget.page),
    );
  }
}


/*
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: Scaffold(
          bottomNavigationBar: Container(
            color: Colors.blue,
            child: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
          ),
          appBar: AppBar(
            title: Text("Home"),
          ),
          body: new TabBarView(
            children: <Widget>[
              new HomeTab1(),
              new HomeTab2(),
              new HomeTab3(),
            ],
          )),
    );
  }
}


 */
class HomeTab1 extends StatefulWidget {
  HomeTab1({Key? key}) : super(key: key);

  @override
  State<HomeTab1> createState() => _HomeTab1State();
}

class _HomeTab1State extends State<HomeTab1> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Home1"),
            new Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: new FlatButton.icon(
                onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage()));
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WritingPage()));
                },
                color: Colors.red,
                textColor: Colors.white,
                icon: const Icon(Icons.navigate_next, size: 18.0),
                label: const Text('Go To Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTab2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Home2"),
          new Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: new FlatButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed("/detail");
              },
              color: Colors.red,
              textColor: Colors.white,
              icon: const Icon(Icons.navigate_next, size: 18.0),
              label: const Text('Go To Details'),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeTab3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Home3"),
          new Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: new FlatButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed("/detail");
              },
              color: Colors.red,
              textColor: Colors.white,
              icon: const Icon(Icons.navigate_next, size: 18.0),
              label: const Text('Go To Details'),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("Details"),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Details"),
            ],
          ),
        ));
  }
}