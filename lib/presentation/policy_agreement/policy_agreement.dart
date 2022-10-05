import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fitmate/presentation/login/components/apple_login_widget.dart';
import 'package:fitmate/presentation/login/components/google_login_widget.dart';
import 'package:fitmate/presentation/login/components/kakao_login_widget.dart';
import 'package:fitmate/presentation/signup/signup.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'component/apppolicy.dart';
import 'component/policyAgreementAppBar.dart';

class PolicyAgreementPage extends StatefulWidget {
  late Map user_object;
  PolicyAgreementPage({required this.user_object});
  @override
  _PolicyAgreementPageState createState() => _PolicyAgreementPageState();
}

class _PolicyAgreementPageState extends State<PolicyAgreementPage> {
  final barWidget = BarWidget();
  bool appUsagePolicy = false;
  bool personalInfoPolicy = false;
  bool locationUsagePolicy = false;
  bool allAgreed = false;
  final String iconSource = "assets/icon/";

  bool checkValid() {
    return appUsagePolicy && personalInfoPolicy && locationUsagePolicy;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar:
            barWidget.nextBackAppBar(context, checkValid, widget.user_object),
        backgroundColor: const Color(0xfff2f3f7),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 110, 20, 20),
                child: Column(
                  children: [
                    Container(
                      height: 84,
                      width: 84,
                      child: Image.asset(
                        "assets/icon/icon-round.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 130,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '이용약관',
                          style: TextStyle(
                            color: Color(0xFF6E7995),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                BoxShadow(
                                color: const Color.fromRGBO(0, 0, 0, 0.16), // shadow color
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
                                width: 28,
                                height: 28,
                                child: IconButton(
                                  icon: allAgreed
                                      ? SvgPicture.asset(
                                          "${iconSource}checkIcon.svg",
                                          width: 20,
                                          height: 20,
                                        )
                                      : Opacity(
                                          opacity: 0.0,
                                          child: SvgPicture.asset(
                                            "${iconSource}checkIcon.svg",
                                            width: 20,
                                            height: 20,
                                          ),
                                        ),
                                  onPressed: () {
                                    setState(() {
                                      allAgreed = !allAgreed;
                                      locationUsagePolicy = allAgreed;
                                      personalInfoPolicy = allAgreed;
                                      appUsagePolicy = allAgreed;
                                      print(
                                          "ALL clicked : ${allAgreed}: ${appUsagePolicy} ${personalInfoPolicy} ${locationUsagePolicy}");
                                    });
                                  },
                                )),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              "이용약관 전체 동의",
                              style: TextStyle(
                                  color: Color(0xff6E7995),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Container(
                          width: size.width - 50,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xffD1D9E6)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromRGBO(0, 0, 0, 0.16), // shadow color
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
                                    width: 28,
                                    height: 28,
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            appUsagePolicy = !appUsagePolicy;
                                            allAgreed = appUsagePolicy &&
                                                personalInfoPolicy &&
                                                locationUsagePolicy;
                                            print(
                                                "appPolicy Clicked:${allAgreed}: ${appUsagePolicy} ${personalInfoPolicy} ${locationUsagePolicy}");
                                          });
                                        },
                                        icon: appUsagePolicy
                                            ? SvgPicture.asset(
                                                "${iconSource}checkIcon.svg",
                                                width: 20,
                                                height: 20,
                                              )
                                            : Opacity(
                                                opacity: 0.0,
                                                child: SvgPicture.asset(
                                                  "${iconSource}checkIcon.svg",
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ))),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  "서비스 이용약관 동의 (필수)",
                                  style: TextStyle(
                                      color: Color(0xff6E7995),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
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
                                      return Wrap(children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("서비스 이용약관",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff6E7995))),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                                height: size.height - 200,
                                                child: SingleChildScrollView(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 10, 20, 30),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFF2F3F7)),
                                                    child: Text("${policy1}"),
                                                  ),
                                                ))
                                          ],
                                        )
                                      ]);
                                    });
                              },
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
                                child: Image.asset(
                                  '${iconSource}rightArrow.png',
                                  width: 16,
                                  height: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromRGBO(0, 0, 0, 0.16), // shadow color
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
                                    width: 28,
                                    height: 28,
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            personalInfoPolicy =
                                                !personalInfoPolicy;
                                            allAgreed = appUsagePolicy &&
                                                personalInfoPolicy &&
                                                locationUsagePolicy;
                                            print(
                                                "personalInfoPolicy Clicked:${allAgreed}: ${appUsagePolicy} ${personalInfoPolicy} ${locationUsagePolicy}");
                                          });
                                        },
                                        icon: personalInfoPolicy
                                            ? SvgPicture.asset(
                                                "${iconSource}checkIcon.svg",
                                                width: 20,
                                                height: 20,
                                              )
                                            : Opacity(
                                                opacity: 0.0,
                                                child: SvgPicture.asset(
                                                  "${iconSource}checkIcon.svg",
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ))),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  "개인정보 수집 및 이용 동의 (필수)",
                                  style: TextStyle(
                                      color: Color(0xff6E7995),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
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
                                      return Wrap(children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("개인정보 수집 및 이용 동의",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff6E7995))),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                                height: size.height - 200,
                                                child: SingleChildScrollView(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 10, 20, 30),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFF2F3F7)),
                                                    child: Text("${policy2}"),
                                                  ),
                                                ))
                                          ],
                                        )
                                      ]);
                                    });
                              },
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
                                child: Image.asset(
                                  '${iconSource}rightArrow.png',
                                  width: 16,
                                  height: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromRGBO(0, 0, 0, 0.16), // shadow color
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
                                    width: 28,
                                    height: 28,
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            locationUsagePolicy =
                                                !locationUsagePolicy;
                                            allAgreed = appUsagePolicy &&
                                                personalInfoPolicy &&
                                                locationUsagePolicy;
                                            print(
                                                "appPolicy Clicked:${allAgreed}: ${appUsagePolicy} ${personalInfoPolicy} ${locationUsagePolicy}");
                                          });
                                        },
                                        icon: locationUsagePolicy
                                            ? SvgPicture.asset(
                                                "${iconSource}checkIcon.svg",
                                                width: 20,
                                                height: 20,
                                              )
                                            : Opacity(
                                                opacity: 0.0,
                                                child: SvgPicture.asset(
                                                  "${iconSource}checkIcon.svg",
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ))),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  "위치기반 서비스 이용 동의 (필수)",
                                  style: TextStyle(
                                      color: Color(0xff6E7995),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
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
                                      return Wrap(children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("위치기반 서비스 이용 동의",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff6E7995))),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                                height: size.height - 200,
                                                child: SingleChildScrollView(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 10, 20, 30),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFF2F3F7)),
                                                    child: Text("${policy3}"),
                                                  ),
                                                ))
                                          ],
                                        )
                                      ]);
                                    });
                              },
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
                                child: Image.asset(
                                  '${iconSource}rightArrow.png',
                                  width: 16,
                                  height: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
