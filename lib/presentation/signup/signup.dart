import 'dart:convert';
import 'dart:developer';

import 'package:fitmate/presentation/signup/signup2.dart';
import 'component/signup-view-model.dart';
import 'component/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;
import '../../domain/util.dart';
import '../../ui/show_toast.dart';
import '../home/home.dart';

class SignupPage1 extends StatefulWidget {
  SignupPage1({Key? key, required this.user_object}) : super(key: key);
  Map user_object;

  @override
  State<SignupPage1> createState() => _SignupPageState1();
}

class _SignupPageState1 extends State<SignupPage1> {
  final barWidget = BarWidget();
  final viewModel = signUpViewModel();

  bool checkValid() {
    if (viewModel.isNicknameValid == true) {
      return true;
    }
    return false;
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
              SignupPage2(
                viewModel: viewModel,
              ),
              checkValid,
              null,
              null),
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
                      Text("계정",
                          style: TextStyle(
                              color: Color(0xff6E7995),
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 12.5),
                      Container(
                        height: 52,
                        decoration: inset.BoxDecoration(
                          color: const Color(0xffd1d9e6),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              width: 1.0, color: const Color(0xffffffff)),
                          boxShadow: const [
                            inset.BoxShadow(
                              offset: Offset(-20, -20),
                              blurRadius: 60,
                              color: Color.fromARGB(255, 192, 200, 212),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("소셜 로그인",
                                  style: TextStyle(
                                    color: Color(0xff6E7995),
                                    fontSize: 15,
                                  )),
                              Text(
                                  "${viewModel.socialProvider[(widget.user_object['firebase']['sign_in_provider'])]}",
                                  style: TextStyle(
                                    color: Color(0xff6E7995),
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 23.5,
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
                                    hintText: '닉네임',
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
                              hintText: "꾸준히 성장하는 헬린이입니다!",
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
}
