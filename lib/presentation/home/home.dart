import 'package:fitmate/ui/bar_widget.dart';
import 'package:fitmate/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/post_api.dart';
import '../post/post.dart';
import 'components/home_board_widget.dart';

class HomePage extends StatefulWidget {
  bool reload;

  HomePage({Key? key, required this.reload}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final postApi = PostApi();
  final barWidget = BarWidget();
  final homeBoardWidget = HomeBoardWidget();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteTheme,
      appBar: barWidget.appBar(context),
      bottomNavigationBar: barWidget.bottomNavigationBar(context, 1),
      body: SafeArea(
        child: FutureBuilder<List>(
          future: postApi.getPost(true),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        color: Color(0xFF22232A),
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
                              SizedBox(width: 12,),
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
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) => PostPage(reload: true,)));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      HomeBoardWidget(),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/icon/home_location_icon.svg",
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(width: 12,),
                          Text(
                            '우리동네',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // 기본적으로 로딩 Spinner를 보여줍니다.
            return Center(child: CircularProgressIndicator());
            //return SizedBox();
          },
        ),
      ),
    );
  }
}
