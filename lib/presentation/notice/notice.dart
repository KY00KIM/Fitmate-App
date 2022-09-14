import 'dart:convert';

import 'package:fitmate/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../domain/util.dart';
import '../../ui/bar_widget.dart';
import 'components/notice_widget.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  final barWidget = BarWidget();

  Future getPostDetail() async {
    http.Response responseUser = await http.get(
        Uri.parse(
            "https://fitmate.co.kr/v2/push"),
        headers: {
          "Authorization": "bearer ${IdToken.toString()}",
          "Content-Type": "application/json; charset=UTF-8",
        });
    var resBody = jsonDecode(utf8.decode(responseUser.bodyBytes));


    if (responseUser.statusCode == 200) {
      print("반환 갑니다잉");
      return true;
    } else {
      print("what the fuck");
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getPostDetail(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: barWidget.noticeAppBar(context),
            backgroundColor: whiteTheme,
            body: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          print("에러입니당");
          return SizedBox();
        }
        // 기본적으로 로딩 Spinner를 보여줍니다.
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
