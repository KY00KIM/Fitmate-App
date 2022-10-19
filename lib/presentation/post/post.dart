import 'dart:developer';

import 'package:fitmate/ui/bar_widget.dart';
import 'package:fitmate/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;

import '../../data/post_api.dart';
import '../../domain/repository/home_api_repository.dart';
import '../../domain/repository/post_api_repository.dart';
import '../../domain/util.dart';
import '../writing/writing.dart';
import 'components/post_banner_widget.dart';
import 'components/post_board_widget.dart';
import 'components/post_head_text.dart';

class PostPage extends StatefulWidget {
  bool reload;

  PostPage({Key? key, required this.reload}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> with AutomaticKeepAliveClientMixin {
  final postApiRepo = PostApiRepository();
  final barWidget = BarWidget();
  final postApi = PostApi();
  final homeApiRepo = HomeApiRepository();

  final _valueList = ['최신 순', '거리 순'];
  var _selectedVaue = '최신 순';

  @override
  void initState() {
    super.initState();
    log("post init : $homeDataGet");
    if(homeDataGet == false) {
      postInit();
      homeDataGet = true;
    }
  }

  void postInit() async {
    print("post init 함수 실행");
    await homeApiRepo.getHomeRepo();
    setState(() {

    });
  }

  //새로고침 방지
  @override
  bool get wantKeepAlive => true;

  Future<void> refresh() async {

    posts = await postApi.getPost();

    //refresh 내용 State 반영
    setState(() {

    });
  }

  // Text('${snapshot.data?[index]['post_title']}');
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteTheme,
      appBar: barWidget.appBar(context),
      floatingActionButton: new Container(
        margin: EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new WritingPage()));
          },
          backgroundColor: Color(0xFF3F51B5),
          child: SvgPicture.asset(
            "assets/icon/bar_icons/plus_icon.svg",
            width: 18,
            height: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: homeDataGet
            ? RefreshIndicator(
          onRefresh: () => refresh(),
              child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    PostBannerWidget(
                      banner: banners,
                    ),
                    PostHeadTextWidget(),
                    PostBoardWidget(
                      posts: posts,
                    ),
                  ],
                ),
              ),
          ),
        ),
            )
            : ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    enabled: true,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          width: size.width - 20,
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PostHeadTextWidget(),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    enabled: true,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          width: size.width - 20,
                          height: 330,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    enabled: true,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          width: size.width - 20,
                          height: 330,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
