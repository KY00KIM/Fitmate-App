//import 'dart:html' as http;
import 'dart:convert';
//import 'dart:math';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/main.dart';
import 'package:fitmate/screens/writeCenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../utils/data.dart';
import 'home.dart';

class WritingPage extends StatefulWidget {
  const WritingPage({Key? key}) : super(key: key);

  @override
  State<WritingPage> createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  String _selectedTime = '시간 선택';
  String _selectedDate = '날짜 선택';
  String _selectedpart = '부위';
  late Map center;
  String centerName = '만날 피트니스장을 선택해주세요';
  String title = "";
  String description = "";
  String postId = "";

  File? _image;

  final _picker = ImagePicker();

  // Implementing the image picker
  Future<void> _openImagePicker() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        print(_image);
      });
    }
  }

  String fitnessPartGetKey(String s) {
    String keyId = '';
    fitnessPart.forEach((key, value) {
      if (value == s) keyId = key;
    });
    return keyId;
  }

  String selectTime(int i) {
    int temp = i ~/ 10;
    if (temp == 0) return '0${i}';
    else return '${i}';
  }

  void PostPosets() async {
    List<int> imageBytes = _image!.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    List textPart = ["${fitnessPartGetKey(_selectedpart)}"];
    Map data = {
      "user_id" : "$UserId",
      "location_id" : "${UserData["location_id"]}",
      "post_fitness_part" : textPart,
      "post_title" : "$title",
      "promise_location": {
        "center_name": "$centerName",
        "center_address": "${center['address_name']}",
        "center_longitude": center['y'],
        "center_latitude": center['x']
      },
      "promise_date" : "${_selectedDate}T${_selectedTime}:00",
      "post_img" : "",
      "post_main_text" : "$description"
    };
    print(data);
    var body = json.encode(data);

    http.Response response = await http.post(Uri.parse("${baseUrl}posts/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'bearer $IdToken',
      }, // this header is essential to send json data
      body: body
    );
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    print(resBody);

    if(response.statusCode == 201) {
      postId = resBody["data"]["_id"].toString();

      // ignore: unused_local_variable
      var request = http.MultipartRequest('POST', Uri.parse("${baseUrl}posts/image/$postId"));
      request.headers.addAll({"Authorization" : "bearer $IdToken", "postId" : "$postId"});
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
      var res = await request.send();
      print('$postId');
      log(IdToken);
      print(res.statusCode);
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => HomePage(reload : true),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else if (resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();
      FlutterToastBottom("오류가 발생했습니다. 한번 더 시도해 주세요");
    } else {
      FlutterToastBottom("오류가 발생하였습니다");
    }

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
              "매칭 글쓰기",
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
                _image == null || title == "" || _selectedpart == '부위' || centerName == '만날 피트니스장을 선택해주세요' || _selectedDate == '날짜 선택' || _selectedTime == '시간 선택'  ?
                    FlutterToastBottom("상세 설명 외의 모든 항목을 입력하여주세요")
                        : PostPosets();
              },
              child: Text(
                '완료',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: _image == null || title == "" || _selectedpart == '부위' || centerName == '만날 피트니스장을 선택해주세요' || _selectedDate == '날짜 선택' || _selectedTime == '시간 선택' ? Color(0xFF878E97) : Color(0xFF2975CF),
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
                  Text(
                    ' 사진',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _openImagePicker();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      //minimumSize: Size(65, 65),
                      minimumSize: Size(size.height * 0.09, size.height * 0.09),
                      maximumSize: Size(size.height * 0.09, size.height * 0.09),
                      //primary: _image == null ? Color(0xFF878E97) : Color(0xFF22232A),
                      primary: Color(0xFF878E97),
                      padding: EdgeInsets.all(0),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                    ),
                    child: _image == null ? Icon(
                      Icons.photo_camera,
                      size: 30.0,
                    ) : Image.file(_image!, width: 100, height: 100, fit: BoxFit.cover,),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    ' 제목',
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
                      SizedBox(
                        width: size.width - 160,
                        height: 45,
                        child: TextField(
                          onChanged: (value) {
                            title = value;
                          },
                          style: TextStyle(color: Color(0xFF878E97)),
                          decoration: InputDecoration(
                            hintText: '운동 내용을 요약해서 적어주세요',
                            contentPadding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                            hintStyle: TextStyle(
                              color: Color(0xff878E97),
                              fontSize: 14,
                            ),
                            labelStyle: TextStyle(color: Color(0xff878E97)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                              borderSide: BorderSide(
                                  width: 1, color: Color(0xff878E97)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                              borderSide: BorderSide(
                                  width: 1, color: Color(0xff878E97)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Color(0xFF22232A),
                                title: Text(
                                  '운동 부위',
                                  style: TextStyle(
                                    color: Color(0xFFffffff),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedpart = '등';
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          '등',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF22232A),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedpart = '가슴';
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          '가슴',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF22232A),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedpart = '어깨';
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          '어깨',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF22232A),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedpart = '하체';
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          '하체',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF22232A),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedpart = '이두';
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          '이두',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF22232A),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedpart = '삼두';
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          '삼두',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF22232A),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedpart = '엉덩이';
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          '엉덩이',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF22232A),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedpart = '복근';
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          '복근',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF22232A),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedpart = '유산소';
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          '유산소',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF22232A),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedpart = '기타';
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          '기타',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF22232A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(110, 45),
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
                              Icons.fitness_center,
                              color: Color(0xFF878E97),
                              size: 17,
                            ),
                            Text(
                              ' $_selectedpart',
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
                          center = onValue;
                          centerName = center['place_name'];
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
                          ' ${centerName}',
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    '${selectTime(timeOfDay.hour)}:${selectTime(timeOfDay.minute)}';
                              }
                              print('$_selectedTime');
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
                  Text(
                    ' 상세 설명',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 10,
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
                        hintText: '예) 어떤 운동을 할꺼다, 자세 피드백을 해주겠다 등',
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
