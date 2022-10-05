import 'package:fitmate/presentation/search_center/search_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
as inset;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'component/signup-view-model.dart';
import 'component/appBar.dart';

import '../home/home.dart';

class SignupPage3 extends StatefulWidget {
  late signUpViewModel viewModel;
  SignupPage3({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<SignupPage3> createState() => _SignupPageState3();
}

class _SignupPageState3 extends State<SignupPage3> {
  final barWidget = BarWidget();

  bool checkValid() {
    if (widget.viewModel.Survey.length == 0) {
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
        appBar: barWidget.nextBackAppBar(context, HomePage(reload: true), 3,
            checkValid, widget.viewModel, widget.viewModel.sendSignUp),
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
                      '관심사를 선택해 주세요',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(
                      height: 21,
                    ),
                    ListView.builder(
                      //scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.viewModel.SurveyKorList.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          String content = widget.viewModel.SurveyKorList[index];
                          return Container(
                            width: size.width - 40,
                            height: 60,
                            padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                            child: ElevatedButton(
                              child: Text(
                                content,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: widget.viewModel.isSelectedSurveyKor[
                                  widget.viewModel
                                      .SurveyKorId[content]] == false ? Color(0xFF6E7995)
                                      : Color(0xFFffffff),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if(widget.viewModel.isSelectedSurveyKor[widget
                                      .viewModel
                                      .SurveyKorId[content]] == true) {
                                    widget.viewModel.isSelectedSurveyKor[widget
                                        .viewModel
                                        .SurveyKorId[content]] = false;
                                    widget.viewModel.Survey.remove(widget
                                        .viewModel
                                        .SurveyKorId[content]);
                                  } else {
                                    widget.viewModel.isSelectedSurveyKor[widget
                                        .viewModel
                                        .SurveyKorId[content]] = true;
                                    widget.viewModel.Survey.add(widget
                                        .viewModel
                                        .SurveyKorId[content]);
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(40, 40),
                                minimumSize: Size(size.width - 40, 60),
                                maximumSize: Size(size.width - 40, 60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8), // <-- Radius
                                ),
                                primary: widget.viewModel.isSelectedSurveyKor[
                                widget.viewModel
                                    .SurveyKorId[content]] ==
                                    false
                                    ? Color(0xFFF2F3F7)
                                    : Color(0xFF3F51B5),
                                elevation: 0,
                                side: BorderSide(
                                  color: Color(0xFFD1D9E6),
                                  width: widget.viewModel.isSelectedSurveyKor[
                                  widget.viewModel
                                      .SurveyKorId[content]] ==
                                      false
                                      ? 1
                                      : 0,
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                    SizedBox(
                      height: 30,
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
