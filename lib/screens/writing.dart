import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class WritingPage extends StatefulWidget {
  const WritingPage({Key? key}) : super(key: key);

  @override
  State<WritingPage> createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  String _selectedTime = '시간 선택';
  String _selectedDate = '날짜 선택';
  String _selectedpart = '운동 부위';

  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];

  Future<void> _pickImg() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if(images != null) {
      setState(() {
        _pickedImgs = images;
      });
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
              onPressed: () {},
              child: Text(
                '완료',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
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
                      _pickImg();
                      print(_pickedImgs[0].path);
                    },
                    style: ElevatedButton.styleFrom(
                      //minimumSize: Size(65, 65),
                      minimumSize:
                          Size(size.height * 0.09, size.height * 0.09),
                      primary: Color(0xFF878E97)
                    ),
                    child: Icon(
                      Icons.photo_camera,
                      size: 30.0,
                    ),
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
                          style: TextStyle(color: Color(0xff878E97)),
                          decoration: InputDecoration(
                            hintText: '운동 내용을 요약해서 적어주세요.',
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
                    onPressed: () {},
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
                          ' 만날 피트니스장을 선택해주세요.',
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
