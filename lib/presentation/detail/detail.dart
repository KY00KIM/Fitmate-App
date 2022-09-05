import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../domain/model/post.dart';
import '../../domain/util.dart';
import '../../ui/bar_widget.dart';
import '../../ui/colors.dart';
import '../../ui/show_toast.dart';
import 'components/detail_content_widget.dart';
import 'components/detail_image_widget.dart';
import 'components/detail_maker_widget.dart';
import 'components/detail_title_widget.dart';

class DetailMachingPage extends StatefulWidget {
  Post post;

  DetailMachingPage({Key? key, required this.post}) : super(key: key);

  @override
  State<DetailMachingPage> createState() => _DetailMachingPageState();
}

class _DetailMachingPageState extends State<DetailMachingPage> {
  String makerUserUid = '';

  final barWidget = BarWidget();

  Future getPostDetail() async {
    http.Response responseUser = await http.get(
        Uri.parse(
            "${baseUrlV1}users/${widget.post.userId.id.toString()}"),
        headers: {
          "Authorization": "bearer ${IdToken.toString()}",
          "Content-Type": "application/json; charset=UTF-8",
          "userId": "${widget.post.userId.id.toString()}"
        });
    var resBody = jsonDecode(utf8.decode(responseUser.bodyBytes));

    makerUserUid = resBody['data']['social']['user_id'];

    if (responseUser.statusCode == 200) {
      print("반환 갑니다잉");
      return true;
    } else {
      print("what the fuck");
      throw Exception('Failed to load post');
    }
  }

  void ReportPosets() async {
    http.Response response = await http.post(
      Uri.parse("${baseUrlV1}report/${widget.post.underId}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $IdToken',
        'postId': '${widget.post.underId}'
      },
    );
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    print(resBody);

    if (response.statusCode == 201) {
      log(IdToken);
      FlutterToastBottom("신고가 접수되었습니다");
    } else if (resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();
      FlutterToastBottom("오류가 발생했습니다. 한번 더 시도해 주세요");
    } else {
      FlutterToastBottom("오류가 발생하였습니다");
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Color(0xFF22232A),
          title: new Text(
            "사용자 신고",
            style: TextStyle(
              color: Color(0xFFffffff),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
              color: Color(0xFF15161B),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Color(0xFF878E97), //                   <--- border color
                width: 1.0,
              ),
            ),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 15,
              minLines: 1,
              style: TextStyle(color: Color(0xFF757575)),
              decoration: InputDecoration(
                fillColor: Color(0xFF15161B),
                border: InputBorder.none,
              ),
            ),
            padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
          ),
          actions: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 130,
                    child: ElevatedButton(
                      child: Text(
                        "신고 내용 보내기",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        ReportPosets();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPostDetail(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: barWidget.detailAppBar(context),
            backgroundColor: whiteTheme,
            body: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DetailTitleWidget(post: widget.post,),
                    DetailMakerWidget(post: widget.post),
                    DetailImageWidget(post: widget.post),
                    DetailContentWidget(post: widget.post, makerUserUid : makerUserUid),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          print("에러입니당");
          return Text("${snapshot.error}");
        }
        // 기본적으로 로딩 Spinner를 보여줍니다.
        return Center(child: CircularProgressIndicator());
      },
    );
  }

}
