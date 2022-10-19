import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
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
        Uri.parse("${baseUrlV1}users/${widget.post.userId.id.toString()}"),
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getPostDetail(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            //appBar: barWidget.detailAppBar(context),
            appBar: AppBar(
              centerTitle: false,
              backgroundColor: whiteTheme,
              toolbarHeight: 60,
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: whiteTheme,
              ),
              automaticallyImplyLeading: false,
              title: Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Container(
                  width: 44,
                  height: 44,
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
                        "assets/icon/bar_icons/back_icon.svg",
                        width: 16,
                        height: 16,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 20, 8),
                  child: Container(
                    width: 44,
                    height: 44,
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
                          "assets/icon/bar_icons/burger_icon.svg",
                          width: 16,
                          height: 16,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              shape: const RoundedRectangleBorder(
                                // <-- SEE HERE
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(40.0),
                                ),
                              ),
                              backgroundColor: Color(0xFFF2F3F7),
                              builder: (BuildContext context) {
                                return Wrap(
                                  children: [
                                    Container(
                                      height: 124,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: 40,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2.0),
                                              color: Color(0xFFD1D9E6),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 36,
                                          ),
                                          widget.post.userId.underId == UserData['_id']
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    print("클릭");
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.fromLTRB(
                                                        20, 22, 20, 20),
                                                    height: 64,
                                                    width: size.width,
                                                    color: whiteTheme,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '게시글 삭제',
                                                          style: TextStyle(
                                                            color:
                                                                Color(0xFFCF2933),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () async {
                                                    http.Response response =
                                                        await http.post(
                                                            Uri.parse(
                                                                "https://fitmate.co.kr/v2/report/${widget.post.underId}"),
                                                            headers: {
                                                          "Authorization":
                                                              "bearer $IdToken",
                                                        },
                                                            body: {});
                                                    var resBody = jsonDecode(
                                                        utf8.decode(
                                                            response.bodyBytes));
                                                    if (response.statusCode !=
                                                            201 &&
                                                        resBody["error"]
                                                                ["code"] ==
                                                            "auth/id-token-expired") {
                                                      IdToken = (await FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              ?.getIdTokenResult(
                                                                  true))!
                                                          .token
                                                          .toString();

                                                      response = await http.post(
                                                          Uri.parse(
                                                              "https://fitmate.co.kr/v2/report/${widget.post.underId}"),
                                                          headers: {
                                                            "Authorization":
                                                                "bearer $IdToken",
                                                          },
                                                          body: {});
                                                      resBody = jsonDecode(
                                                          utf8.decode(response
                                                              .bodyBytes));
                                                    }
                                                    if (resBody['success'] ==
                                                        true)
                                                      FlutterToastBottom(
                                                          '신고가 접수되었습니다.');
                                                    else
                                                      FlutterToastBottom(
                                                          '에러가 발생하였습니다.');
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.fromLTRB(
                                                        20, 22, 20, 20),
                                                    height: 64,
                                                    width: size.width,
                                                    color: whiteTheme,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '게시글 신고',
                                                          style: TextStyle(
                                                            color:
                                                                Color(0xFFCF2933),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              });
                          /*
              actions: [
                PopupMenuButton(
                  iconSize: 30,
                  color: Color(0xFF22232A),
                  shape: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF757575),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  elevation: 40,
                  onSelected: (value) async {
                    if (value == '/report') {
                      _showDialog();
                    }
                  },
                  itemBuilder: (BuildContext bc) {
                    return [
                      PopupMenuItem(
                        child: Text(
                          '게시글 신고',
                          style: TextStyle(
                            color: Color(0xFFffffff),
                          ),
                        ),
                        value: '/report',
                      ),
                    ];
                  },
                ),
              ],
              elevation: 0.0,
              backgroundColor: Colors.transparent, // <-- this
              //shadowColor: Colors.transparent,
            ),
             */
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
            backgroundColor: whiteTheme,
            body: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DetailTitleWidget(
                      post: widget.post,
                    ),
                    DetailMakerWidget(post: widget.post),
                    DetailImageWidget(post: widget.post),
                    DetailContentWidget(
                        post: widget.post, makerUserUid: makerUserUid),
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
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: whiteTheme,
          child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
