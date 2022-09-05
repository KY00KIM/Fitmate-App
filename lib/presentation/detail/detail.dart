import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import '../../domain/model/posts.dart';
import '../../domain/util.dart';
import '../../ui/bar_widget.dart';
import '../../ui/colors.dart';
import '../../ui/show_toast.dart';
import '../chat.dart';
import '../other_profile.dart';

class DetailMachingPage extends StatefulWidget {
  Posts post;

  DetailMachingPage({Key? key, required this.post}) : super(key: key);

  @override
  State<DetailMachingPage> createState() => _DetailMachingPageState();
}

class _DetailMachingPageState extends State<DetailMachingPage> {
  String makerUserUid = '';
  String chatId = '';
  String fitnessPartContent = '';

  final barWidget = BarWidget();

  Future<bool> addChat() async {
    //기존 채팅방이 있는지 확인
    http.Response response = await http.get(
      Uri.parse("${baseUrlV1}chats/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $IdToken',
      },
    );
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode != 200 &&
        resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();

      response = await http.get(
        Uri.parse("${baseUrlV1}chats/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer $IdToken',
        },
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    for (int i = 0; i < resBody['data'].length; i++) {
      if ((resBody['data'][i]['chat_start_id'] == UserData['_id'] &&
              resBody['data'][i]['chat_join_id'] == widget.post.userId.id) ||
          (resBody['data'][i]['chat_join_id'] == UserData['_id'] &&
              resBody['data'][i]['chat_start_id'] == widget.post.userId.id)) {
        //이미 채팅방이 있을 때
        chatId = resBody['data'][i]['_id'];
        return true;
      }
    }

    Map data = {"chat_join_id": "${widget.post.userId.id}"};
    print(data);
    var body = json.encode(data);
    log(IdToken);
    http.Response response2 = await http.post(Uri.parse("${baseUrlV1}chats/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer $IdToken',
        }, // this header is essential to send json data
        body: body);
    var resBody2 = jsonDecode(utf8.decode(response2.bodyBytes));
    print('오우 : ${response.body}');
    if (response.statusCode != 200 &&
        resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();

      response2 = await http.post(Uri.parse("${baseUrlV1}chats/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'bearer $IdToken',
          }, // this header is essential to send json data
          body: body);
      resBody2 = jsonDecode(utf8.decode(response2.bodyBytes));
    }

    if (response2.statusCode == 201) {
      chatId = resBody2['data']['_id'];
      return true;
    } else
      return false;
  }

  Future<List> getPostDetail() async {
    http.Response response = await http.get(
      Uri.parse("${baseUrlV1}posts/${widget.post.underId}"),
      headers: {
        "Authorization": "bearer $IdToken",
        "Content-Type": "application/json; charset=UTF-8",
        "postId": "${widget.post.underId}"
      },
    );
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200 &&
        resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();

      http.Response response = await http.get(
        Uri.parse("${baseUrlV1}posts/${widget.post.underId}"),
        headers: {
          "Authorization": "bearer $IdToken",
          "Content-Type": "application/json; charset=UTF-8",
          "postId": "${widget.post.underId}"
        },
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    http.Response responseUser = await http.get(
        Uri.parse(
            "${baseUrlV1}users/${resBody['data'][0]['user_id'].toString()}"),
        headers: {
          // ignore: unnecessary_string_interpolations
          "Authorization": "bearer ${IdToken.toString()}",
          "Content-Type": "application/json; charset=UTF-8",
          "userId": "${resBody['data'][0]['user_id'].toString()}"
        });
    var resBody3 = jsonDecode(utf8.decode(responseUser.bodyBytes));

    makerUserUid = resBody3['data']['social']['user_id'];

    for(int i = 0; i < widget.post.postFitnessPart.length; i++) {
      fitnessPartContent = fitnessPartContent + "#${fitnessPart[widget.post.postFitnessPart[i]]} ";
    }

    if (response.statusCode == 200) {
      print("반환 갑니다잉");
      return resBody["data"];
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
    final Size size = MediaQuery.of(context).size;
    return FutureBuilder<List>(
      future: getPostDetail(),
      builder: (context, snapshot) {
        print("여기까지");
        if (snapshot.hasData) {
          print("머냐 이거");
          String? time = widget.post.promiseDate.toString().substring(11, 13);
          String slot = int.parse(time) > 12 ? '오후' : '오전';
          return Scaffold(
            /*
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                ),
              ),
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
            appBar: barWidget.detailAppBar(context),
            backgroundColor: whiteTheme,
            body: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
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
                      width: size.width,
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 50,
                                  text: TextSpan(
                                    text:
                                    '${snapshot.data?[0]['post_title']}',
                                    style: TextStyle(
                                      color: Color(0xFF6E7995),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '작성일 : ${widget.post.createdAt.toString().substring(0, 4)}년 ${widget.post.createdAt.toString().substring(5, 7)}월 ${widget.post.createdAt.toString().substring(8, 10)}일',
                                style: TextStyle(
                                  color: Color(0xFF6E7995),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => OtherProfilePage(
                                profileId: widget.post.userId.underId,
                                profileName: '${widget.post.userId.userNickname}',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
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
                        width: size.width,
                        height: 64,
                        padding: EdgeInsets.fromLTRB(19.5, 16.5, 20.5, 15.5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(100.0),
                                  child: Image.network(
                                    '${widget.post.userId.userProfileImg}',
                                    width: 32.0,
                                    height: 32.0,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Image.asset(
                                        'assets/images/profile_null_image.png',
                                        width: 32.0,
                                        height: 32.0,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width : 16,
                                ),
                                Text(
                                  '${widget.post.userId.userNickname}',
                                  style: TextStyle(
                                    color: Color(0xff000000),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
                                    width: 16,
                                    height: 16,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => OtherProfilePage(
                                          profileId: widget.post.userId.underId,
                                          profileName: '${widget.post.userId.userNickname}',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
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
                      width: size.width,
                      padding: EdgeInsets.fromLTRB(20, 20.5, 20, 32),
                      child: Column(
                        children: [
                          Image.network(
                            '${widget.post.postImg}',
                            fit: BoxFit.fitWidth,
                            errorBuilder: (BuildContext context, Object exception,
                                StackTrace? stackTrace) {
                              return Image.asset(
                                'assets/images/dummy.jpg',
                                fit: BoxFit.fitWidth,
                              );
                            },
                          ),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              Flexible(
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 50,
                                  text: TextSpan(
                                    text: '${widget.post.postMainText}',
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
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
                      width: size.width,
                      padding: EdgeInsets.fromLTRB(20, 32, 20, 32),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: SvgPicture.asset(
                                      "assets/icon/fitness_icon.svg",
                                      width: 18,
                                      height: 18,
                                    ),
                                    margin: EdgeInsets.only(top : 3),
                                  ),
                                  SizedBox(
                                    width : 18,
                                  ),
                                  Container(
                                    width: size.width - 108,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '피트니스 클럽',
                                          style: TextStyle(
                                            color: Color(0xFF6E7995),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 14,),
                                        Text(
                                          '${widget.post.promiseLocation.centerName}',
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 12,),
                                        Text(
                                          '${widget.post.promiseLocation.centerAddress}',
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
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
                                      width: 16,
                                      height: 16,
                                    ),
                                    onPressed: () {
                                      print("피트니스장 클릭");
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: SvgPicture.asset(
                                  "assets/icon/calender_icon.svg",
                                  width: 18,
                                  height: 18,
                                ),
                                margin: EdgeInsets.only(top : 3),
                              ),
                              SizedBox(
                                width : 18,
                              ),
                              Container(
                                width: size.width - 108,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '매칭',
                                      style: TextStyle(
                                        color: Color(0xFF6E7995),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 14,),
                                    Text(
                                      '${widget.post.promiseDate.toString().substring(0, 4)}년 ${widget.post.promiseDate.toString().substring(5, 7)}월 ${widget.post.promiseDate.toString().substring(8, 10)}일  ${slot} ${int.parse(time) > 12 ? '${int.parse(time) - 12}' : '${int.parse(time)}'}시 ${widget.post.promiseDate.toString().substring(14, 16)}분',
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: SvgPicture.asset(
                                  "assets/icon/Indicators_icon.svg",
                                  width: 18,
                                  height: 18,
                                ),
                                margin: EdgeInsets.only(top : 3),
                              ),
                              SizedBox(
                                width : 18,
                              ),
                              Container(
                                width: size.width - 108,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '운동부위',
                                      style: TextStyle(
                                        color: Color(0xFF6E7995),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(height: 14,),
                                    Text(
                                      '$fitnessPartContent',
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(size.width, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 0,
                              primary: Color(0xFF3F51B5),
                            ),
                            onPressed: () async {
                              if (widget.post.userId.id != UserData['_id']) {
                                bool addChatAnswer = await addChat();
                                if (addChatAnswer == true) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                            name: widget.post.userId.userNickname,
                                            imageUrl: widget.post.userId.userProfileImg,
                                            uid: makerUserUid,
                                            userId: widget.post.userId.id,
                                            chatId: chatId,
                                          )));
                                }
                              }
                            },
                            child: Text(
                              '1:1 채팅',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
