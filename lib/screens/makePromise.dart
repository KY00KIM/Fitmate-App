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

class MakePromisePage extends StatefulWidget {
  const MakePromisePage({Key? key}) : super(key: key);

  @override
  State<MakePromisePage> createState() => _MakePromisePageState();
}

class _MakePromisePageState extends State<MakePromisePage> {
  String _selectedTime = '시간 선택';
  String _selectedDate = '날짜 선택';
  String centerName = '만날 피트니스장을 선택해주세요';

  /*
  void PostPosets() async {
    /*
    Map data = {
      "user_id" : "$UserId",
      "location_id" : "${UserData["data"]["location_id"]}",
      "post_fitness_part" : [
      ],
      "post_title" : "$title",
      "promise_location" : "",
      "promise_date" : "$_selectedDate",
      "post_img" : "",
      "post_main_text" : "$description"
    };
    */
    var body = json.encode(data);

    http.Response response = await http.post(Uri.parse("https://fitmate.co.kr/v1/posts/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : '$IdToken',
      }, // this header is essential to send json data
      body: body
    );
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    print(resBody);

    print("idtoken : $IdToken");

    if(response.statusCode == 201) {

    } else if (resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();
      FlutterToastBottom("한번 더 시도해 주세요");
    } else {
      FlutterToastBottom("오류가 발생하였습니다");
    }
  }
  */
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
              "약속잡기",
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
                    height: 20,
                  ),
                  Text(
                    ' 헬스장 선택',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
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
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    ' 매칭 시간 선택',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Future<DateTime?> future = showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2030),
                          );

                          future.then((date) {
                            setState(() {
                              _selectedDate = date.toString().substring(0, 10);
                            });
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          //minimumSize: Size(171, 45),
                          minimumSize: Size(size.width * 0.434, 45),
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
                              Icons.calendar_today,
                              color: Color(0xFF878E97),
                              size: 17,
                            ),
                            Text(
                              '  $_selectedDate',
                              style: TextStyle(
                                color: Color(0xFF878E97),
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.03,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Future<TimeOfDay?> future = showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          future.then((timeOfDay) {
                            setState(() {
                              if (timeOfDay != null) {
                                _selectedTime =
                                    '${timeOfDay.hour}:${timeOfDay.minute}';
                              }
                            });
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(size.width * 0.434, 45),
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
                              Icons.schedule,
                              color: Color(0xFF878E97),
                              size: 18,
                            ),
                            Text(
                              '  $_selectedTime',
                              style: TextStyle(
                                color: Color(0xFF878E97),
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
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
