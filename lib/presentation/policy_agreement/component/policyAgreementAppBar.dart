import 'package:fitmate/presentation/signup/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../ui/show_toast.dart';
import '../../../ui/colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;
import '../../signup/component/signup-view-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../data/firebase_service/firebase_auth_methods.dart';
import '../../../domain/util.dart';

class BarWidget {
  final double iconSize = 32.0;
  final String iconSource = "assets/icon/bar_icons/";
  bool isButtonActive = false;

  PreferredSizeWidget nextBackAppBar(BuildContext context,
      bool Function() changeButtonActive, Map user_object) {
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
                      ? () async {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      SignupPage1(
                                user_object: user_object,
                              ),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
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
