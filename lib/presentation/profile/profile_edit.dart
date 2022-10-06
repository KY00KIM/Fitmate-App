import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fitmate/presentation/search_center/search_center.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'component/profile_edit_view_model.dart';
import 'component/appBar.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../ui/show_toast.dart';
import 'package:http/http.dart' as http;

import 'dart:io';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  BarWidget barWidget = BarWidget();
  profileEditViewModel viewModel = profileEditViewModel();

  String nickname = '';
  Map isSelectedWeekDay = {
    "mon": false,
    "tue": false,
    "wed": false,
    "thu": false,
    "fri": false,
    "sat": false,
    "sun": false
  };
  final isSelectedTime = <bool>[false, false, false];
  String location = '동네 입력';
  String centerName = '센터 등록';
  late Map center;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  File? _image;

  final _picker = ImagePicker();

  // Implementing the image picker
  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        print(_image);
      });
    }
  }

  bool checkValid() {
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    viewModel.initModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //widget.idToken;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: LoaderOverlay(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: barWidget.nextBackAppBar(
              context,
              viewModel,
            ),
            backgroundColor: const Color(0xffF2F3F7),
            body: SafeArea(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '내 정보 수정',
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
                            '기본정보',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          ),
                          SizedBox(
                            height: 21,
                          ),
                          Text("닉네임",
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
                                  color: const Color.fromRGBO(
                                      0, 0, 0, 0.16), // shadow color
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
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  new Flexible(
                                    child: TextField(
                                      onChanged: (value) {
                                        viewModel.nickname = value;
                                      },
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Colors.transparent,
                                        filled: true,
                                        hintText: '${viewModel.nickname}',
                                        hintStyle: TextStyle(
                                          color: Color(0xffD1D9E6),
                                        ),
                                        labelStyle:
                                            TextStyle(color: Color(0xff878E97)),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      bool res = await viewModel
                                          .checkValidNickname(viewModel.nickname!);
                                      FlutterToastTop(
                                          res ? "사용 가능한 닉네임입니다" : "이미 사용중인 닉네임입니다");
                                      setState(() {
                                        if (res) {
                                          viewModel.isNicknameValid = true;
                                        }
                                      });
                                      FocusScope.of(context).unfocus();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(
                                            0xff3F51B5), // set the background color
                                        textStyle: TextStyle(
                                            fontSize: 12, color: Colors.white)),
                                    child: Text(
                                      "중복확인",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "성별",
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: ListTile(
                                      title: const Text(
                                        '남',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff6E7995)),
                                      ),
                                      leading: Radio<bool>(
                                        value: true,
                                        groupValue: viewModel.gender,
                                        onChanged: (bool? value) {
                                          print(
                                              "selectedSex is ${viewModel.gender}");
                                          setState(() {
                                            viewModel.gender = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: const Text(
                                      '여',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff6E7995)),
                                    ),
                                    leading: Radio<bool>(
                                      value: false,
                                      groupValue: viewModel.gender,
                                      onChanged: (bool? value) {
                                        print("selectedSex is ${viewModel.gender}");
                                        setState(() {
                                          viewModel.gender = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 150)
                              ]),
                          SizedBox(height: 33),
                          Text("한줄 소개 (선택)",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff6E7995))),
                          SizedBox(height: 12),
                          Container(
                            height: 130,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromRGBO(
                                      0, 0, 0, 0.16), // shadow color
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
                              padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                              child: TextField(
                                minLines: 1,
                                maxLines: 10,
                                decoration: InputDecoration(
                                  hintText: "${viewModel.introduce}",
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFFD1D9E6),
                                  ),
                                  border: InputBorder.none,
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    viewModel.introduce = text;
                                  });
                                },
                              ),
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
                                  color: const Color.fromRGBO(
                                      0, 0, 0, 0.16), // shadow color
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
                                //itemPadding: EdgeInsets.fromLTRB(30, 0, 30, 0),
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
                                  color: const Color.fromRGBO(
                                      0, 0, 0, 0.16), // shadow color
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
                                  color: const Color.fromRGBO(
                                      0, 0, 0, 0.16), // shadow color
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
                                            viewModel.center = onValue;
                                            viewModel.centerName =
                                                viewModel.center['center_name'];
                                            print("center : ${viewModel.center}");
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
                                            text: viewModel.centerName,
                                            style: TextStyle(
                                              color: viewModel.centerName ==
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
                            "운동 요일",
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
                          Text("운동 시간대",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff6E7995))),
                          SizedBox(height: 12),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: viewModel.timeToInt.keys
                                  .map(
                                    (item) => ElevatedButton(
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: viewModel.selectedTime !=
                                                  viewModel.timeToInt[item]
                                              ? Color(0xFF6E7995)
                                              : Color(0xFFffffff),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          viewModel.selectedTime =
                                              viewModel.timeToInt[item]!;

                                          print(viewModel.selectedTime);
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(40, 40),
                                        minimumSize: Size(40, 40),
                                        padding: EdgeInsets.only(right: 0),
                                        shape: const CircleBorder(),
                                        primary: viewModel.selectedTime !=
                                                viewModel.timeToInt[item]
                                            ? Color(0xFFF2F3F7)
                                            : Color(0xFF3F51B5),
                                        elevation: 0,
                                        side: BorderSide(
                                          color: Color(0xFFD1D9E6),
                                          width: viewModel.selectedTime !=
                                                  viewModel.timeToInt[item]
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
          ),
        ),
      ),
    );
  }
}
