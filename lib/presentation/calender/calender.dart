import 'dart:collection';
import 'dart:convert';
import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/presentation/review/review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:http/http.dart' as http;

import '../../domain/util.dart';
import '../../ui/bar_widget.dart';
import '../../ui/colors.dart';
import '../../ui/show_toast.dart';
import '../profile/other_profile.dart';

class Event {
  final Map content;

  const Event(this.content);
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

class CalenderPage extends StatefulWidget {
  const CalenderPage({Key? key}) : super(key: key);

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late ValueNotifier<List<Event>> _selectedEvents;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List<String> partnerName = [];
  List<String> matchingPlace = [];

  final barWidget = BarWidget();

  late Map<DateTime, List<Event>> _kEventSource;
  var kEvents;

  List matchingDate = [];

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  /// Returns a list of [DateTime] objects from [first] to [last], inclusive.
  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  Future<bool> getMatching() async {
    http.Response response = await http.get(
      Uri.parse("${baseUrlV1}appointments"),
      headers: {
        "Authorization": "bearer $IdToken",
        "Content-Type": "application/json; charset=UTF-8"
      },
    );
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200 &&
        resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();

      response = await http.post(
        Uri.parse("${baseUrlV1}appointments"),
        headers: {
          'Authorization': 'bearer $IdToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    if (response.statusCode != 200) {
      FlutterToastBottom("매칭 값을 가져오지 못했습니다");
    }

    print("resbody : ${resBody['data']}");

    _kEventSource = Map.fromIterable(List.generate(0, (index) => index),
        key: (item) => DateTime.utc(1999, 01, 01),
        value: (item) => List.generate(item % 4 + 1,
            (index) => Event({'k': 'Event $item | ${index + 1}'})));

    var temp;
    for (int i = 0; i < resBody['data'].length; i++) {
      temp = Event(resBody['data'][i]);
      http.Response response2 = await http.get(
        Uri.parse(
            "${baseUrlV1}fitnesscenters/${resBody['data'][i]['center_id']}"),
        headers: {
          "Authorization": "bearer $IdToken",
          "fitnesscenterId": "${resBody['data'][i]['center_id']}"
        },
      );
      var resBody2 = jsonDecode(utf8.decode(response2.bodyBytes));
      if (response2.statusCode != 200 &&
          resBody2["error"]["code"] == "auth/id-token-expired") {
        IdToken =
            (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
                .token
                .toString();

        response2 = await http.get(
          Uri.parse(
              "${baseUrlV1}fitnesscenters/${resBody['data'][i]['center_id']}"),
          headers: {
            "Authorization": "bearer $IdToken",
            "fitnesscenterId": "${resBody['data'][i]['center_id']}"
          },
        );
        resBody2 = jsonDecode(utf8.decode(response.bodyBytes));
      }
      temp.content['centerName'] = "${resBody2['data']['center_name']}";

      String partnerId = resBody['data'][i]['match_start_id'] == UserData['_id']
          ? resBody['data'][i]['match_join_id']
          : resBody['data'][i]['match_start_id'];
      http.Response response3 = await http.get(
        Uri.parse("${baseUrlV1}users/${partnerId}"),
        headers: {"Authorization": "bearer $IdToken", "userId": "${partnerId}"},
      );
      var resBody3 = jsonDecode(utf8.decode(response3.bodyBytes));
      if (response3.statusCode != 200 &&
          resBody3["error"]["code"] == "auth/id-token-expired") {
        IdToken =
            (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
                .token
                .toString();

        response3 = await http.get(
          Uri.parse("${baseUrlV1}users/${partnerId}"),
          headers: {
            "Authorization": "bearer $IdToken",
            "userId": "${partnerId}"
          },
        );
        resBody3 = jsonDecode(utf8.decode(response.bodyBytes));
      }
      temp.content['partnerName'] = "${resBody3['data']['user_nickname']}";
      temp.content['parnerImg'] = "${resBody3['data']['user_profile_img']}";
      print("머냐 : ${resBody3['data']['user_profile_img']}");

      if (_kEventSource.containsKey(DateTime.utc(
              int.parse(resBody['data'][i]['appointment_date']
                  .toString()
                  .substring(0, 4)),
              int.parse(resBody['data'][i]['appointment_date']
                  .toString()
                  .substring(5, 7)),
              int.parse(resBody['data'][i]['appointment_date']
                  .toString()
                  .substring(8, 10)))) ==
          true) {
        //기존 날짜에 해당 날짜가 있음
        _kEventSource[DateTime.utc(
                int.parse(resBody['data'][i]['appointment_date']
                    .toString()
                    .substring(0, 4)),
                int.parse(resBody['data'][i]['appointment_date']
                    .toString()
                    .substring(5, 7)),
                int.parse(resBody['data'][i]['appointment_date']
                    .toString()
                    .substring(8, 10)))]
            ?.add(temp);
      } else {
        //없띠
        _kEventSource[DateTime.utc(
            int.parse(resBody['data'][i]['appointment_date']
                .toString()
                .substring(0, 4)),
            int.parse(resBody['data'][i]['appointment_date']
                .toString()
                .substring(5, 7)),
            int.parse(resBody['data'][i]['appointment_date']
                .toString()
                .substring(8, 10)))] = [temp];
      }
    }

    kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_kEventSource);

    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
    return Scaffold(
      backgroundColor: whiteTheme,
      appBar: barWidget.appBar(context),
      bottomNavigationBar: barWidget.bottomNavigationBar(context, 4),
      body: SafeArea(
        child: Container(
          child: FutureBuilder<bool>(
              future: getMatching(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _selectedDay = _focusedDay;
                  _selectedEvents =
                      ValueNotifier(_getEventsForDay(_selectedDay!));
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          children: [
                            TableCalendar<Event>(
                              calendarBuilders: CalendarBuilders(
                                singleMarkerBuilder: (context, date, _) {
                                  DateTime now = DateTime.now();
                                  DateFormat formatter = DateFormat('yyyy-MM-dd');
                                  String strToday = formatter.format(now);
                                  if(matchingDate.contains(date)) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (date == _selectedDay ||
                                              date.toString() ==
                                                  '$strToday 00:00:00.000Z')
                                              ? Color(0xFFF27F22)
                                              : Color(0xFFF27F22)),
                                      //Change color
                                      width: 8.0,
                                      height: 8.0,
                                      //margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                    );
                                  } else {
                                    matchingDate.add(date);
                                    return Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: (date == _selectedDay ||
                                              date.toString() ==
                                                  '$strToday 00:00:00.000Z')
                                              ? Color(0xFF00E3AE)
                                              : Color(0xFF00E3AE)),
                                      //Change color
                                      width: 8.0,
                                      height: 8.0,
                                      //margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                    );
                                  }
                                },
                              ),
                              headerStyle: HeaderStyle(
                                titleCentered: true,
                                formatButtonVisible: false,
                                leftChevronVisible: true,
                                rightChevronVisible: true,
                                titleTextStyle: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                //headerMargin: EdgeInsets.only(bottom: 10),
                              ),
                              daysOfWeekHeight: 30,
                              locale: 'ko_KO',
                              //focusedDay: kToday,
                              focusedDay: _focusedDay,
                              firstDay: kFirstDay,
                              lastDay: kLastDay,

                              selectedDayPredicate: (day) =>
                                  isSameDay(_selectedDay, day),
                              rangeStartDay: _rangeStart,
                              rangeEndDay: _rangeEnd,
                              calendarFormat: _calendarFormat,
                              rangeSelectionMode: _rangeSelectionMode,
                              eventLoader: _getEventsForDay,
                              //startingDayOfWeek: StartingDayOfWeek.monday,
                              daysOfWeekStyle: DaysOfWeekStyle(
                                weekdayStyle: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                weekendStyle: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              calendarStyle: CalendarStyle(
                                outsideTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFFD1D9E6)),
                                selectedTextStyle: TextStyle(
                                  color: Color(0xFFffffff),
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                defaultTextStyle: TextStyle(
                                  color: Color(0xFF000000),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                                weekendTextStyle: TextStyle(
                                  color: Color(0xFF000000),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: Color(0xff3F51B5),
                                  //shape: BoxShape.circle,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                todayDecoration: BoxDecoration(
                                  color: Color(0xFF6FA2DE),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                todayTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF000000),
                                  fontSize: 17,
                                ),
                                outsideDaysVisible: true,
                              ),
                              onDaySelected: _onDaySelected,
                              onRangeSelected: _onRangeSelected,
                              onFormatChanged: (format) {
                                if (_calendarFormat != format) {
                                  setState(() {
                                    _calendarFormat = format;
                                  });
                                }
                              },
                              onPageChanged: (focusedDay) {
                                _focusedDay = focusedDay;
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icon/calender_color_icon.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      '운동일정',
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 32,
                                  height: 32,
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
                                        "assets/icon/bar_icons/plus_icon.svg",
                                        width: 16,
                                        height: 16,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ValueListenableBuilder<List<Event>>(
                          valueListenable: _selectedEvents,
                          builder: (context, value, _) {
                            print("value length : ${value.length}");
                            return ScrollConfiguration(
                              behavior: const ScrollBehavior()
                                  .copyWith(overscroll: false),
                              child: ListView.builder(
                                itemCount: value.length,
                                itemBuilder: (context, index) {
                                  print("value : ${value[index].content}");
                                  return Container(
                                    margin: EdgeInsets.fromLTRB(20, 16, 20, 0),
                                    padding: EdgeInsets.all(16),
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(8),
                                      color: Color(0xFFF2F3F7),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFFffffff),
                                          spreadRadius: 2,
                                          blurRadius: 8,
                                          offset: Offset(-2, -2),
                                        ),
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                              55, 84, 170, 0.1),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 4,
                                                  height: 20,
                                                  color: Color(0xFF00E3AE),
                                                ),
                                                SizedBox(
                                                  width: 12,
                                                ),
                                                Text(
                                                  '매칭DAY',
                                                  style: TextStyle(
                                                    color:
                                                    Color(0xFF000000),
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              child: Container(
                                                child: SvgPicture.asset(
                                                  "assets/icon/burger_icon.svg",
                                                  width: 18,
                                                  height: 18,
                                                ),
                                              ),
                                              onTap: () {
                                                showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  context: context,
                                                  shape: const RoundedRectangleBorder(
                                                    // <-- SEE HERE
                                                    borderRadius: BorderRadius
                                                        .vertical(
                                                      top: Radius.circular(
                                                          40.0),
                                                    ),
                                                  ),
                                                  backgroundColor: Color(
                                                      0xFFF2F3F7),
                                                  builder: (
                                                      BuildContext context) {
                                                    return Wrap(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Container(
                                                              width: 40,
                                                              height: 4,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(2.0),
                                                                color: Color(0xFFD1D9E6),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 36,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                print("Container clicked");
                                                              },
                                                              child: Container(
                                                                padding:
                                                                EdgeInsets.fromLTRB(20, 22, 20, 20),
                                                                height: 64,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      '채팅방 이동',
                                                                      style: TextStyle(
                                                                        color: Color(0xFF000000),
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                print("Container clicked");
                                                              },
                                                              child: Container(
                                                                padding:
                                                                EdgeInsets.fromLTRB(20, 22, 20, 20),
                                                                height: 64,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      '커뮤니티 게시글 보기',
                                                                      style: TextStyle(
                                                                        color: Color(0xFF000000),
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 16,
                                            ),
                                            SvgPicture.asset(
                                              "assets/icon/clock_icon.svg",
                                              width: 12,
                                              height: 12,
                                            ),
                                            SizedBox(width: 8,),
                                            Text(
                                              '${int.parse(value[index].content['appointment_date'].toString().substring(11, 13)) > 12 ? "오후" : "오전"} ${int.parse(value[index].content['appointment_date'].toString().substring(11, 13)) > 12 ? (int.parse(value[index].content['appointment_date'].toString().substring(11, 13)) - 12).toString() : int.parse(value[index].content['appointment_date'].toString().substring(11, 13)).toString()}시 ${value[index].content['appointment_date'].toString().substring(14, 16)}분',
                                              style: TextStyle(
                                                color: Color(0xFF6E7995),
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(width: 16,),
                                            SvgPicture.asset(
                                              "assets/icon/dumbbell_icon.svg",
                                              width: 12,
                                              height: 12,
                                            ),
                                            SizedBox(width: 8,),
                                            Flexible(
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                strutStyle: StrutStyle(fontSize: 16),
                                                text: TextSpan(
                                                  text: '${value[index].content['centerName']}',
                                                  style: TextStyle(
                                                    color: Color(0xFF6E7995),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 16,
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  100.0),
                                              child: Image.network(
                                                '${value[index].content['parnerImg']}',
                                                width: 20.0,
                                                height: 20.0,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (BuildContext context,
                                                    Object exception,
                                                    StackTrace?
                                                    stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/profile_null_image.png',
                                                    width: 20.0,
                                                    height: 20.0,
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 8,),
                                            Text(
                                              '${value[index].content['partnerName']}',
                                              style: TextStyle(
                                                color: Color(0xFF6E7995),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 16,),
                                            value[index].content['isReviewed'] == false ? GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ReviewPage(
                                                            recv_id:
                                                            "${value[index].content['match_start_id'] == UserData['_id'] ? value[index].content['match_join_id'] : value[index].content['match_start_id']}",
                                                            appointmentId:
                                                            "${value[index].content['_id']}")));
                                              },
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icon/star_icon.svg",
                                                      width: 16,
                                                      height: 16,
                                                    ),
                                                    SizedBox(width: 8,),
                                                    Text(
                                                      '평가를 남겨주세요',
                                                      style: TextStyle(
                                                        color: Color(0xFF3F51B5),
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(width: 4,),
                                                    SvgPicture.asset(
                                                      "assets/icon/right_arrow_icon.svg",
                                                      width: 12,
                                                      height: 12,
                                                      color: Color(0xFF3F51B5),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ) : Container(
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icon/color_star_icon.svg",
                                                    width: 16,
                                                    height: 16,
                                                  ),
                                                  SizedBox(width: 8,),
                                                  Text(
                                                    '평가 완료',
                                                    style: TextStyle(
                                                      color: Color(0xFF3F51B5),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4,),
                                                  SvgPicture.asset(
                                                    "assets/icon/right_arrow_icon.svg",
                                                    width: 12,
                                                    height: 12,
                                                    color: Color(0xFF3F51B5),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    /*
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                              primary: Color(0xFFF2F3F7),
                                              //borderRadius: BorderRadius.circular(40),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              )),
                                          onPressed: () {
                                            if (value[index]
                                                .content['match_start_id'] ==
                                                UserData['_id']) {
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          OtherProfilePage(
                                                              profileId: value[
                                                              index]
                                                                  .content[
                                                              'match_join_id'],
                                                              profileName:
                                                              '매칭 대상')));
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          OtherProfilePage(
                                                              profileId: value[
                                                              index]
                                                                  .content[
                                                              'match_start_id'],
                                                              profileName:
                                                              '매칭 대상')));
                                            }
                                          },
                                          child: Padding(
                                            padding:
                                            EdgeInsets.fromLTRB(15, 0, 0, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: size.width - 105,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child: RichText(
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              maxLines: 1,
                                                              strutStyle:
                                                              StrutStyle(
                                                                  fontSize:
                                                                  16),
                                                              text: TextSpan(
                                                                text:
                                                                '${value[index].content['partnerName']}님과 매칭 운동 Day입니다!',
                                                                style: TextStyle(
                                                                  color: Color(
                                                                      0xFFffffff),
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      Text(
                                                        '장소 : ${value[index].content['centerName']}      시간 : ${int.parse(value[index].content['appointment_date'].toString().substring(11, 13)) > 12 ? (int.parse(value[index].content['appointment_date'].toString().substring(11, 13)) - 12).toString() : int.parse(value[index].content['appointment_date'].toString().substring(11, 13)).toString()}:${value[index].content['appointment_date'].toString().substring(14, 16)}${int.parse(value[index].content['appointment_date'].toString().substring(11, 13)) > 12 ? "pm" : "am"}',
                                                        style: TextStyle(
                                                          color:
                                                          Color(0xFFDADADA),
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                         */
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // 기본적으로 로딩 Spinner를 보여줍니다.
                return Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }
}
