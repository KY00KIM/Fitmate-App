import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/presentation/post/post.dart';
import 'package:fitmate/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../domain/util.dart';
import '../../ui/bar_widget.dart';
import '../../ui/show_toast.dart';

import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

import '../search_center/search_center.dart';

/*
class WritingPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'example',
      theme: ThemeData(primarySwatch: Colors.blue),
//      home: DateTesting(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Holo Datepicker Example'),
        ),
        body: MyHomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            child: Text("open picker dialog"),
            onPressed: () async {
              var datePicked = await DatePicker.showSimpleDatePicker(
                context,
                initialDate: DateTime(1994),
                firstDate: DateTime(1960),
                lastDate: DateTime(2012),
                dateFormat: "yyyy-MM-dd",
                locale: DateTimePickerLocale.ko,
                looping: true,
              );

              final snackBar =
              SnackBar(content: Text("Date Picked $datePicked"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          ElevatedButton(
            child: Text("Show picker widget"),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => WidgetPage()));
            },
          )
        ],
      ),
    );
  }
}

class WidgetPage extends StatefulWidget {
  @override
  _WidgetPageState createState() => _WidgetPageState();
}

class _WidgetPageState extends State<WidgetPage> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.grey[900]!,
                  Colors.black,
                ],
                stops: const [0.7, 1.0],
              )),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                    ],
                  ),
                ),
                Text("${_selectedDate ?? ''}"),
              ],
            ),
          ),
        ),
      ),
    );
    //var locale = "zh";
    // return SafeArea(
    //   child: Scaffold(
    //     body: Center(
    //       child: DatePickerWidget(
    //         locale: //locale == 'zh'
    //             DateTimePickerLocale.zh_cn
    //             //  DateTimePickerLocale.en_us
    //         ,
    //         lastDate: DateTime.now(),
    //         // dateFormat: "yyyy : MMM : dd",
    //         // dateFormat: 'yyyy MMMM dd',
    //         onChange: (DateTime newDate, _) {
    //           setState(() {
    //             var dob = newDate.toString();
    //             print(dob);
    //           });
    //         },
    //         pickerTheme: DateTimePickerTheme(
    //           backgroundColor: Colors.transparent,
    //           dividerColor: const Color(0xffe3e3e3),
    //           itemTextStyle: TextStyle(
    //             fontFamily: 'NotoSansTC',
    //             fontSize: 18,
    //             fontWeight: FontWeight.w500,
    //             color: Theme.of(context).primaryColor,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

 */

class WritingPage extends StatefulWidget {
  const WritingPage({Key? key}) : super(key: key);

  @override
  State<WritingPage> createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  String _selectedTime = '시간 선택';
  String _selectedDate = '날짜 선택';
  late Map center;
  String centerName = '피트니스 클럽 검색';
  String title = "";
  String description = "";
  String postId = "";

  final barWidget = BarWidget();

  File? _image;
  bool flag = false;

  final _picker = ImagePicker();

  List<CompanyWidget> _companies = <CompanyWidget>[
    CompanyWidget('등'),
    CompanyWidget('가슴'),
    CompanyWidget('어깨'),
    CompanyWidget('하체'),
    CompanyWidget('이두'),
    CompanyWidget('삼두'),
    CompanyWidget('복근'),
    CompanyWidget('유산소'),
  ];
  List<String> _filters = <String>[];

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

  String fitnessPartGetKey(String s) {
    String keyId = '';
    fitnessPart.forEach((key, value) {
      if (value == s) keyId = key;
    });
    return keyId;
  }

  String selectTime(int i) {
    int temp = i ~/ 10;
    if (temp == 0)
      return '0${i}';
    else
      return '${i}';
  }

  void PostPosets() async {
    if (false == false) {
      List<int> imageBytes = _image!.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      List _selectedPartData = [];
      log(IdToken);

      _filters.forEach((element) {
        _selectedPartData.add(fitnessPartConverse[element].toString());
      });

      Map data = {
        "user_id": "${UserId}",
        "location_id": "${UserData["location_id"]}",
        "post_fitness_part": _selectedPartData,
        "post_title": "$title",
        "promise_location": {
          "center_name": "$centerName",
          "center_address": "${center['address_name']}",
          "center_longitude": center['y'],
          "center_latitude": center['x']
        },
        "promise_date": "${_selectedDate}T${_selectedTime}:00",
        "post_img": "",
        "post_main_text": "$description"
      };
      print(data);

      var body = json.encode(data);

      http.Response response = await http.post(Uri.parse("${baseUrlV1}posts/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'bearer $IdToken',
          }, // this header is essential to send json data
          body: body);
      var resBody = jsonDecode(utf8.decode(response.bodyBytes));
      print('resBody : ${resBody}');

      if (response.statusCode == 201) {
        postId = resBody["data"]["_id"].toString();

        // ignore: unused_local_variable
        var request = http.MultipartRequest(
            'POST', Uri.parse("${baseUrlV1}posts/image/$postId"));
        request.headers
            .addAll({"Authorization": "bearer $IdToken", "postId": "$postId"});
        request.files
            .add(await http.MultipartFile.fromPath('image', _image!.path));
        var res = await request.send();
        print('$postId');
        log(IdToken);
        //print(res.statusCode);
        flag = false;
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                PostPage(reload: true),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      } else if (resBody["error"]["code"] == "auth/id-token-expired") {
        flag = false;
        IdToken =
            (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
                .token
                .toString();
        FlutterToastBottom("오류가 발생했습니다. 한번 더 시도해 주세요");
      } else {
        flag = false;
        FlutterToastBottom("오류가 발생하였습니다");
      }
    }
  }

  Iterable<Widget> get companyPosition sync* {
    for (CompanyWidget company in _companies) {
      yield Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 16.0, 0),
        child: Theme(
          data: ThemeData(brightness: Brightness.dark), //
          child: FilterChip(
            shape: StadiumBorder(
              side: BorderSide(
                  color: _filters.contains(company.name) == true
                      ? Color(0xFF3F51B5)
                      : Color(0xFFD1D9E6)),
            ),
            backgroundColor: whiteTheme,
            //avatar: CircleAvatar(
            //  backgroundColor: Colors.cyan,
            //  child: Text(company.name[0].toUpperCase(),style: TextStyle(color: Colors.white),),
            //),
            label: Text(
              company.name,
              style: TextStyle(
                  color: _filters.contains(company.name) == true
                      ? Color(0xffFFFFFF)
                      : Color(0xFF6E7995)),
            ),
            selected: _filters.contains(company.name),
            selectedColor: Color(0xFF3F51B5),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  _filters.add(company.name);
                } else {
                  _filters.removeWhere((String name) {
                    return name == company.name;
                  });
                }
                print(_filters);
              });
            },
          ),
        ),
      );
    }
  }

  void showDatePicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                /*
              if (value != null && value != _selectedDate)
                setState(() {
                  _selectedDate = value as String;
                });

               */
              },
              initialDateTime: DateTime.now(),
              minimumYear: 2019,
              maximumYear: 2021,
            ),
          );
        });
  }

  final initDate = DateFormat('yyyy-MM-dd')
      .parse(DateTime.now().toString().substring(0, 10));

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () {
          //FocusManager.instance.primaryFocus?.unfocus();
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: whiteTheme,
          appBar: barWidget.writingAppBar(context),
          /*
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
                "매칭 글등록",
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
                  _image == null ||
                          title == "" ||
                          centerName == '만날 피트니스장을 선택해주세요' ||
                          _selectedDate == '날짜 선택' ||
                          _selectedTime == '시간 선택'
                      ? FlutterToastBottom("상세 설명 외의 모든 항목을 입력하여주세요")
                      : PostPosets();
                },
                child: Text(
                  '완료',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: _image == null ||
                            title == "" ||
                            centerName == '만날 피트니스장을 선택해주세요' ||
                            _selectedDate == '날짜 선택' ||
                            _selectedTime == '시간 선택'
                        ? Color(0xFF878E97)
                        : Color(0xFF2975CF),
                  ),
                ),
              ),
            ],
          ),
           */
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '게시판 등록',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6E7995),
                        fontSize: 24.0,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      '제목',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6E7995),
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1.0,
                          color: Color(0xFFffffff),
                        ),
                        color: Color(0xFFEFEFEF),
                      ),
                      child: TextField(
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: "제목을 입력..",
                          fillColor: whiteTheme,
                          filled: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.5,
                    ),
                    Text(
                      '내용',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6E7995),
                        fontSize: 16.0,
                      ),
                    ),
                    Container(
                      width: size.width,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            description = value;
                          });
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: 105,
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
                    Container(
                      width: size.width - 40,
                      height: 72,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            title = value;
                          });
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
                        minimumSize:
                            Size(size.height * 0.09, size.height * 0.09),
                        maximumSize:
                            Size(size.height * 0.09, size.height * 0.09),
                        //primary: _image == null ? Color(0xFF878E97) : Color(0xFF22232A),
                        primary: Color(0xFFF2F3F7),
                        padding: EdgeInsets.all(0),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                      ),
                      child: _image == null
                          ? SvgPicture.asset(
                              "assets/icon/bar_icons/plus_icon.svg",
                              width: 16,
                              height: 16,
                            )
                          : Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '피트니스 클럽',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6E7995),
                          fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchCenterPage()),
                        ).then((onValue) {
                          print(onValue);
                          onValue == null
                              ? null
                              : setState(() {
                                  center = onValue;
                                  centerName = center['place_name'];
                                });
                        });
                      },
                      child: Container(
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
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  strutStyle: StrutStyle(fontSize: 16),
                                  text: TextSpan(
                                    text: '${centerName}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: centerName == "피트니스 클럽 검색"
                                          ? Color(0xFFD1D9E6)
                                          : Color(0xFF000000),
                                    ),
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                "assets/icon/search_outline_icon.svg",
                                width: 16,
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '매칭 날짜',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6E7995),
                          fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        /*
                        Future<DateTime?> future = showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2030),
                        );

                        future.then((date) {
                          setState(() {
                            _selectedDate = '${date.toString().substring(0, 4)}년 ${date.toString().substring(5, 7)}월 ${date.toString().substring(8, 10)}일';
                          });
                        });

                         */
                        //showDatePicker();

                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            shape: const RoundedRectangleBorder(
                              // <-- SEE HERE
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(40.0),
                              ),
                            ),
                            backgroundColor: Color(0xFFF2F3F7),
                            builder: (BuildContext context) {
                              return Wrap(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(height: 20,),
                                      Container(
                                        width: 40,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(2.0),
                                          color: Color(0xFFD1D9E6),
                                        ),
                                      ),
                                      SizedBox(height: 36,),
                                      Container(
                                        height: 400,
                                        child: DatePickerWidget(
                                          firstDate: DateTime.now(),
                                          //DateTime(1960),
                                          looping: true,
                                          //  lastDate: DateTime(2002, 1, 1),
                                          //              initialDate: DateTime.now(),// DateTime(1994),
                                          dateFormat: "yyyy-MM-dd",
                                          locale: DatePicker.localeFromString('ko'),
                                          onChange: (DateTime newDate, _) {
                                            setState(() {
                                              _selectedDate = newDate as String;
                                            });
                                            print(_selectedDate);
                                          },
                                          pickerTheme: DateTimePickerTheme(
                                            backgroundColor: Colors.transparent,
                                            itemTextStyle: TextStyle(
                                              color: Color(0xFF000000),
                                              fontSize: 14,
                                            ),
                                            dividerColor: Color(0xFFE2E8F0),
                                            titleHeight: 52,
                                            itemHeight: 52,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            });
                      },
                      child: Container(
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
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  strutStyle: StrutStyle(fontSize: 16),
                                  text: TextSpan(
                                    text: '${_selectedDate}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _selectedDate == '날짜 선택'
                                          ? Color(0xFFD1D9E6)
                                          : Color(0xFF000000),
                                    ),
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                "assets/icon/calendar_outline_icon.svg",
                                width: 16,
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '매칭 시간',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6E7995),
                          fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        Future<TimeOfDay?> future = showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        future.then((timeOfDay) {
                          setState(() {
                            if (timeOfDay != null) {
                              _selectedTime =
                                  '${selectTime(timeOfDay.hour)}시 ${selectTime(timeOfDay.minute)}분';
                            }
                            print('$_selectedTime');
                          });
                        });
                      },
                      child: Container(
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
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  strutStyle: StrutStyle(fontSize: 16),
                                  text: TextSpan(
                                    text: '${_selectedTime}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _selectedTime == '시간 선택'
                                          ? Color(0xFFD1D9E6)
                                          : Color(0xFF000000),
                                    ),
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                "assets/icon/time_outline_icon.svg",
                                width: 16,
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '운동 부위 선택',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6E7995),
                          fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      children: companyPosition.toList(),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    /*
                    SizedBox(
                      height: 300,
                      child: CupertinoDatePicker(
                        minimumYear: DateTime.now().year,
                        maximumYear: DateTime.now().year + 10,
                        initialDateTime: initDate,
                        maximumDate: DateTime.now(),
                        onDateTimeChanged: (value) {},
                        mode: CupertinoDatePickerMode.date,
                      ),
                    ),

                     */
                    Container(
                      height: 400,
                      child: DatePickerWidget(
                        firstDate: DateTime.now(),
                        //DateTime(1960),
                        looping: true,
                        //  lastDate: DateTime(2002, 1, 1),
                        //              initialDate: DateTime.now(),// DateTime(1994),
                        dateFormat: "yyyy-MM-dd",
                        locale: DatePicker.localeFromString('ko'),
                        onChange: (DateTime newDate, _) {
                          setState(() {
                            _selectedDate = newDate as String;
                          });
                          print(_selectedDate);
                        },
                        pickerTheme: DateTimePickerTheme(
                          backgroundColor: Colors.transparent,
                          itemTextStyle: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 14,
                          ),
                          dividerColor: Color(0xFFE2E8F0),
                          titleHeight: 52,
                          itemHeight: 52,
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
    );
  }
}

class CompanyWidget {
  const CompanyWidget(this.name);

  final String name;
}
