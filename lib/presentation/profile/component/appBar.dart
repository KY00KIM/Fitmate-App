import 'package:fitmate/presentation/home/home.dart';
import 'package:fitmate/presentation/profile/component/profile_edit_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../ui/show_toast.dart';
import '../../../ui/colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../data/firebase_service/firebase_auth_methods.dart';
import '../../../domain/util.dart';

class BarWidget {
  final double iconSize = 32.0;
  final String iconSource = "assets/icon/";
  bool isButtonActive = false;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  void createUserInFirestore() {
    users
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .limit(1)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          users.add({
            'name': UserData['user_name'],
            'uid': FirebaseAuth.instance.currentUser?.uid
          });
        }
      },
    ).catchError((error) {});
  }

  PreferredSizeWidget nextBackAppBar(
    BuildContext context,
    profileEditViewModel viewModel,
  ) {
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
                  icon: SvgPicture.asset(
                    "${iconSource}checkIcon.svg",
                    width: 18,
                    height: 18,
                  ),
                  onPressed: () async {
                    context.loaderOverlay.show();
                    await viewModel.sendEditProfile();
                    await UpdateUserData();
                    context.loaderOverlay.hide();
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  HomePage(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ));
                    // if (conditionalFunction != null &&
                    //     viewModel != null) {
                    //   createUserInFirestore();
                    //   if (await viewModel.sendSignUp()) {
                    //     await UpdateUserData();
                    //     Navigator.pushNamedAndRemoveUntil(
                    //         context, '/', (_) => false);
                    //     Navigator.pushReplacement(
                    //         context,
                    //         PageRouteBuilder(
                    //           pageBuilder: (context, animation,
                    //                   secondaryAnimation) =>
                    //               nextPage,
                    //           transitionDuration: Duration.zero,
                    //           reverseTransitionDuration: Duration.zero,
                    //         ));
                    //   } else {
                    //     FlutterToastTop("회원가입 중 문제가 발생했습니다");
                    //   }
                    // } else {
                    //   Navigator.push(
                    //       context,
                    //       PageRouteBuilder(
                    //         pageBuilder: (context, animation,
                    //                 secondaryAnimation) =>
                    //             nextPage,
                    //         transitionDuration: Duration.zero,
                    //         reverseTransitionDuration: Duration.zero,
                    //       ));
                    // }
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
