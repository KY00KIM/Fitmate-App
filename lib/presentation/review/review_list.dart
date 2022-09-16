import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../domain/util.dart';
import '../../ui/colors.dart';

class ReviewListPage extends StatefulWidget {
  List reviewData;
  String title;
  List nickName;
  List profileImg;

  ReviewListPage({Key? key, required this.reviewData, required this.title, required this.nickName, required this.profileImg,}) : super(key: key);

  @override
  State<ReviewListPage> createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  int point = 0;

  @override
  void initState() {
    super.initState();
    if(widget.reviewData.length != 0) {
      for(int i = 0; i< widget.reviewData.length; i++) {
        if(widget.title == "메이트") {
          point += widget.reviewData[i]['user_rating'] as int;
        } else {
          point += widget.reviewData[i]['center_rating'] as int;
        }
      }
      point = point ~/ widget.reviewData.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    log("reviews : ${widget.reviewData}");
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
      ),
      body: Container(
        width: size.width,
        padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.title} 리뷰 ${widget.reviewData.length}',
              style: TextStyle(
                color: Color(0xFF6E7995),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 19,),
            Container(
              width: size.width - 40,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.reviewData.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 15),
                    width: size.width - 40,
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
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius:
                          BorderRadius.circular(100.0),
                          child: Image.network(
                            widget.title == "메이트" ? '${widget.profileImg[index]}' :'${widget.reviewData[index]['review_send_id']['user_profile_img']}',
                            width: 40.0,
                            height: 40.0,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception,
                                StackTrace? stackTrace) {
                              return Image.asset(
                                'assets/images/profile_null_image.png',
                                fit: BoxFit.cover,
                                width: 40.0,
                                height: 40.0,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 16,),
                        Column(
                          children: [
                            Container(
                              width: size.width - 128,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.title == "메이트" ? '${widget.nickName[index]}' :'${widget.reviewData[index]['review_send_id']['user_nickname']}',
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '${widget.reviewData[index]['createdAt'].toString().substring(0,10)} ${widget.reviewData[index]['createdAt'].toString().substring(11,16)}',
                                    style: TextStyle(
                                      color: Color(0xFF6E7995),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 13,),
                            Container(
                              width: size.width - 128,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 100,
                                      strutStyle:
                                      StrutStyle(fontSize: 16),
                                      text: TextSpan(
                                        text: widget.title == "메이트" ? '${widget.reviewData[index]['review_body'] == null ? '' : widget.reviewData[index]['review_body']}' : '${widget.reviewData[index]['center_review'] == null ? '' : widget.reviewData[index]['center_review']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              child: Row(
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
                                mainAxisAlignment: MainAxisAlignment.start,
                              ),
                              width: size.width - 128,
                            ),
                          ],
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
