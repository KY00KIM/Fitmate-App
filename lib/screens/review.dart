/*
//import 'dart:html' as http;
import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/screens/writeCenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../utils/data.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late List reviewData;
  String description = "";

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.parse('https://fitmate.co.kr/v1/reviews/candidates'),
        headers: {'Authorization' : '$IdToken', 'Content-Type': 'application/json; charset=UTF-8'});
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));

    if(resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();
      
      http.Response response = await http.get(Uri.parse("https://fitmate.co.kr/v1/reviews/candidates"),
          headers: {'Authorization' : '$IdToken', 'Content-Type': 'application/json; charset=UTF-8',},
      );
      var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    if(response.statusCode != 200) {
      FlutterToastTop("알수 없는 에러가 발생하였습니다");
    } else {
      this.setState(() {
        reviewData = resBody["data"];
      });
    }
    return "success";
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
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
              "리뷰 작성",
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
                print(_selectedDate);
                print(_selectedTime);
                print(centerName);
                
                centerName == '만날 피트니스장을 선택해주세요' || _selectedDate == '날짜 선택' || _selectedTime == '시간 선택'  ?
                    FlutterToastBottom("상세 설명 외의 모든 항목을 입력하여주세요")
                        : null;
                        
              },
              child: Text(
                '완료',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: centerName == '만날 피트니스장을 선택해주세요' || _selectedDate == '날짜 선택' || _selectedTime == '시간 선택' ? Color(0xFF878E97) : Color(0xFF2975CF),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    ' 이번 매칭이 어떠셨나요?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    itemCount: reviewData == null ? 0 : reviewData.length,
                    itemBuilder: (BuildContext context, int idx) {
                      return ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WriteCenterPage()),
                          ).then((onValue) {
                            print(onValue);
                            onValue == null ? null : setState(() {
                              centerName = onValue['place_name'];
                            });
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(size.width, 45),
                          primary: Color(0xFF22232A),
                          alignment: Alignment.centerLeft,
                          side: BorderSide(
                            width: 1.0,
                            color: Color(0xFF878E97),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: Color(0xFF878E97),
                              size: 17,
                            ),
                            Text(
                              ' $centerName',
                              style: TextStyle(
                                color: Color(0xFF878E97),
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    ' 후기를 남겨주세요!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: size.width,
                    child: TextField(
                      onChanged: (value) {
                        description = value;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 15,
                      minLines: 1,
                      style: TextStyle(
                        color: Color(0xff878E97),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        hintText: '여기에 적어주세요.(선택사항)',
                        contentPadding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                        hintStyle: TextStyle(
                          color: Color(0xff878E97),
                          fontSize: 14,
                        ),
                        labelStyle: TextStyle(color: Color(0xff878E97)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          borderSide:
                              BorderSide(width: 1, color: Color(0xff878E97)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          borderSide:
                              BorderSide(width: 1, color: Color(0xff878E97)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        ),
                      ),
                    ),
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
*/