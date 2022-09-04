import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../presentation/calender.dart';
import '../presentation/chatList.dart';
import '../presentation/home/home.dart';
import '../presentation/map.dart';
import '../presentation/profile.dart';
import 'colors.dart';

class BarWidget {
  final double iconSize = 32.0;
  final String iconSource = "assets/icon/bar_icons/";

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

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: whiteTheme,
      toolbarHeight: 76,
      elevation: 0,
      title: Padding(
        padding: EdgeInsets.only(left: 7.0),
        child: Text(
          'FitMate',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
          ),
        ),
      ),
    );
  }

  Widget bottomNavigationBar(BuildContext context, int pages) {
    final Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(12),
        topLeft: Radius.circular(12),
      ),
      child: BottomAppBar(
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
                                  MatchingPage(),
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
    );
  }
}
