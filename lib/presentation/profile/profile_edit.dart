import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fitmate/presentation/search_center/search_center.dart';
import 'package:flutter_svg/svg.dart';

import 'component/profile_edit_view_model.dart';
import 'component/appBar.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/presentation/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/util.dart';
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
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: barWidget.nextBackAppBar(
            context,
            viewModel,
          ),
          backgroundColor: const Color(0xffF2F3F7),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
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
                          padding: const EdgeInsets.fromLTRB(20, 0, 10, 4),
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    log(IdToken.toString());
    final Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xff22232A),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
            ),
          ),
          elevation: 0.0,
          shape: Border(
            bottom: BorderSide(
              color: Color(0xFF3D3D3D),
              width: 1,
            ),
          ),
          backgroundColor: Color(0xFF22232A),
          title: Transform(
            transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
            child: Text(
              "프로필 수정",
              style: TextStyle(
                color: Color(0xFFffffff),
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                nickname == "" ||
                        (isSelectedTime[0] == false &&
                            isSelectedTime[1] == false &&
                            isSelectedTime[2] == false)
                    ? FlutterToastBottom("상세 설명 외의 모든 항목을 입력하여주세요")
                    : PatchPosets();
              },
              child: Text(
                '저장',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: nickname == "" ||
                          (isSelectedTime[0] == false &&
                              isSelectedTime[1] == false &&
                              isSelectedTime[2] == false)
                      ? Color(0xFF878E97)
                      : Color(0xFF2975CF),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            width: size.width - 50,
            margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    _openImagePicker();
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      _image == null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.network(
                                '${UserData['user_profile_img']}',
                                width: 85.0,
                                height: 85.0,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.file(
                                _image!,
                                width: 85.0,
                                height: 85.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                      Container(
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.photo_camera,
                          size: 20,
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xFF878E97),
                            border: Border.all(
                              color: Color(0xFF878E97),
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    shape: CircleBorder(),
                    fixedSize: const Size(85, 85),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.0),
                      child: Text(
                        '닉네임',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width - 50,
                      height: 45,
                      child: TextField(
                        onChanged: (value) {
                          nickname = value;
                        },
                        style: TextStyle(color: Color(0xffFFFFFF)),
                        decoration: InputDecoration(
                          hintText: '닉네임',
                          contentPadding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                          hintStyle: TextStyle(
                            color: Color(0xff878E97),
                          ),
                          labelStyle: TextStyle(color: Color(0xff878E97)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                            borderSide:
                                BorderSide(width: 1, color: Color(0xff878E97)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                            borderSide:
                                BorderSide(width: 1, color: Color(0xff878E97)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '운동 루틴',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16.0),
                        ),
                        Container(
                          width: 150,
                          height: 25,
                          margin: EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Color(0xFF878E97),
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                          ),
                          child: Center(
                            child: ToggleButtons(
                              color: Color(0xFF878E97),
                              selectedColor: Color(0xFFffffff),
                              //selectedBorderColor: Color(0xFF6200EE),
                              fillColor: Color(0xFF22232A).withOpacity(0.08),
                              splashColor: Color(0xFF22232A).withOpacity(0.12),
                              //hoverColor: Color(0xFF6200EE).withOpacity(0.04),
                              borderColor: Color(0xFF22232A),
                              borderRadius: BorderRadius.circular(4.0),
                              renderBorder: false,
                              constraints: BoxConstraints(minHeight: 36.0),
                              isSelected: isSelectedTime,
                              onPressed: (index) {
                                // Respond to button selection
                                setState(() {
                                  if (isSelectedTime[index]) {
                                  } else if (!isSelectedTime[0] &
                                      !isSelectedTime[1] &
                                      !isSelectedTime[2]) {
                                    isSelectedTime[index] =
                                        !isSelectedTime[index];
                                  } else {
                                    isSelectedTime[index] =
                                        !isSelectedTime[index];
                                    if (index == 0) {
                                      isSelectedTime[1] = false;
                                      isSelectedTime[2] = false;
                                    } else if (index == 1) {
                                      isSelectedTime[0] = false;
                                      isSelectedTime[2] = false;
                                    } else if (index == 2) {
                                      isSelectedTime[1] = false;
                                      isSelectedTime[0] = false;
                                    }
                                  }
                                  print(isSelectedTime);
                                });
                              },
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    '오전',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelectedTime[0] == true
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    '오후',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelectedTime[1] == true
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    '저녁',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelectedTime[2] == true
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '월',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["mon"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["mon"] =
                                !isSelectedWeekDay["mon"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(40, 40),
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.all(0),
                          shape: CircleBorder(),
                          primary: isSelectedWeekDay["mon"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["mon"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '화',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["tue"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["tue"] =
                                !isSelectedWeekDay["tue"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.all(0),
                          fixedSize: Size(40, 40),
                          shape: CircleBorder(),
                          primary: isSelectedWeekDay["tue"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["tue"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '수',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["wed"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["wed"] =
                                !isSelectedWeekDay["wed"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.all(0),
                          fixedSize: Size(40, 40),
                          shape: CircleBorder(),
                          primary: isSelectedWeekDay["wed"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["wed"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '목',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["thu"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["thu"] =
                                !isSelectedWeekDay["thu"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.all(0),
                          fixedSize: const Size(40, 40),
                          shape: const CircleBorder(),
                          primary: isSelectedWeekDay["thu"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["thu"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '금',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["fri"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["fri"] =
                                !isSelectedWeekDay["fri"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.all(0),
                          fixedSize: const Size(40, 40),
                          shape: const CircleBorder(),
                          primary: isSelectedWeekDay["fri"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["fri"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '토',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["sat"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["sat"] =
                                !isSelectedWeekDay["sat"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.all(0),
                          fixedSize: const Size(40, 40),
                          shape: const CircleBorder(),
                          primary: isSelectedWeekDay["sat"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["sat"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '일',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["sun"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["sun"] =
                                !isSelectedWeekDay["sun"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.all(0),
                          fixedSize: const Size(40, 40),
                          shape: const CircleBorder(),
                          primary: isSelectedWeekDay["sun"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["sun"] == false ? 1 : 0,
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
    );
  }
  */
}
