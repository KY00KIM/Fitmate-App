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
import 'package:loader_overlay/loader_overlay.dart';

import '../../domain/util.dart';
import '../../ui/bar_widget.dart';
import '../../ui/show_toast.dart';

import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

import '../search_center/search_center.dart';

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
  late DateTime temp = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);

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
    context.loaderOverlay.show();
    print("췍췍;");

    List<int> imageBytes = _image!.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    List _selectedPartData = [];

    _filters.forEach((element) {
      _selectedPartData.add(fitnessPartConverse[element].toString());
    });

    Map data = {
      "user_id": "${UserId}",
      "location_id": "${UserData["location_id"]}",
      "post_fitness_part": _selectedPartData,
      "post_title": "$title",
      "promise_location_id": "${center['_id']}",
      "promise_date": "${temp}",
      "post_img": "",
      "post_main_text": "$description"
    };
    print(data);

    var body = json.encode(data);

    http.Response response = await http.post(Uri.parse("${baseUrlV2}posts/"),
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
          'POST', Uri.parse("${baseUrlV2}posts/image/$postId"));
      request.headers.addAll({"Authorization": "bearer $IdToken"});
      request.files
          .add(await http.MultipartFile.fromPath('image', _image!.path));
      var res = await request.send();
      context.loaderOverlay.hide();
      FlutterToastBottom("게시글이 등록되었습니다!");
      Navigator.pop(context);
    } else if (resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();
      context.loaderOverlay.hide();
      FlutterToastBottom("오류가 발생했습니다. 한번 더 시도해 주세요");
    } else {
      context.loaderOverlay.hide();
      FlutterToastBottom("오류가 발생하였습니다");
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

  bool checkValid() {
    if (title == '' ||
        description == '' ||
        _image == null ||
        centerName == '피트니스 클럽 검색' ||
        _selectedTime == '시간 선택' ||
        _selectedDate == '날짜 선택') {
      return false;
    }
    return true;
  }

  final initDate = DateFormat('yyyy-MM-dd')
      .parse(DateTime.now().toString().substring(0, 10));

  @override
  Widget build(BuildContext context) {
    print(DateFormat.jm().format(DateTime.now()));
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        //FocusManager.instance.primaryFocus?.unfocus();
        FocusScope.of(context).unfocus();
      },
      child: LoaderOverlay(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: whiteTheme,
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: whiteTheme,
            toolbarHeight: 60,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: whiteTheme,
            ),
            automaticallyImplyLeading: false,
            title: Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFFF2F3F7),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFffffff),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(-2, -2),
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(55, 84, 170, 0.1),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Theme(
                  data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icon/bar_icons/back_icon.svg",
                      width: 18,
                      height: 18,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 20, 8),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFFF2F3F7),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFffffff),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(-2, -2),
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(55, 84, 170, 0.1),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Theme(
                    data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: IconButton(
                      icon: checkValid()
                          ? SvgPicture.asset(
                        "assets/icon/bar_icons/write_check_icon.svg",
                        width: 18,
                        height: 18,
                      )
                          : SvgPicture.asset(
                        "assets/icon/bar_icons/non_color_check_icon.svg",
                        width: 18,
                        height: 18,
                      ),
                      onPressed: () {
                        if (checkValid()) {
                          PostPosets();
                        }
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
          body: SafeArea(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
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
                        //height: 52,
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
                          padding: const EdgeInsets.fromLTRB(20, 0, 10, 4),
                          child: TextField(
                            minLines: 1,
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: "제목을 입력..",
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFD1D9E6),
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (text){
                              setState(() {
                                title = text;
                              });
                            },
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
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        height: 200,
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
                          padding: const EdgeInsets.fromLTRB(20, 0, 10, 4),
                          child: TextField(
                            minLines: 1,
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: "내용을 입력..",
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFD1D9E6),
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (text) {
                              setState(() {
                                description = text;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xFFF2F3F7),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFffffff),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(-2, -2),
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(55, 84, 170, 0.1),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(2, 2),
                            ),
                          ],
                          image: _image == null ? null : DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(_image!.path)),
                          ),
                        ),
                        child: Theme(
                          data: ThemeData(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: IconButton(
                            icon: SvgPicture.asset(
                              "assets/icon/bar_icons/plus_icon.svg",
                              width: 16,
                              height: 16,
                              color: _image == null ? Color(0xFF000000) : Color(0xFFffffff),
                            ),
                            onPressed: () {
                              _openImagePicker();
                            },
                          ),
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
                              centerName = center['center_name'];
                              print("center : ${center}");
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
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(2.0),
                                              color: Color(0xFFD1D9E6),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 52,
                                          ),
                                          Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      '년',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFF000000)
                                                      ),
                                                    ),
                                                    Text(
                                                      '월',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFF000000)
                                                      ),
                                                    ),
                                                    Text(
                                                      '일',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFF000000)
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                Container(
                                                  height: 180,
                                                  child: DatePickerWidget(
                                                    firstDate: DateTime(DateTime.now().year, 1, 1),
                                                    initialDate: DateTime.now(),
                                                    lastDate: DateTime(DateTime.now().year + 1, 12, 1),
                                                    looping: true,
                                                    dateFormat: "yyyy-MM-dd",
                                                    locale: DatePicker.localeFromString('ko'),
                                                    onChange: (DateTime newDate, _) {
                                                      setState(() {
                                                        temp = DateTime(newDate.year, newDate.month, newDate.day, temp.hour, temp.minute);
                                                      });
                                                      print(temp);
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
                                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          ),
                                          SizedBox(height: 28,),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: Size(size.width, 52),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              elevation: 0,
                                              primary: Color(0xFF3F51B5),
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                _selectedDate = "${temp.toString().substring(0, 4)}년 ${temp.toString().substring(5, 7)}월 ${temp.toString().substring(8, 10)}일";
                                              });
                                              print("selected date : $_selectedDate");
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              '확인',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                          /*
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

                             */
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
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(2.0),
                                              color: Color(0xFFD1D9E6),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 52,
                                          ),
                                          Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(width: size.width * 0.08,),
                                                    Text(
                                                      '오전/오후',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFF000000)
                                                      ),
                                                    ),
                                                    SizedBox(width: size.width * 0.204,),
                                                    Text(
                                                      '시',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFF000000)
                                                      ),
                                                    ),
                                                    SizedBox(width: size.width * 0.252,),
                                                    Text(
                                                      '분',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xFF000000)
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                /*
                                                  Container(
                                                    height: 180,
                                                    child: DatePickerWidget(
                                                      firstDate: DateTime(DateTime.now().year, 1, 1),
                                                      initialDate: DateTime.now(),
                                                      lastDate: DateTime(DateTime.now().year + 2, 1, 1),
                                                      looping: true,
                                                      dateFormat: "h-mm-a",
                                                      locale: DatePicker.localeFromString('ko'),
                                                      onChange: (DateTime newDate, _) {
                                                        setState(() {
                                                          temp = newDate;
                                                        });
                                                        print(temp);
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

                                                   */
                                                Container(
                                                  height: 180,
                                                  child: DatePickerWidget(
                                                    firstDate: DateTime(DateTime.now().year, 1, 1),
                                                    initialDate: DateTime.now(),
                                                    lastDate: DateTime(DateTime.now().year + 1, 12, 1),
                                                    looping: true,
                                                    dateFormat: "A-h-m",
                                                    locale: DatePicker.localeFromString('ko'),
                                                    onChange: (DateTime newDate, _) {
                                                      setState(() {
                                                        temp = DateTime(temp.year, temp.month, temp.day, newDate.hour, newDate.minute);
                                                      });
                                                      print('temp : $temp');
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
                                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          ),
                                          SizedBox(height: 28,),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: Size(size.width, 52),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              elevation: 0,
                                              primary: Color(0xFF3F51B5),
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                _selectedTime = "${int.parse(temp.toString().substring(17, 19)) == 0 ? '오전' : '오후'} ${int.parse(temp.toString().substring(11, 13)) + 1}시 ${int.parse(temp.toString().substring(14, 16)) + 1}분";
                                              });
                                              print("selected time : $_selectedTime");
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              '확인',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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

class CompanyWidget {
  const CompanyWidget(this.name);

  final String name;
}
