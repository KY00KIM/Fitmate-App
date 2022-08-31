import 'package:fitmate/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../screens/chatList.dart';
import '../screens/map.dart';
import '../screens/matching.dart';
import '../screens/profile.dart';

Widget bottomNavigationBar(BuildContext context, int pages) {
  final Size size = MediaQuery.of(context).size;
  final double iconSize = 26.0;
  return BottomAppBar(
    color: Color(0xFF22232A),
    child: Container(
      width: size.width,
      height: 55.0,
      //height: size.height * 0.07,
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
              icon: pages == 1 ? Icon( // 5
                Iconsax.home5,
                color: Color(0xFFffffff),
                //size: size.width * 0.065,
                size: iconSize,
              ) : Icon( // 5
                Iconsax.home_1,
                color: Color(0xFF757575),
                //size: size.width * 0.065,
                size: iconSize,
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
              icon: pages == 2 ? Icon(
                Iconsax.message5,
                color: Color(0xFFffffff),
                //size: size.width * 0.065,
                size: iconSize,
              ) : Icon(
                Iconsax.message,
                color: Color(0xFF757575),
                //size: size.width * 0.065,
                size: iconSize,
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
              icon: pages == 3 ? Icon(
                Iconsax.location5,
                color: Color(0xFFffffff),
                //size: size.width * 0.065,
                size: iconSize,
              ) : Icon(
                Iconsax.location,
                color: Color(0xFF757575),
                //size: size.width * 0.065,
                size: iconSize,
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
              icon: pages == 4 ? Icon(
                Iconsax.calendar5,
                color: Color(0xFFffffff),
                //size: size.width * 0.065,
                size: iconSize,
              ) : Icon(
                Iconsax.calendar_1,
                color: Color(0xFF757575),
                //size: size.width * 0.065,
                size: iconSize,
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
              icon: pages == 5 ? Icon(
                Iconsax.profile_circle5,
                color: Color(0xFFffffff),
                //size: size.width * 0.065,
                size: iconSize,
              ) : Icon(
                Iconsax.profile_circle,
                color: Color(0xFF757575),
                //size: size.width * 0.065,
                size: iconSize,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}