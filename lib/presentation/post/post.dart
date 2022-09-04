import 'package:fitmate/ui/bar_widget.dart';
import 'package:fitmate/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/post_api.dart';
import '../../domain/model/posts.dart';
import 'components/post_widget.dart';

class PostPage extends StatefulWidget {
  bool reload;

  PostPage({Key? key, required this.reload}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage>
    with AutomaticKeepAliveClientMixin {
  bool refresh = false;
  int count = 0;
  final postApi = PostApi();
  final barWidget = BarWidget();

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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteTheme,
      appBar: barWidget.bulletinBoard(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => postApi.getPost(false),
          child: FutureBuilder<List>(
            future: postApi.getPost(true),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
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
                            Text(
                              '최신 순',
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 14,
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
                            Posts post = snapshot.data?[index];
                            return PostWidget(posts: post);
                          },
                        ),
                      ],
                    ),
                  ),
                );
                /*
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        Posts post = snapshot.data?[index];
                        return PostWidget(posts: post);
                      },
                    ),
                  ),
                );

                 */
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
