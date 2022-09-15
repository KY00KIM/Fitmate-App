import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/presentation/search_center/search_center.dart';
import 'package:fitmate/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import '../../domain/util.dart';
import '../../ui/show_toast.dart';

class MakePromisePage extends StatefulWidget {
  String partnerId;
  MakePromisePage({Key? key, required this.partnerId}) : super(key: key);

  @override
  State<MakePromisePage> createState() => _MakePromisePageState();
}

class _MakePromisePageState extends State<MakePromisePage> {
  String _selectedTime = '시간 선택';
  String _selectedDate = '날짜 선택';
  String centerName = '피트니스 클럽 검색';
  String datahour = '';
  String dataMinute = '';
  late Map center;
  late DateTime temp = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);


  String selectTime(int i) {
    int temp = i ~/ 10;
    if (temp == 0) return '0${i}';
    else return '${i}';
  }

  void PostPromise() async {

    Map data = {
      "fitness_center_id": "${center['_id']}",
      "appointment_date": "${temp}",
      "match_start_id": "${UserData['_id']}",
      "match_join_id": "${widget.partnerId}"
    };
    print(data);
    var body = json.encode(data);

    http.Response response = await http.post(Uri.parse("${baseUrlV2}appointments"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'bearer $IdToken',
      }, // this header is essential to send json data
      body: body
    );
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    print(resBody);

    if(response.statusCode == 201) {
      FlutterToastBottom("매칭이 등록되었습니다");
      Navigator.pop(context);
      Navigator.pop(context);
    } else if (resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();
      FlutterToastBottom("한번 더 시도해 주세요");
    } else {
      FlutterToastBottom("오류가 발생하였습니다");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    print("초기 temp : $temp");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: whiteTheme,
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: whiteTheme,
          elevation: 0,
          automaticallyImplyLeading: false,
          leadingWidth: 64,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 0, 8),
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
                    width: 16,
                    height: 16,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
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
                    icon:_selectedTime == '시간 선택' || _selectedDate == '날짜 선택' || centerName == '피트니스 클럽 검색' ?  SvgPicture.asset(
                      "assets/icon/bar_icons/non_color_check_icon.svg",
                      width: 16,
                      height: 16,
                    ) : SvgPicture.asset(
                      "assets/icon/bar_icons/color_check_icon.svg",
                      width: 16,
                      height: 16,
                    ),
                    onPressed: () async {
                      if(_selectedTime != '시간 선택' && _selectedDate != '날짜 선택' && centerName != '피트니스 클럽 검색') {
                        PostPromise();

                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ),
            )
          ],
          /*
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                      ),
                    ),
                    shape: Border(
                      bottom: BorderSide(
                        color: Color(0xFF3D3D3D),
                        width: 1,
                      ),
                    ),
                    title: Transform(
                      transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
                      child: Text(
                        "${widget.name}",
                        style: TextStyle(
                          color: Color(0xFFffffff),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => MakePromisePage(partnerId: widget.userId),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(80, 35),
                            primary: Color(0xFF22232A),
                            alignment: Alignment.center,
                            side: BorderSide(
                              width: 1.5,
                              color: Color(0xFFffffff),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0)),
                          ),
                          child:Text(
                            '약속잡기',
                            style: TextStyle(
                              color: Color(0xFFffffff),
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      PopupMenuButton(
                        iconSize: 30,
                        color: Color(0xFF22232A),
                        shape: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF757575),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        elevation: 40,
                        onSelected: (value) async {
                          if (value == '/chatout') {
                            showDialog(
                              context: context,
                              //barrierDismissible: false,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  backgroundColor: Color(0xFF22232A),
                                  content: Text(
                                    '채팅방을 나가시면 채팅 목록 및 대화 내용이 삭제되고 복구 할 수 없어요. 채팅방을 나가시겠어요?',
                                    style: TextStyle(
                                      color: Color(0xFFffffff),
                                    ),
                                  ),

                                  actions: [
                                    Center(
                                      child: Column(
                                        children: [
                                          ElevatedButton(
                                            child: Text('네, 나갈레요.'),
                                            onPressed: () async {
                                              http.Response response = await http.delete(Uri.parse("${baseUrlV1}chats/${widget.chatId}"),
                                                headers: {
                                                  "Authorization" : "bearer $IdToken",
                                                  "chatroomId" : "${widget.chatId}"
                                                },
                                              );
                                              var resBody = jsonDecode(utf8.decode(response.bodyBytes));
                                              if(response.statusCode != 200 && resBody["error"]["code"] == "auth/id-token-expired") {
                                                IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();

                                                response = await http.delete(Uri.parse("${baseUrlV1}chats/${widget.chatId}"),
                                                  headers: {
                                                    "Authorization" : "bearer $IdToken",
                                                    "chatroomId" : "${widget.chatId}"
                                                  },
                                                );
                                                resBody = jsonDecode(utf8.decode(response.bodyBytes));
                                              }
                                              Navigator.pushReplacement(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context, animation, secondaryAnimation) => ChatListPage(),
                                                  transitionDuration: Duration.zero,
                                                  reverseTransitionDuration: Duration.zero,
                                                ),
                                              );
                                            },
                                          ),
                                          ElevatedButton(
                                            child: Text('취소'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        itemBuilder: (BuildContext bc) {
                          return [
                            PopupMenuItem(
                              child: Text(
                                '채팅방 나가기',
                                style: TextStyle(
                                  color: Color(0xFFffffff),
                                ),
                              ),
                              value: '/chatout',
                            ),
                          ];
                        },
                      ),
                    ],

                     */
        ),
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
                        : PostPromise();
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
        \
         */
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '일정등록',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6E7995),
                        fontSize: 24.0),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '날짜',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6E7995),
                        fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 13,
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
                  SizedBox(height: 20,),
                  Text(
                    '운동 시작시간',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6E7995),
                        fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 13,
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
                  SizedBox(height: 20,),
                  Text(
                    '피트니스 클럽',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6E7995),
                        fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 11.5,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
