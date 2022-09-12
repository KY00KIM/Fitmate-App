import 'package:fitmate/domain/instance_preference/location.dart';
import 'package:fitmate/presentation/home/components/home_banner_widget.dart';
import 'package:fitmate/ui/bar_widget.dart';
import 'package:fitmate/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/post_api.dart';
import '../../domain/repository/home_api_repository.dart';
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
  locationController locator = locationController();

  @override
  void initState() {
    super.initState();
    locator.initListner();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteTheme,
      appBar: barWidget.appBar(context),
      bottomNavigationBar: barWidget.bottomNavigationBar(context, 1),
      body: SafeArea(
        child: FutureBuilder<Map>(
          future: homeApiRepo.getHomeRepo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      children: [
                        HomeBannerWidget(
                          banner: snapshot.data!['banners'],
                        ),
                        SizedBox(
                          height: 26,
                        ),
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
                          posts: snapshot.data!['posts'],
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
                          fitness_center: snapshot.data!['fitness_center'],
                        ),
                        SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // 기본적으로 로딩 Spinner를 보여줍니다.
            //return Center(child: CircularProgressIndicator());
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                width: size.width,
                height: size.height,
                color: whiteTheme,
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: size.width - 40,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Color(0xFF3F51B5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(
                        height: 26,
                      ),
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
                      Container(
                    height: 420,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Container(
                            margin: EdgeInsets.fromLTRB(8, 10, 8, 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xFF3F51B5),
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
                            width: 292,
                          );
                      },
                    ),
                  ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
