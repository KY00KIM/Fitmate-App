import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/presentation/post/post.dart';
import 'package:fitmate/presentation/search_center/search_center.dart';
import 'package:fitmate/presentation/write_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitmate/ui/bar_widget.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../domain/repository/signup-view-model.dart';

import '../../domain/util.dart';
import '../../ui/show_toast.dart';
import '../home/home.dart';

class SignupPage2 extends StatefulWidget {
  const SignupPage2({Key? key}) : super(key: key);

  @override
  State<SignupPage2> createState() => _SignupPageState2();
}

class _SignupPageState2 extends State<SignupPage2> {
  final viewModel = signUpViewModel();
  final barWidget = BarWidget();

  String? center;
  String? centerName;
  bool checkValid() {
    if (viewModel.selectedLocation == null ||
        viewModel.selectedSemiLocation == null ||
        viewModel.selectedStartTime == '시간 선택' ||
        viewModel.selectedEndTime == '시간 선택') {
      print("deactivate");
      return false;
    }
    print("activate");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //widget.idToken;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: barWidget.nextBackAppBar(
            context, HomePage(reload: true), checkValid),
        backgroundColor: const Color(0xffF2F3F7),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Container(
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '회원가입',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff6e7995),
                          fontSize: 25.0,
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Text(
                        '우리동네',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(
                        height: 21,
                      ),
                      Text("도/특별시/광역시",
                          style: TextStyle(
                              color: Color(0xff6E7995),
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.5),
                      Container(
                        height: 52,
                        decoration: inset.BoxDecoration(
                          color: const Color(0xffEFEFEF),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              width: 1.0, color: const Color(0xffffffff)),
                          boxShadow: const [
                            inset.BoxShadow(
                              offset: Offset(-30, -30),
                              blurRadius: 100,
                              color: Color.fromARGB(0, 46, 46, 191),
                              inset: true,
                            ),
                            inset.BoxShadow(
                              offset: Offset(3, 3),
                              blurRadius: 6,
                              spreadRadius: 1,
                              color: Color.fromARGB(255, 169, 176, 189),
                              inset: true,
                            ),
                          ],
                        ),
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                hint: Text(
                                  "지역을 선택하세요",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xff6E7995),
                                  ),
                                ),
                                isExpanded: true,
                                items: viewModel.locationMap.keys
                                    .map((item) => DropdownMenuItem<String>(
                                        value: item, child: Text(item)))
                                    .toList(),
                                value: viewModel.selectedLocation,
                                onChanged: (value) {
                                  setState(() {
                                    viewModel.selectedLocation =
                                        value as String;
                                    viewModel.selectedSemiLocation = null;
                                  });
                                },
                                icon: SvgPicture.asset(
                                    'assets/icon/dropArrow.svg'),
                                iconSize: 20,
                                iconEnabledColor: Colors.black,
                                iconDisabledColor: Colors.grey,
                                dropdownMaxHeight: 400,
                                dropdownWidth: 300,
                                dropdownPadding: EdgeInsets.only(left: 10),
                                dropdownDecoration: BoxDecoration(
                                  color: Color(0xffF2F3F7),
                                ),
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 23.5,
                      ),
                      Text("시/군/구",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff6E7995))),
                      SizedBox(height: 13.5),
                      Container(
                        height: 52,
                        decoration: inset.BoxDecoration(
                          color: const Color(0xffEFEFEF),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              width: 1.0, color: const Color(0xffffffff)),
                          boxShadow: const [
                            inset.BoxShadow(
                              offset: Offset(-30, -30),
                              blurRadius: 100,
                              color: Color.fromARGB(0, 46, 46, 191),
                              inset: true,
                            ),
                            inset.BoxShadow(
                              offset: Offset(3, 3),
                              blurRadius: 6,
                              spreadRadius: 1,
                              color: Color.fromARGB(255, 169, 176, 189),
                              inset: true,
                            ),
                          ],
                        ),
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                hint: Text(
                                  "동네를 선택해주세요",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xff6E7995),
                                  ),
                                ),
                                isExpanded: true,
                                items: viewModel.selectedLocation == "" &&
                                        viewModel.locationMap[
                                                viewModel.selectedLocation] ==
                                            null
                                    ? [
                                        DropdownMenuItem(
                                            value: null,
                                            child: Text("결과가 없습니다."))
                                      ]
                                    : viewModel
                                        .locationMap[viewModel.selectedLocation]
                                        ?.map(
                                            (item) => DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(item),
                                                ))
                                        .toList(),
                                value: viewModel.selectedSemiLocation,
                                onChanged: (value) {
                                  setState(() {
                                    viewModel.selectedSemiLocation =
                                        value as String;
                                  });
                                },
                                icon: SvgPicture.asset(
                                    'assets/icon/dropArrow.svg'),
                                iconSize: 20,
                                iconEnabledColor: Colors.black,
                                iconDisabledColor: Colors.grey,
                                dropdownMaxHeight: 400,
                                dropdownWidth: 300,
                                dropdownPadding: EdgeInsets.only(left: 10),
                                dropdownDecoration: BoxDecoration(
                                  color: Color(0xffF2F3F7),
                                ),
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Text("내 피트니스 센터",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff6E7995))),
                      SizedBox(height: 13.5),
                      Container(
                        height: 52,
                        decoration: inset.BoxDecoration(
                          color: const Color(0xffEFEFEF),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              width: 1.0, color: const Color(0xffffffff)),
                          boxShadow: const [
                            inset.BoxShadow(
                              offset: Offset(-30, -30),
                              blurRadius: 100,
                              color: Color.fromARGB(0, 46, 46, 191),
                              inset: true,
                            ),
                            inset.BoxShadow(
                              offset: Offset(3, 3),
                              blurRadius: 6,
                              spreadRadius: 1,
                              color: Color.fromARGB(255, 169, 176, 189),
                              inset: true,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: InkWell(
                            onTap: () async {
                              var onValue = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SearchCenterPage()));
                              print("end");
                              setState(() {
                                center = onValue;
                                centerName = onValue['place_name'];
                              });
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      strutStyle: StrutStyle(fontSize: 15),
                                      text: TextSpan(
                                        text: '피트니스 센터를 검색',
                                        style: TextStyle(
                                          color: Color(0xFF878E97),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.fitness_center,
                                    color: Color(0xFF878E97),
                                    size: 17.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      Text(
                        "운동 스케줄",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "운동요일",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(
                            0xff6E7995,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: viewModel.weekdayKor
                              .map(
                                (weekday) => ElevatedButton(
                                  child: Text(
                                    weekday,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: viewModel.isSelectedWeekDay[
                                                  viewModel
                                                      .weekdayToEng[weekday]] ==
                                              false
                                          ? Color(0xFF6E7995)
                                          : Color(0xFFffffff),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      viewModel.isSelectedWeekDay[
                                              viewModel.weekdayToEng[weekday]] =
                                          !viewModel.isSelectedWeekDay[
                                              viewModel.weekdayToEng[weekday]];
                                      print(viewModel.isSelectedWeekDay);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(40, 40),
                                    minimumSize: Size(40, 40),
                                    padding: EdgeInsets.only(right: 0),
                                    shape: const CircleBorder(),
                                    primary: viewModel.isSelectedWeekDay[
                                                viewModel
                                                    .weekdayToEng[weekday]] ==
                                            false
                                        ? Color(0xFFF2F3F7)
                                        : Color(0xFF3F51B5),
                                    elevation: 0,
                                    side: BorderSide(
                                      color: Color(0xFFD1D9E6),
                                      width: viewModel.isSelectedWeekDay[
                                                  viewModel
                                                      .weekdayToEng[weekday]] ==
                                              false
                                          ? 1
                                          : 0,
                                    ),
                                  ),
                                ),
                              )
                              .toList()),
                      SizedBox(
                        height: 26,
                      ),
                      Text("운동 시작시간",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff6E7995))),
                      SizedBox(height: 12),
                      Container(
                        height: 50,
                        decoration: inset.BoxDecoration(
                          color: const Color(0xffEFEFEF),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              width: 1.0, color: const Color(0xffffffff)),
                          boxShadow: const [
                            inset.BoxShadow(
                              offset: Offset(-30, -30),
                              blurRadius: 100,
                              color: Color.fromARGB(0, 46, 46, 191),
                              inset: true,
                            ),
                            inset.BoxShadow(
                              offset: Offset(3, 3),
                              blurRadius: 6,
                              spreadRadius: 1,
                              color: Color.fromARGB(255, 169, 176, 189),
                              inset: true,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: InkWell(
                            onTap: () {
                              Future<TimeOfDay?> future = showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              future.then((timeOfDay) {
                                setState(() {
                                  if (timeOfDay != null) {
                                    viewModel.selectedStartTime =
                                        '${viewModel.selectTime(timeOfDay.hour)}:${viewModel.selectTime(timeOfDay.minute)}';
                                  }
                                  print('$viewModel.selectedStartTime');
                                });
                              });
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '  ${viewModel.selectedStartTime}',
                                    style: TextStyle(
                                      color: Color(0xFF878E97),
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Icon(
                                    Icons.schedule,
                                    color: Color(0xFF878E97),
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Text("운동 종료시간",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff6E7995))),
                      SizedBox(height: 12),
                      Container(
                        height: 50,
                        decoration: inset.BoxDecoration(
                          color: const Color(0xffEFEFEF),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              width: 1.0, color: const Color(0xffffffff)),
                          boxShadow: const [
                            inset.BoxShadow(
                              offset: Offset(-30, -30),
                              blurRadius: 100,
                              color: Color.fromARGB(0, 46, 46, 191),
                              inset: true,
                            ),
                            inset.BoxShadow(
                              offset: Offset(3, 3),
                              blurRadius: 6,
                              spreadRadius: 1,
                              color: Color.fromARGB(255, 169, 176, 189),
                              inset: true,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: InkWell(
                            onTap: () {
                              Future<TimeOfDay?> future = showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              future.then((timeOfDay) {
                                setState(() {
                                  if (timeOfDay != null) {
                                    viewModel.selectedEndTime =
                                        '${viewModel.selectTime(timeOfDay.hour)}:${viewModel.selectTime(timeOfDay.minute)}';
                                  }
                                  print('${viewModel.selectedEndTime}');
                                });
                              });
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '  ${viewModel.selectedEndTime}',
                                    style: TextStyle(
                                      color: Color(0xFF878E97),
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Icon(
                                    Icons.schedule,
                                    color: Color(0xFF878E97),
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
