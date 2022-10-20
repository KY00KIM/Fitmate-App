import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import '../../domain/util.dart';
import '../../ui/colors.dart';
import '../fitness_map/fitness_map.dart';
import '../review/fitness_center_review.dart';
import '../review/review_list.dart';
import '../search_center/search_center.dart';

class FitnessCenterPage extends StatefulWidget {
  String fitnessId;

  FitnessCenterPage({Key? key, required this.fitnessId}) : super(key: key);

  @override
  State<FitnessCenterPage> createState() => _FitnessCenterPageState();
}

class _FitnessCenterPageState extends State<FitnessCenterPage> {
  var centerData;
  List reviews = [];
  int point = 0;
  Map reviewPoint = {
    "6319e2c3821cfa1d84516cd9" : 0,
    "6319e2d4821cfa1d84516cdb" : 0,
    "6319e3db821cfa1d84516cdd" : 0,
    "6319e3fc821cfa1d84516cdf" : 0,
    "6319e6e529188e0099d9ec14" : 0,
  };
  int reviewTotal = 0;

  @override
  void initState() {
    super.initState();
  }

  Future getFitnessCenter() async {
    point = 0;
    http.Response responseFitness = await http.get(
        Uri.parse(
            "https://fitmate.co.kr/v2/fitnesscenters/${widget.fitnessId}"),
        headers: {
          "Authorization": "bearer ${IdToken.toString()}",
          "Content-Type": "application/json; charset=UTF-8",
        });
    var resBody = jsonDecode(utf8.decode(responseFitness.bodyBytes));

    print(resBody['data']);

    centerData = resBody['data'];

    http.Response responseReview = await http.get(
        Uri.parse(
            "https://fitmate.co.kr/v2/reviews/fitnesscenter/${widget.fitnessId}"),
        headers: {
          "Authorization": "bearer ${IdToken.toString()}",
          "Content-Type": "application/json; charset=UTF-8",
        });
    var resBody2 = jsonDecode(utf8.decode(responseReview.bodyBytes));

    reviews = resBody2['data'];

    if(reviews.length != 0) {
      for(int i = 0; i< reviews.length; i++) {
        point += reviews[i]['center_rating'] as int;

        for(int j = 0; j< reviews[i]['center_review_by_select'].length; j++) {
          reviewTotal += 1;
          reviewPoint[reviews[i]['center_review_by_select'][j]] += 1;
        }
      }
      point = point ~/ reviews.length;
    }

    if (responseFitness.statusCode == 200) {
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
      future: getFitnessCenter(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
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
            ),
            body: Container(
              padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
              child:Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child:Column(
                          children: [
                            Text(
                              '${centerData['center_name']}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12,),
                            Text(
                              '${centerData['center_address']}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 13,),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  point >= 1 ? "assets/icon/color_star_icon.svg" : "assets/icon/star_icon.svg",
                                  width: 16,
                                  height: 16,
                                ),
                                SizedBox(width: 4,),
                                SvgPicture.asset(
                                  point >= 2 ? "assets/icon/color_star_icon.svg" : "assets/icon/star_icon.svg",
                                  width: 16,
                                  height: 16,
                                ),
                                SizedBox(width: 4,),
                                SvgPicture.asset(
                                  point >= 3 ? "assets/icon/color_star_icon.svg" : "assets/icon/star_icon.svg",
                                  width: 16,
                                  height: 16,
                                ),
                                SizedBox(width: 4,),
                                SvgPicture.asset(
                                  point >= 4 ? "assets/icon/color_star_icon.svg" : "assets/icon/star_icon.svg",
                                  width: 16,
                                  height: 16,
                                ),
                                SizedBox(width: 4,),
                                SvgPicture.asset(
                                  point >= 5 ? "assets/icon/color_star_icon.svg" : "assets/icon/star_icon.svg",
                                  width: 16,
                                  height: 16,
                                ),
                                SizedBox(width: 8,),
                                Text(
                                  '${point}.0',
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
                              "assets/icon/map_icon.svg",
                              width: 16,
                              height: 16,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FitnessMapPage(x: centerData['fitness_latitude'], y: centerData['fitness_longitude'], fitnessAddress: '${centerData['center_address']}', fitnessName: '${centerData['center_name']}',)),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 17.5,),
                  Container(
                    height: 1,
                    color: Color(0xFFD1D9E6),
                  ),
                  SizedBox(height: 21.5,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(size.width, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 0,
                      primary: Color(0xFF3F51B5),
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FitnessCenterReviewPage(fitnessCenterName: '${centerData['center_name']}', fitnessCenterRating: point, fitnessCenterAddress: '${centerData['center_address']}', fitnessCenterId: '${widget.fitnessId}',)),
                      );
                    },
                    child: Text(
                      '피트니스 클럽 평가',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 28,),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icon/people_icon.svg",
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 12,),
                      Text(
                        '피트니스 클럽 리뷰',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
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
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => ReviewListPage(reviewData: reviews, title: '피트니스 클럽', nickName: [], profileImg: [],),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28,),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 24, 20, 20),
                      width: double.infinity,
                      //height: 280,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "총 평점",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Color(0xff6E7995),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  "(리뷰 ${reviews.length})",
                                  style: TextStyle(
                                      color: Color(0xff6E7995),
                                      fontSize: 16),
                                ),
                                Spacer(),
                                Text(
                                  "${point}.0",
                                  style: TextStyle(
                                      color: Color(0xffF27F22),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                )
                              ]),
                          SizedBox(
                            height: 21,
                          ),
                          Container(
                            width: size.width-80,
                            child: Row(
                              children: [
                                Stack(children: [
                                  Container(
                                    height: 8,
                                    width: 120,
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
                                    ),
                                  ),
                                  Container(
                                    width: reviewTotal == 0 ? 0 : (120 / reviewTotal) * reviewPoint['6319e2c3821cfa1d84516cd9'],
                                    height: 8,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xFF00C6FB),
                                            Color(0xFF005BEA)
                                          ]),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ]),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "${reviewPoint['6319e2c3821cfa1d84516cd9'].toString()}",
                                  style: TextStyle(
                                    color: Color(0xff6E7995),
                                    fontSize: 14,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "시설이 깨끗해요",
                                  style: TextStyle(
                                      color: Color(0xff6E7995),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 21,
                          ),
                          Row(
                            children: [
                              Stack(children: [
                                Container(
                                  height: 8,
                                  width: 120,
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
                                  ),
                                ),
                                Container(
                                  width: reviewTotal == 0 ? 0 : (120 / reviewTotal) * reviewPoint['6319e2d4821cfa1d84516cdb'],
                                  height: 8,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFF00C6FB),
                                          Color(0xFF005BEA)
                                        ]),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ]),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "${reviewPoint['6319e2d4821cfa1d84516cdb'].toString()}",
                                style: TextStyle(
                                  color: Color(0xff6E7995),
                                  fontSize: 14,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "기구가 다양해요",
                                style: TextStyle(
                                    color: Color(0xff6E7995),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 21,
                          ),
                          Row(
                            children: [
                              Stack(children: [
                                Container(
                                  height: 8,
                                  width: 120,
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
                                  ),
                                ),
                                Container(
                                  width: reviewTotal == 0 ? 0 : (120 / reviewTotal) * reviewPoint['6319e3db821cfa1d84516cdd'],
                                  height: 8,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFF00C6FB),
                                          Color(0xFF005BEA)
                                        ]),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ]),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "${reviewPoint['6319e3db821cfa1d84516cdd'].toString()}",
                                style: TextStyle(
                                  color: Color(0xff6E7995),
                                  fontSize: 14,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "직원분들이 친절해요",
                                style: TextStyle(
                                    color: Color(0xff6E7995),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 21,
                          ),
                          Row(
                            children: [
                              Stack(children: [
                                Container(
                                  height: 8,
                                  width: 120,
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
                                  ),
                                ),
                                Container(
                                  width: reviewTotal == 0 ? 0 : (120 / reviewTotal) * reviewPoint['6319e3fc821cfa1d84516cdf'],
                                  height: 8,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFF00C6FB),
                                          Color(0xFF005BEA)
                                        ]),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ]),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "${reviewPoint['6319e3fc821cfa1d84516cdf'].toString()}",
                                style: TextStyle(
                                  color: Color(0xff6E7995),
                                  fontSize: 14,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "접근성이 좋아요",
                                style: TextStyle(
                                    color: Color(0xff6E7995),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 21,
                          ),
                          Row(
                            children: [
                              Stack(children: [
                                Container(
                                  height: 8,
                                  width: 120,
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
                                  ),
                                ),
                                Container(
                                  width: reviewTotal == 0 ? 0 : (120 / reviewTotal) * reviewPoint['6319e6e529188e0099d9ec14'],
                                  height: 8,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFF00C6FB),
                                          Color(0xFF005BEA)
                                        ]),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ]),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "${reviewPoint['6319e6e529188e0099d9ec14'].toString()}",
                                style: TextStyle(
                                  color: Color(0xff6E7995),
                                  fontSize: 14,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "가격이 저렴해요",
                                style: TextStyle(
                                    color: Color(0xff6E7995),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      )),
                  SizedBox(height: 28,),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icon/home_board_icon.svg",
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 12,),
                      Text(
                        '게시글',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28,),
                ],
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
