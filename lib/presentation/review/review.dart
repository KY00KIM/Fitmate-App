import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import '../../domain/util.dart';
import '../../ui/colors.dart';
import '../../ui/show_toast.dart';
import '../calender/calender.dart';

class IconAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Select Icon',
        style: TextStyle(
          fontWeight: FontWeight.w300,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      titlePadding: EdgeInsets.all(12.0),
      contentPadding: EdgeInsets.all(0),
      content: Wrap(
        children: [
          _iconButton(context, Icons.home),
          _iconButton(context, Icons.airplanemode_active),
          _iconButton(context, Icons.euro_symbol),
          _iconButton(context, Icons.beach_access),
          _iconButton(context, Icons.attach_money),
          _iconButton(context, Icons.music_note),
          _iconButton(context, Icons.android),
          _iconButton(context, Icons.toys),
          _iconButton(context, Icons.language),
          _iconButton(context, Icons.landscape),
          _iconButton(context, Icons.ac_unit),
          _iconButton(context, Icons.star),
        ],
      ),
    );
  }

  Widget _iconButton(BuildContext context, IconData icon) => IconButton(
    icon: Icon(icon),
    onPressed: () => Navigator.pop(context, icon),
    splashColor: Colors.amberAccent,
    color: Colors.amber,
  );
}


class ReviewPage extends StatefulWidget {
  String appointmentId;
  String recv_id;
  String nickName;
  String userImg;
  ReviewPage({Key? key, required this.appointmentId, required this.recv_id, required this.nickName, required this.userImg})
      : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    Key? key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 30,
              height: 40,
              child: Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Color(0xff878E97),
                ),
                child: Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  value: value,
                  onChanged: (bool? newValue) {
                    onChanged(newValue);
                  },
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Text(
              label,
              style: TextStyle(
                color: Color(0xFF000000),
                //fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ReviewPageState extends State<ReviewPage> {
  late List reviewData;
  String description = "";
  List<bool> checkBoxList = [false, false, false, false, false, false, false];
  List<String> checkBoxListId = [
    '62c66ef64b8212e4674dbe20',
    '62c66f0b4b8212e4674dbe21',
    '62c66ead4b8212e4674dbe1f',
    '62c66f224b8212e4674dbe22',
    '62dbb2e126e97374cf97aec7',
    '62dbb2fb26e97374cf97aec8',
    '62dbb30f26e97374cf97aec9'
  ];

  Future<String> getData() async {
    http.Response response =
        await http.get(Uri.parse('${baseUrlV1}reviews/candidates'), headers: {
      'Authorization': 'bearer $IdToken',
      'Content-Type': 'application/json; charset=UTF-8'
    });
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode != 200 &&
        resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();

      response = await http.get(
        Uri.parse("${baseUrlV1}reviews/candidates"),
        headers: {
          'Authorization': 'bearer $IdToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    if (response.statusCode != 200) {
      FlutterToastTop("알수 없는 에러가 발생하였습니다");
    } else {
      this.setState(() {
        reviewData = resBody["data"];
      });
    }
    return "success";
  }

  late final _ratingController;
  late double _rating;

  double _userRating = 3.0;
  int _ratingBarMode = 1;
  double _initialRating = 2.0;
  bool _isRTLMode = false;
  bool _isVertical = false;

  IconData? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _ratingController = TextEditingController(text: '3.0');
    _rating = _initialRating;
  }

  Future<void> PostReview() async {
    List choice = [];
    for (int i = 0; i < checkBoxList.length; i++) {
      if (checkBoxList[i] == true) choice.add(checkBoxListId[i]);
    }
    Map data = {
      "review_recv_id": "${widget.recv_id}",
      "review_body": "${description}",
      "user_rating": _rating.toInt(),
      "review_candidates": choice,
      "appointmentId": "${widget.appointmentId}"
    };
    print(data);
    var body = json.encode(data);

    http.Response response = await http.post(Uri.parse("${baseUrlV1}reviews/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer $IdToken',
        }, // this header is essential to send json data
        body: body);
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    print(resBody);

    if (response.statusCode == 201) {
      Navigator.pop(context);
      FlutterToastBottom("리뷰를 작성해 주셔서 감사합니다");
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

  Widget _ratingBar(int mode) {
    switch (mode) {
      case 1:
        return RatingBar.builder(
          initialRating: _initialRating,
          minRating: 0,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          allowHalfRating: true,
          unratedColor: Color(0xFFCED3EA),
          itemCount: 5,
          itemSize: 44.0,
          itemBuilder: (context, _) => Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
            child: SvgPicture.asset(
              "assets/icon/review_star_icon.svg",
              color: Color(0xFFF27F22),
            ),
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
          updateOnDrag: true,
        );
      case 2:
        return RatingBar(
          initialRating: _initialRating,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          ratingWidget: RatingWidget(
            full: _image('assets/heart.png'),
            half: _image('assets/heart_half.png'),
            empty: _image('assets/heart_border.png'),
          ),
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
          updateOnDrag: true,
        );
      case 3:
        return RatingBar.builder(
          initialRating: _initialRating,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                );
              case 1:
                return Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.redAccent,
                );
              case 2:
                return Icon(
                  Icons.sentiment_neutral,
                  color: Colors.amber,
                );
              case 3:
                return Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                );
              case 4:
                return Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green,
                );
              default:
                return Container();
            }
          },
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
          updateOnDrag: true,
        );
      default:
        return Container();
    }
  }

  Widget _image(String asset) {
    return Image.asset(
      asset,
      height: 30.0,
      width: 30.0,
      color: Colors.amber,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () {
          //FocusManager.instance.primaryFocus?.unfocus();
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: whiteTheme,
          appBar: AppBar(
            toolbarHeight: 60,
            backgroundColor: whiteTheme,
            elevation: 0,
            automaticallyImplyLeading: false,
            leadingWidth: 64,
            leading: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 0, 8),
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
                      "assets/icon/bar_icons/x_icon.svg",
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
                      /*
                      icon:_selectedTime == '시간 선택' || _selectedDate == '날짜 선택' || centerName == '피트니스 클럽 검색' ?  SvgPicture.asset(
                        "assets/icon/bar_icons/non_color_check_icon.svg",
                        width: 16,
                        height: 16,
                      ) : SvgPicture.asset(
                        "assets/icon/bar_icons/color_check_icon.svg",
                        width: 16,
                        height: 16,
                      ),

                       */
                      icon : (checkBoxList[0] == true ||
                          checkBoxList[1] == true ||
                          checkBoxList[2] == true ||
                          checkBoxList[3] == true ||
                          checkBoxList[4] == true ||
                          checkBoxList[5] == true ||
                          checkBoxList[6] == true) &&
                          description != ''
                          ? SvgPicture.asset(
                        "assets/icon/bar_icons/color_check_icon.svg",
                        width: 16,
                        height: 16,
                      )
                          : SvgPicture.asset(
                        "assets/icon/bar_icons/non_color_check_icon.svg",
                        width: 16,
                        height: 16,
                      ),
                      onPressed: () async {
                        if ((checkBoxList[0] == true ||
                            checkBoxList[1] == true ||
                            checkBoxList[2] == true ||
                            checkBoxList[3] == true ||
                            checkBoxList[4] == true ||
                            checkBoxList[5] == true ||
                            checkBoxList[6] == true) &&
                            description != '') {
                          PostReview();
                        }
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
          /*
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
              ),
            ),
            elevation: 0.0,
            shape: Border(
              bottom: BorderSide(
                color: Color(0xFF3D3D3D),
                width: 1,
              ),
            ),
            backgroundColor: Color(0xFF22232A),
            title: Transform(
              transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
              child: Text(
                "리뷰 작성",
                style: TextStyle(
                  color: Color(0xFFffffff),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  (checkBoxList[0] == true ||
                              checkBoxList[1] == true ||
                              checkBoxList[2] == true ||
                              checkBoxList[3] == true ||
                              checkBoxList[4] == true ||
                              checkBoxList[5] == true ||
                              checkBoxList[6] == true) &&
                          description != ''
                      ? PostReview()
                      : FlutterToastBottom("매칭 리뷰 선택 및 후기 작성을 해주세요!");
                },
                child: Text(
                  '완료',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: (checkBoxList[0] == true ||
                                checkBoxList[1] == true ||
                                checkBoxList[2] == true ||
                                checkBoxList[3] == true ||
                                checkBoxList[4] == true ||
                                checkBoxList[5] == true ||
                                checkBoxList[6] == true) &&
                            description != ''
                        ? Color(0xFF2975CF)
                        : Color(0xFF878E97),
                  ),
                ),
              ),
            ],
          ),

           */
          body: SafeArea(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(
                            100.0),
                        child: Image.network(
                          '${widget.userImg}',
                          width: 52.0,
                          height: 52.0,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (BuildContext context,
                              Object exception,
                              StackTrace?
                              stackTrace) {
                            return Image.asset(
                              'assets/images/profile_null_image.png',
                              width: 20.0,
                              height: 20.0,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        '${widget.nickName}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 26,
                      ),
                      Text(
                        '회원을 평가해주세요.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 26,
                      ),
                      Text(
                        '총 평을 해주세요.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6E7995),
                            fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      _ratingBar(_ratingBarMode),
                      SizedBox(height: 20.0),
                      Text(
                        '$_rating',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28, color: Color(0xFF6E7995)),
                      ),
                      SizedBox(height: 12,),
                      Text(
                        '별로에요',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(height: 36,),
                      Text(
                        '함께 운동하며 느낀점을 모두 선택하세요.',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color: Color(0xFF6E7995)),
                      ),
                      SizedBox(height: 24,),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            LabeledCheckbox(
                              label: '매너가 좋아요.',
                              padding: const EdgeInsets.symmetric(horizontal: 0.0),
                              value: checkBoxList[0],
                              onChanged: (bool newValue) {
                                setState(() {
                                  checkBoxList[0] = newValue;
                                });
                              },
                            ),
                            LabeledCheckbox(
                              label: '시간 약속을 잘 지켜요',
                              padding: const EdgeInsets.symmetric(horizontal: 0.0),
                              value: checkBoxList[1],
                              onChanged: (bool newValue) {
                                setState(() {
                                  checkBoxList[1] = newValue;
                                });
                              },
                            ),
                            LabeledCheckbox(
                              label: '친절하고 매너가 좋아요.',
                              padding: const EdgeInsets.symmetric(horizontal: 0.0),
                              value: checkBoxList[2],
                              onChanged: (bool newValue) {
                                setState(() {
                                  checkBoxList[2] = newValue;
                                });
                              },
                            ),
                            LabeledCheckbox(
                              label: '열정적이에요.',
                              padding: const EdgeInsets.symmetric(horizontal: 0.0),
                              value: checkBoxList[3],
                              onChanged: (bool newValue) {
                                setState(() {
                                  checkBoxList[3] = newValue;
                                });
                              },
                            ),
                            LabeledCheckbox(
                              label: '채팅 응답이 빨라요.',
                              padding: const EdgeInsets.symmetric(horizontal: 0.0),
                              value: checkBoxList[4],
                              onChanged: (bool newValue) {
                                setState(() {
                                  checkBoxList[4] = newValue;
                                });
                              },
                            ),
                            LabeledCheckbox(
                              label: '자세를 잘 봐줘요.',
                              padding: const EdgeInsets.symmetric(horizontal: 0.0),
                              value: checkBoxList[5],
                              onChanged: (bool newValue) {
                                setState(() {
                                  checkBoxList[5] = newValue;
                                });
                              },
                            ),
                            LabeledCheckbox(
                              label: '모르는 운동법을 잘 알려줘요.',
                              padding: const EdgeInsets.symmetric(horizontal: 0.0),
                              value: checkBoxList[6],
                              onChanged: (bool newValue) {
                                setState(() {
                                  checkBoxList[6] = newValue;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        '평가글을 남겨주세요.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6E7995),
                            fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(0, 0, 0, 0.16), // shadow color
                            ),
                            const BoxShadow(
                              offset: Offset(2, 2),
                              blurRadius: 6,
                              color: Color(0xFFEFEFEF),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 10, 4),
                          child: TextField(
                            minLines: 1,
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: "평가 입력",
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFD1D9E6),
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (text) {
                              setState(() {
                                description = text;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 28,)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}