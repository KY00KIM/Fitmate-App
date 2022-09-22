import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/presentation/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../domain/util.dart';
import '../../../ui/colors.dart';
import '../../../ui/show_toast.dart';
import '../../detail/detail.dart';
import '../../fitness_center/fitness_center.dart';
import 'package:http/http.dart' as http;

class HomeBoardWidget extends StatelessWidget {
  List posts;

  HomeBoardWidget({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: 420,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: posts.length > 3 ? 3 : posts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if(visit == true) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (BuildContext context) =>
                        LoginPage()), (route) => false);
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailMachingPage(post: posts[index],)));
              }
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(8, 10, 8, 10),
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
              width: 292,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 16),
                    height: 64,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image(
                            image: CachedNetworkImageProvider('${posts[index].userId.userProfileImg}'),
                            width: 32.0,
                            height: 32.0,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
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
                          width: 16,
                        ),
                        Text(
                          '${posts[index].userId.userNickname}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    width: 292,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image(
                        image: CachedNetworkImageProvider('${posts[index].postImg}'),
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset(
                            'assets/images/dummy.jpg',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 136,
                    padding: EdgeInsets.fromLTRB(16, 20, 16, 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                text: TextSpan(
                                  text:
                                  '${posts[index].postTitle}',
                                  style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 13,),
                            GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.only(top: 3),
                                child: SvgPicture.asset(
                                  "assets/icon/burger_icon.svg",
                                  width: 18,
                                  height: 18,
                                ),
                              ),
                              onTap: () {
                                if(visit == false) {
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
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  width: 40,
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(2.0),
                                                    color: Color(0xFFD1D9E6),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 36,
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    http.Response response =
                                                    await http.post(Uri.parse("https://fitmate.co.kr/v2/report/${posts[index].underId}"),
                                                        headers: {
                                                          "Authorization": "bearer $IdToken",
                                                        },
                                                        body: {});
                                                    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
                                                    if (response.statusCode != 201 &&
                                                        resBody["error"]["code"] == "auth/id-token-expired") {
                                                      IdToken =
                                                          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
                                                              .token
                                                              .toString();

                                                      response = await http.post(Uri.parse("https://fitmate.co.kr/v2/report/${posts[index].underId}"),
                                                          headers: {
                                                            "Authorization": "bearer $IdToken",
                                                          },
                                                          body: {});
                                                      resBody = jsonDecode(utf8.decode(response.bodyBytes));
                                                    }
                                                    if(resBody['success'] == true) FlutterToastBottom('신고가 접수되었습니다.');
                                                    else FlutterToastBottom('에러가 발생하였습니다.');
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    padding:
                                                    EdgeInsets.fromLTRB(20, 22, 20, 20),
                                                    height: 64,
                                                    width : size.width,
                                                    color: whiteTheme,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '게시글 신고',
                                                          style: TextStyle(
                                                            color: Color(0xFFCF2933),
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      });
                                }
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${posts[index].promiseDate.toString().substring(0, 10)}',
                                  style: TextStyle(
                                    color: Color(0xFF6E7995),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            GestureDetector(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                          text:
                                          '${posts[index].promiseLocation.centerName}',
                                          style: TextStyle(
                                            color: Color(0xFF283593),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 13,),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 3, 4, 0),
                                      child: SvgPicture.asset(
                                        "assets/icon/right_arrow_icon.svg",
                                        width: 14,
                                        height: 14,
                                        color: Color(0xFF283593),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                if(visit == true) {
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          LoginPage()), (route) => false);
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FitnessCenterPage(fitnessId: '${posts[index].promiseLocation.underId}',)));

                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
