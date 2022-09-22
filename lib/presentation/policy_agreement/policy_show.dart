import 'dart:io';

import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'component/apppolicy.dart';
import 'component/policy_show_app_bar.dart';

class PolicyShowPage extends StatefulWidget {
  late Map user_object;
  @override
  _PolicyShowPageState createState() => _PolicyShowPageState();
}

class _PolicyShowPageState extends State<PolicyShowPage> {
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
        appBar: barWidget.backAppBar(context),
        backgroundColor: const Color(0xfff2f3f7),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, (size.height * 0.1), 20, 0),
                child: Column(
                  children: [
                    Container(
                      height: size.width * 0.2,
                      width: size.width * 0.2,
                      child: Image.asset(
                        "assets/icon/icon-round.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.2,
                    ),
                    Row(
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
                      height: size.height * 0.03,
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
                      height: size.height * 0.03,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text("서비스 이용 약관",
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
                                            padding: EdgeInsets.fromLTRB(
                                                20, 10, 20, 30),
                                            decoration: BoxDecoration(
                                                color: Color(0xFFF2F3F7)),
                                            child: Text("${policy1}"),
                                          ),
                                        ))
                                  ],
                                )
                              ]);
                            });
                      },
                      child: Container(
                          width: double.infinity,
                          height: 64,
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                              Text("서비스 이용약관",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff6E7995),
                                      fontWeight: FontWeight.bold)),
                              Spacer(),
                              Container(
                                width: 18,
                                height: 18,
                                child: Image.asset(
                                  '${iconSource}rightArrow.png',
                                  width: 16,
                                  height: 16,
                                ),
                              )
                            ],
                          )),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text("개인정보 수집 및 이용 약관",
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
                                            padding: EdgeInsets.fromLTRB(
                                                20, 10, 20, 30),
                                            decoration: BoxDecoration(
                                                color: Color(0xFFF2F3F7)),
                                            child: Text("${policy2}"),
                                          ),
                                        ))
                                  ],
                                )
                              ]);
                            });
                      },
                      child: Container(
                          width: double.infinity,
                          height: 64,
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                              Text("개인정보 수집 및 이용 약관",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff6E7995),
                                      fontWeight: FontWeight.bold)),
                              Spacer(),
                              Container(
                                width: 18,
                                height: 18,
                                child: Image.asset(
                                  '${iconSource}rightArrow.png',
                                  width: 16,
                                  height: 16,
                                ),
                              )
                            ],
                          )),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text("위치기반 서비스 이용 약관",
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
                                            padding: EdgeInsets.fromLTRB(
                                                20, 10, 20, 30),
                                            decoration: BoxDecoration(
                                                color: Color(0xFFF2F3F7)),
                                            child: Text("${policy3}"),
                                          ),
                                        ))
                                  ],
                                )
                              ]);
                            });
                      },
                      child: Container(
                          width: double.infinity,
                          height: 64,
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                              Text("위치기반 서비스 이용 약관",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff6E7995),
                                      fontWeight: FontWeight.bold)),
                              Spacer(),
                              Container(
                                width: 18,
                                height: 18,
                                child: Image.asset(
                                  '${iconSource}rightArrow.png',
                                  width: 16,
                                  height: 16,
                                ),
                              )
                            ],
                          )),
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
