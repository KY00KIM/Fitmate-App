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

class FitnessCenterReviewPage extends StatefulWidget {
  String fitnessCenterId;
  int fitnessCenterRating;
  String fitnessCenterName;
  String fitnessCenterAddress;
  FitnessCenterReviewPage(
      {Key? key,
      required this.fitnessCenterId,
      required this.fitnessCenterRating,
      required this.fitnessCenterName,
      required this.fitnessCenterAddress})
      : super(key: key);

  @override
  State<FitnessCenterReviewPage> createState() =>
      _FitnessCenterReviewPageState();
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

class _FitnessCenterReviewPageState extends State<FitnessCenterReviewPage> {
  late List reviewData;
  String description = "";
  List<bool> checkBoxList = [false, false, false, false, false];
  List<String> checkBoxListId = [
    '6319e2c3821cfa1d84516cd9',
    '6319e2d4821cfa1d84516cdb',
    '6319e3db821cfa1d84516cdd',
    '6319e3fc821cfa1d84516cdf',
    '6319e6e529188e0099d9ec14',
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
  String ratingText = '그저 그랬어요';

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

  Future<void> PostFitnessReview() async {
    List choice = [];
    for (int i = 0; i < checkBoxList.length; i++) {
      if (checkBoxList[i] == true) choice.add(checkBoxListId[i]);
    }
    Map data = {
      "center_rating": _rating.toInt(),
      "center_review": "${description}",
      "center_review_by_select": choice
    };
    print(data);
    print(widget.fitnessCenterId);
    var body = json.encode(data);

    http.Response response = await http.post(
        Uri.parse(
            "${baseUrlV2}reviews/fitnesscenter/${widget.fitnessCenterId}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer $IdToken',
        }, // this header is essential to send json data
        body: body);
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    print(resBody);

    if (response.statusCode == 201) {
      Navigator.pop(context);  // 새로고침 여부
      FlutterToastBottom("리뷰를 작성해 주셔서 감사합니다");
    } else if (resBody['success'] == false &&
        resBody['message'] == "이미 해당 피트니스 센터 리뷰를 등록했습니다.") {
      print("else if");
      FlutterToastBottom("이미 해당 피트니스 센터 리뷰를 등록했습니다");
    } else {
      print("else");
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
          itemSize: 32.0,
          itemBuilder: (context, _) => Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
            child: SvgPicture.asset(
              "assets/icon/review_star_icon.svg",
              color: Color(0xFFF27F22),
            ),
          ),
          onRatingUpdate: (rating) {
            String text = '안좋았어요';
            if (rating > 4)
              text = "너무 좋았어요";
            else if (rating > 3)
              text = "좋았어요";
            else if (rating > 2)
              text = '그저 그랬어요';
            else if (rating > 1) text = '별로에요';
            setState(() {
              _rating = rating;
              ratingText = text;
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
                      icon: (checkBoxList[0] == true ||
                                  checkBoxList[1] == true ||
                                  checkBoxList[2] == true ||
                                  checkBoxList[3] == true ||
                                  checkBoxList[4] == true) &&
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
                                checkBoxList[4] == true) &&
                            description != '') {
                          PostFitnessReview();
                          //PostReview();
                        }
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
          body: SafeArea(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${widget.fitnessCenterName}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            '${widget.fitnessCenterAddress}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                widget.fitnessCenterRating >= 1
                                    ? "assets/icon/color_star_icon.svg"
                                    : "assets/icon/star_icon.svg",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              SvgPicture.asset(
                                widget.fitnessCenterRating >= 2
                                    ? "assets/icon/color_star_icon.svg"
                                    : "assets/icon/star_icon.svg",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              SvgPicture.asset(
                                widget.fitnessCenterRating >= 3
                                    ? "assets/icon/color_star_icon.svg"
                                    : "assets/icon/star_icon.svg",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              SvgPicture.asset(
                                widget.fitnessCenterRating >= 4
                                    ? "assets/icon/color_star_icon.svg"
                                    : "assets/icon/star_icon.svg",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              SvgPicture.asset(
                                widget.fitnessCenterRating >= 5
                                    ? "assets/icon/color_star_icon.svg"
                                    : "assets/icon/star_icon.svg",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                '${widget.fitnessCenterRating}.0',
                                style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      SizedBox(
                        height: 17.5,
                      ),
                      Container(
                        height: 1,
                        color: Color(0xFFD1D9E6),
                      ),
                      SizedBox(
                        height: 35.5,
                      ),
                      Text(
                        '피트니스 클럽을 평가해주세요.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      _ratingBar(_ratingBarMode),
                      SizedBox(height: 20.0),
                      Text(
                        '$_rating',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Color(0xFF6E7995)),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        '$ratingText',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        '피트니스 클럽을 이용하며 느낀점을\n모두 선택하세요.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF6E7995),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            LabeledCheckbox(
                              label: '시설이 깨끗해요.',
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              value: checkBoxList[0],
                              onChanged: (bool newValue) {
                                setState(() {
                                  checkBoxList[0] = newValue;
                                });
                              },
                            ),
                            LabeledCheckbox(
                              label: '기구가 다양해요',
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              value: checkBoxList[1],
                              onChanged: (bool newValue) {
                                setState(() {
                                  checkBoxList[1] = newValue;
                                });
                              },
                            ),
                            LabeledCheckbox(
                              label: '직원분들이 친절해요.',
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              value: checkBoxList[2],
                              onChanged: (bool newValue) {
                                setState(() {
                                  checkBoxList[2] = newValue;
                                });
                              },
                            ),
                            LabeledCheckbox(
                              label: '접근성이 좋아요.',
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              value: checkBoxList[3],
                              onChanged: (bool newValue) {
                                setState(() {
                                  checkBoxList[3] = newValue;
                                });
                              },
                            ),
                            LabeledCheckbox(
                              label: '가격이 저렴해요.',
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              value: checkBoxList[4],
                              onChanged: (bool newValue) {
                                setState(() {
                                  checkBoxList[4] = newValue;
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
                              color: const Color.fromRGBO(
                                  0, 0, 0, 0.16), // shadow color
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
                      SizedBox(
                        height: 28,
                      )
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
