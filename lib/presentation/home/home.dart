import 'dart:convert';

import 'package:fitmate/ui/bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitmate/presentation/writing.dart';


import '../../data/post_api.dart';
import '../../domain/model/posts.dart';
import 'components/post_widget.dart';

class HomePage extends StatefulWidget {
  bool reload;
  HomePage({Key? key, required this.reload}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
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
      backgroundColor: Color(0xFF22232A),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF22232A),
        title: Padding(
          padding: EdgeInsets.only(left: 7.0),
          child: Image.asset(
            'assets/images/fitmate_logo.png',
            height: 20,
          ),
        ),
      ),
      bottomNavigationBar: barWidget.bottomNavigationBar(context, 1),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 40,
          ),
          backgroundColor: Color(0xFF303037),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WritingPage()));
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        //child: RefreshIndicator(
          //color: Color(0xFF22232A),
          //onRefresh: () => postApi.getPost(false),
          child: FutureBuilder<List>(
            future: postApi.getPost(true),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      Posts post = snapshot.data?[index];
                      return PostWidget(posts: post);
                    },
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
        //),
      ),
    );
  }
}
