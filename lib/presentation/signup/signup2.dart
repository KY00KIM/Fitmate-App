import 'package:fitmate/presentation/search_center/search_center.dart';
import 'package:fitmate/presentation/signup/signup3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'component/signup-view-model.dart';
import 'component/appBar.dart';

import '../home/home.dart';

class SignupPage2 extends StatefulWidget {
  late signUpViewModel viewModel;
  SignupPage2({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<SignupPage2> createState() => _SignupPageState2();
}

class _SignupPageState2 extends State<SignupPage2> {
  final barWidget = BarWidget();

  bool checkValid() {
    if (widget.viewModel.selectedLocation == null ||
        widget.viewModel.selectedSemiLocation == null ||
        widget.viewModel.selectedTime == -1) {
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
        /*
        appBar: barWidget.nextBackAppBar(context, HomePage(reload: true),
            checkValid, widget.viewModel, widget.viewModel.sendSignUp),

         */

        appBar: barWidget.nextBackAppBar(
            context,
            SignupPage3(
              viewModel: widget.viewModel,
            ),
            2,
            checkValid,
            null,
            null),
        backgroundColor: const Color(0xffF2F3F7),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: Column(
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
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            buttonPadding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            hint: Text(
                              "지역을 선택하세요",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Color(0xff6E7995),
                              ),
                            ),
                            isExpanded: true,
                            items: widget.viewModel.locationMap.keys
                                .map((item) => DropdownMenuItem<String>(
                                    value: item, child: Text(item)))
                                .toList(),
                            value: widget.viewModel.selectedLocation,
                            onChanged: (value) {
                              setState(() {
                                widget.viewModel.selectedLocation =
                                    value as String;
                                widget.viewModel.selectedSemiLocation = null;
                              });
                            },
                            icon:
                                SvgPicture.asset('assets/icon/dropArrow.svg'),
                            iconSize: 20,
                            iconEnabledColor: Colors.black,
                            iconDisabledColor: Colors.grey,
                            dropdownMaxHeight: 400,
                            dropdownWidth: size.width - 40,
                            dropdownPadding: EdgeInsets.only(left: 10),
                            dropdownDecoration: BoxDecoration(
                              color: Color(0xffF2F3F7),
                              borderRadius:BorderRadius.circular(8),
                            ),
                          ),
                        ),
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
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            buttonPadding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                            hint: Text(
                              "동네를 선택해주세요",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Color(0xff6E7995),
                              ),
                            ),
                            isExpanded: true,
                            items: widget.viewModel.selectedLocation ==
                                        "" &&
                                    widget.viewModel.locationMap[widget
                                            .viewModel.selectedLocation] ==
                                        null
                                ? [
                                    DropdownMenuItem(
                                        value: null,
                                        child: Text("결과가 없습니다."))
                                  ]
                                : widget
                                    .viewModel
                                    .locationMap[
                                        widget.viewModel.selectedLocation]
                                    ?.map(
                                        (item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(item),
                                            ))
                                    .toList(),
                            value: widget.viewModel.selectedSemiLocation,
                            onChanged: (value) {
                              setState(() {
                                widget.viewModel.selectedSemiLocation =
                                    value as String;
                              });
                            },
                            icon: SvgPicture.asset(
                                'assets/icon/dropArrow.svg'),
                            iconSize: 20,
                            iconEnabledColor: Colors.black,
                            iconDisabledColor: Colors.grey,
                            dropdownMaxHeight: 400,
                            dropdownWidth: size.width - 40,
                            dropdownPadding: EdgeInsets.only(left: 10),
                            dropdownDecoration: BoxDecoration(
                              color: Color(0xffF2F3F7),
                              borderRadius:BorderRadius.circular(8),
                            ),
                          ),
                        ),
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
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: InkWell(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchCenterPage()),
                              ).then((onValue) {
                                print(onValue);
                                onValue == null
                                    ? null
                                    : setState(() {
                                        widget.viewModel.center = onValue;
                                        widget.viewModel.centerName = widget
                                            .viewModel.center['center_name'];
                                        print(
                                            "center : ${widget.viewModel.center}");
                                      });
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
                                        text: widget.viewModel.centerName,
                                        style: TextStyle(
                                          color: widget.viewModel.centerName ==
                                                  "피트니스 센터를 검색"
                                              ? Color(0xFF878E97)
                                              : Colors.black,
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
                          children: widget.viewModel.weekdayKor
                              .map(
                                (weekday) => ElevatedButton(
                                  child: Text(
                                    weekday,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: widget.viewModel.isSelectedWeekDay[
                                                  widget.viewModel
                                                      .weekdayToEng[weekday]] ==
                                              false
                                          ? Color(0xFF6E7995)
                                          : Color(0xFFffffff),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      widget.viewModel.isSelectedWeekDay[widget
                                              .viewModel
                                              .weekdayToEng[weekday]] =
                                          !widget.viewModel.isSelectedWeekDay[
                                              widget.viewModel
                                                  .weekdayToEng[weekday]];
                                      print(widget.viewModel.isSelectedWeekDay);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(40, 40),
                                    minimumSize: Size(40, 40),
                                    padding: EdgeInsets.only(right: 0),
                                    shape: const CircleBorder(),
                                    primary: widget.viewModel.isSelectedWeekDay[
                                                widget.viewModel
                                                    .weekdayToEng[weekday]] ==
                                            false
                                        ? Color(0xFFF2F3F7)
                                        : Color(0xFF3F51B5),
                                    elevation: 0,
                                    side: BorderSide(
                                      color: Color(0xFFD1D9E6),
                                      width: widget.viewModel.isSelectedWeekDay[
                                                  widget.viewModel
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
                      Text("운동 시간대",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff6E7995))),
                      SizedBox(height: 12),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: widget.viewModel.timeToInt.keys
                              .map(
                                (item) => ElevatedButton(
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: widget.viewModel.selectedTime !=
                                              widget.viewModel.timeToInt[item]
                                          ? Color(0xFF6E7995)
                                          : Color(0xFFffffff),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      widget.viewModel.selectedTime =
                                          widget.viewModel.timeToInt[item]!;

                                      print(widget.viewModel.selectedTime);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(40, 40),
                                    minimumSize: Size(40, 40),
                                    padding: EdgeInsets.only(right: 0),
                                    shape: const CircleBorder(),
                                    primary: widget.viewModel.selectedTime !=
                                            widget.viewModel.timeToInt[item]
                                        ? Color(0xFFF2F3F7)
                                        : Color(0xFF3F51B5),
                                    elevation: 0,
                                    side: BorderSide(
                                      color: Color(0xFFD1D9E6),
                                      width: widget.viewModel.selectedTime !=
                                              widget.viewModel.timeToInt[item]
                                          ? 1
                                          : 0,
                                    ),
                                  ),
                                ),
                              )
                              .toList()),
                      SizedBox(height: 30,),
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
