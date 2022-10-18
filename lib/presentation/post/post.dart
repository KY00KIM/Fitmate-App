import 'dart:developer';

import 'package:fitmate/ui/bar_widget.dart';
import 'package:fitmate/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    log("post init");
    postInit();
  }

  void postInit() async {
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
        /*
        child: RefreshIndicator(
          //onRefresh: () => postApiRepo.getPostRepo(),
          onRefresh: () => refresh(),
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '게시판',
                          style: TextStyle(
                            color: Color(0xFF6E7995),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            icon: Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Transform.rotate(
                                angle: 90 * math.pi / 180,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF000000),
                                  size: 16,
                                ),
                              ),
                            ),
                            value: _selectedVaue,
                            items: _valueList.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedVaue = value.toString();
                              });
                            },
                            /*
                                  child: Row(
                                    children: [
                                      Text(
                                        '최신 순',
                                        style: TextStyle(
                                          color: Color(0xFF000000),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8,),
                                      Transform.rotate(
                                        angle: 90 * math.pi / 180,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Color(0xFF000000),
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),

                                   */
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        Post post = posts[index];
                        return PostWidget(posts: post);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

         */
    );
  }
}
