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
import '../post/post.dart';
import 'components/home_board_widget.dart';
import 'components/home_town_widget.dart';

class HomePage extends StatefulWidget {
  bool reload;

  HomePage({Key? key, required this.reload}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final postApi = PostApi();
  final barWidget = BarWidget();
  final homeApiRepo = HomeApiRepository();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // stopTrackManager();
      if (Platform.isIOS) checkAndRequestTrackingPermission();
    });
    super.initState();
    locator.initListner();
  }

  @override
  Widget build(BuildContext context) {
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
                              const SizedBox(
                                height: 26,
                              ),
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
