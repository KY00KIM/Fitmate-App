import 'dart:developer';

import 'package:fitmate/ui/bar_widget.dart';
import 'package:fitmate/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../data/post_api.dart';
import '../../domain/model/post.dart';
import '../../domain/repository/post_api_repository.dart';
import 'components/post_widget.dart';

class SomeonePostPage extends StatefulWidget {
  String userId;
  SomeonePostPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<SomeonePostPage> createState() => _SomeonePostPagePageState();
}

class _SomeonePostPagePageState extends State<SomeonePostPage> with AutomaticKeepAliveClientMixin {
  final postApiRepo = PostApiRepository();
  final barWidget = BarWidget();
  final postApi = PostApi();

  @override
  void initState() {
    super.initState();
    print("userId : ${widget.userId}");
  }

  //새로고침 방지
  @override
  bool get wantKeepAlive => true;

  Future<List> getSomePost() async {
    List _posts = await postApi.getSomePost(widget.userId);
    log("_posts : $_posts");
    return _posts;
  }

  // Text('${snapshot.data?[index]['post_title']}');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteTheme,
      appBar: barWidget.bulletinBoardAppBar(context),
      body: SafeArea(
        child: FutureBuilder<List>(
          future: getSomePost(),
          builder: (context, snapshot) {
            print("snapshot data : ${snapshot.data}");
            if (snapshot.hasData) {
              return ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '내 게시글',
                              style: TextStyle(
                                color: Color(0xFF6E7995),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
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
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            Post post = snapshot.data?[index];
                            return PostWidget(posts: post);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            // 기본적으로 로딩 Spinner를 보여줍니다.
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
