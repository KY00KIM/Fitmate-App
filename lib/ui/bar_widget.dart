import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../presentation/calender.dart';
import '../presentation/chatList.dart';
import '../presentation/home/home.dart';
import '../presentation/map.dart';
import '../presentation/profile.dart';
import 'colors.dart';

class BarWidget {

  Widget bottomNavigationBar(BuildContext context, int pages) {
    final Size size = MediaQuery.of(context).size;
    final double iconSize = 32.0;
    final String iconSource = "assets/icon/bottom_navigator/";
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
                    if(pages != 1) {
                      //Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              HomePage(reload: false),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    }
                  },
                  icon: pages == 1 ? SvgPicture.asset( // 5
                    "${iconSource}home_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  ) : SvgPicture.asset( // 5
                    "${iconSource}Inactive_home_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if(pages != 2) {
                      //Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              ChatListPage(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    }
                  },
                  icon: pages == 2 ? SvgPicture.asset( // 5
                    "${iconSource}chatting_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  ) : SvgPicture.asset( // 5
                    "${iconSource}Inactive_chatting_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if(pages != 3) {
                      //Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              MapPage(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    }
                  },
                  icon: pages == 3 ? SvgPicture.asset( // 5
                    "${iconSource}map_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  ) : SvgPicture.asset( // 5
                    "${iconSource}Inactive_map_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if(pages != 4) {
                      //Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              MatchingPage(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    }
                  },
                  icon: pages == 4 ? SvgPicture.asset( // 5
                    "${iconSource}calender_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  ) : SvgPicture.asset( // 5
                    "${iconSource}Inactive_calender_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if(pages != 5) {
                      //Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              ProfilePage(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    }
                  },
                  icon: pages == 5 ? SvgPicture.asset( // 5
                    "${iconSource}profile_icon.svg",
                    width: iconSize,
                    height: iconSize,
                  ) : SvgPicture.asset( // 5
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