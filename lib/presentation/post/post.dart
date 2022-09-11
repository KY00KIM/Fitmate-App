import 'package:fitmate/ui/bar_widget.dart';
import 'package:fitmate/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../domain/model/post.dart';
import '../../domain/repository/post_api_repository.dart';
import 'components/post_widget.dart';

class PostPage extends StatefulWidget {
  bool reload;

  PostPage({Key? key, required this.reload}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> with AutomaticKeepAliveClientMixin {
  final postApiRepo = PostApiRepository();
  final barWidget = BarWidget();

  final _valueList = ['최신 순', '거리 순'];
  var _selectedVaue = '최신 순';

  @override
  void initState() {
    super.initState();
  }

  //새로고침 방지
  @override
  bool get wantKeepAlive => true;

  // Text('${snapshot.data?[index]['post_title']}');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteTheme,
      appBar: barWidget.bulletinBoardAppBar(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => postApiRepo.getPostRepo(),
          child: FutureBuilder<List>(
            future: postApiRepo.getPostRepo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: SingleChildScrollView(
                    child: Padding(
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
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // 기본적으로 로딩 Spinner를 보여줍니다.
              return Center(child: CircularProgressIndicator());
              //return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
