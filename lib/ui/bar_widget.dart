import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../presentation/calender/calender.dart';
import '../presentation/chat_list/chat_list.dart';
import '../presentation/home/home.dart';
import '../presentation/map/map.dart';
import '../presentation/notice/notice.dart';
import '../presentation/profile/profile.dart';
import '../presentation/writing/writing.dart';
import '../ui/show_toast.dart';
import 'colors.dart';

class BarWidget {
  final double iconSize = 32.0;
  final String iconSource = "assets/icon/bar_icons/";
  bool isButtonActive = false;

  PreferredSizeWidget signUpAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: whiteTheme,
      toolbarHeight: 60,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: whiteTheme,
      ),
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
                "${iconSource}x_icon.svg",
                width: 18,
                height: 18,
              ),
              onPressed: () {
                print("hi");
              },
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget bulletinBoardAppBar(BuildContext context) {
    return AppBar(
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
                "${iconSource}back_icon.svg",
                width: 18,
                height: 18,
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
                  "${iconSource}plus_icon.svg",
                  width: 18,
                  height: 18,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WritingPage()));
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  PreferredSizeWidget writingAppBar(BuildContext context, bool Function() changeButtonActive) {
    return AppBar(
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
                "${iconSource}back_icon.svg",
                width: 18,
                height: 18,
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
                icon: changeButtonActive() ? SvgPicture.asset(
                  "${iconSource}write_check_icon.svg",
                  width: 18,
                  height: 18,
                ) : SvgPicture.asset(
                  "${iconSource}non_color_check_icon.svg",
                  width: 18,
                  height: 18,
                ),
                onPressed: () {
                  if(changeButtonActive()) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => WritingPage()));
                  }
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  PreferredSizeWidget detailAppBar(BuildContext context) {
    return AppBar(
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
                "${iconSource}back_icon.svg",
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
                  "${iconSource}burger_icon.svg",
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
                                  onTap: () {
                                    print("Container clicked");
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(20, 22, 20, 20),
                                    height: 64,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '게시글 신고',
                                          style: TextStyle(
                                            color: Color(0xFF000000),
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
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: whiteTheme,
      toolbarHeight: 76,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: whiteTheme,
      ),
      title: Padding(
        padding: EdgeInsets.only(left: 7.0),
        child: Text(
          'FitMate',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 20, 16),
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
                  "${iconSource}notice_icon.svg",
                  width: 18,
                  height: 18,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NoticePage()),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget bottomNavigationBar(BuildContext context, int pages) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(55, 84, 170, 0.1),
            spreadRadius: 4,
            blurRadius: 12,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          topLeft: Radius.circular(12),
        ),
        child: BottomAppBar(
          elevation: 10,
          color: whiteTheme,
          child: Container(
            width: size.width,
            height: 60.0,
            child: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      if (pages != 1) {
                        //Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    HomePage(reload: false),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      }
                    },
                    icon: pages == 1
                        ? SvgPicture.asset(
                            // 5
                            "${iconSource}home_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          )
                        : SvgPicture.asset(
                            // 5
                            "${iconSource}Inactive_home_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (pages != 2) {
                        //Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    ChatListPage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      }
                    },
                    icon: pages == 2
                        ? SvgPicture.asset(
                            // 5
                            "${iconSource}chatting_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          )
                        : SvgPicture.asset(
                            // 5
                            "${iconSource}Inactive_chatting_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (pages != 3) {
                        //Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    MapPage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      }
                    },
                    icon: pages == 3
                        ? SvgPicture.asset(
                            // 5
                            "${iconSource}map_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          )
                        : SvgPicture.asset(
                            // 5
                            "${iconSource}Inactive_map_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (pages != 4) {
                        //Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    CalenderPage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      }
                    },
                    icon: pages == 4
                        ? SvgPicture.asset(
                            // 5
                            "${iconSource}calender_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          )
                        : SvgPicture.asset(
                            // 5
                            "${iconSource}Inactive_calender_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (pages != 5) {
                        //Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    ProfilePage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      }
                    },
                    icon: pages == 5
                        ? SvgPicture.asset(
                            // 5
                            "${iconSource}profile_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          )
                        : SvgPicture.asset(
                            // 5
                            "${iconSource}Inactive_profile_icon.svg",
                            width: iconSize,
                            height: iconSize,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget nextBackAppBar(BuildContext context, Widget nextPage,
      bool Function() changeButtonActive) {
    return AppBar(
      centerTitle: false,
      backgroundColor: whiteTheme,
      toolbarHeight: 60,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: whiteTheme,
      ),
      title: Padding(
        padding: EdgeInsets.fromLTRB(6, 8, 6, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
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
                  child: SvgPicture.asset(
                    "${iconSource}x_icon.svg",
                    width: 16,
                    height: 16,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                }),
            Container(
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
                  icon: changeButtonActive()
                      ? SvgPicture.asset(
                          "${iconSource}arrowNextActive.svg",
                          width: 18,
                          height: 18,
                        )
                      : SvgPicture.asset(
                          "${iconSource}arrowNextDeactive.svg",
                          width: 18,
                          height: 18,
                        ),
                  onPressed: changeButtonActive()
                      ? () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        nextPage,
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ));
                        }
                      : () {
                          FlutterToastTop("모든 항목을 입력해주세요");
                        },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
