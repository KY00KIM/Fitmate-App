import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:developer';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/screens/review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fitmate/utils/data.dart';

import 'package:http/http.dart' as http;


import '../utils/bottomNavigationBar.dart';
import 'notice.dart';
import 'otherProfile.dart';


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

class MatchingPage extends StatefulWidget {
  const MatchingPage({Key? key}) : super(key: key);

  @override
  State<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends State<MatchingPage> {
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

  late Map<DateTime, List<Event>> _kEventSource;
  var kEvents;

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
    http.Response response = await http.get(Uri.parse("${baseUrl}appointments"),
      headers: {"Authorization" : "bearer $IdToken", "Content-Type": "application/json; charset=UTF-8"},
    );
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    if(response.statusCode != 200 && resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();

      response = await http.post(Uri.parse("${baseUrl}appointments"),
        headers: {'Authorization' : 'bearer $IdToken', 'Content-Type': 'application/json; charset=UTF-8',},
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    if(response.statusCode != 200) {
      FlutterToastBottom("매칭 값을 가져오지 못했습니다");
    }

    _kEventSource = Map.fromIterable(List.generate(0, (index) => index),
        key: (item) => DateTime.utc(1999, 01, 01),
        value: (item) => List.generate(
            item % 4 + 1, (index) => Event({'k' : 'Event $item | ${index + 1}'})));


    var temp;
    for(int i = 0; i < resBody['data'].length; i++) {
      temp = Event(resBody['data'][i]);
      http.Response response2 = await http.get(Uri.parse("${baseUrl}fitnesscenters/${resBody['data'][i]['center_id']}"),
        headers: {"Authorization" : "bearer $IdToken", "fitnesscenterId": "${resBody['data'][i]['center_id']}"},
      );
      var resBody2 = jsonDecode(utf8.decode(response2.bodyBytes));
      if(response2.statusCode != 200 && resBody2["error"]["code"] == "auth/id-token-expired") {
        IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();

        response2 = await http.get(Uri.parse("${baseUrl}fitnesscenters/${resBody['data'][i]['center_id']}"),
          headers: {"Authorization" : "bearer $IdToken", "fitnesscenterId": "${resBody['data'][i]['center_id']}"},
        );
        resBody2 = jsonDecode(utf8.decode(response.bodyBytes));
      }
      temp.content['centerName'] = "${resBody2['data']['center_name']}";

      String partnerId = resBody['data'][i]['match_start_id'] == UserData['_id'] ? resBody['data'][i]['match_join_id'] : resBody['data'][i]['match_start_id'];
      http.Response response3 = await http.get(Uri.parse("${baseUrl}users/${partnerId}"),
        headers: {"Authorization" : "bearer $IdToken", "userId": "${partnerId}"},
      );
      var resBody3 = jsonDecode(utf8.decode(response3.bodyBytes));
      if(response3.statusCode != 200 && resBody3["error"]["code"] == "auth/id-token-expired") {
        IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();

        response3 = await http.get(Uri.parse("${baseUrl}users/${partnerId}"),
          headers: {"Authorization" : "bearer $IdToken", "userId": "${partnerId}"},
        );
        resBody3 = jsonDecode(utf8.decode(response.bodyBytes));
      }
      temp.content['partnerName'] = "${resBody3['data']['user_nickname']}";


      if(_kEventSource.containsKey(DateTime.utc(int.parse(resBody['data'][i]['appointment_date'].toString().substring(0, 4)), int.parse(resBody['data'][i]['appointment_date'].toString().substring(5, 7)), int.parse(resBody['data'][i]['appointment_date'].toString().substring(8, 10)))) == true) {
        //기존 날짜에 해당 날짜가 있음
        _kEventSource[DateTime.utc(int.parse(resBody['data'][i]['appointment_date'].toString().substring(0, 4)), int.parse(resBody['data'][i]['appointment_date'].toString().substring(5, 7)), int.parse(resBody['data'][i]['appointment_date'].toString().substring(8, 10)))]?.add(temp);
      }
      else{
        //없띠
        _kEventSource[DateTime.utc(int.parse(resBody['data'][i]['appointment_date'].toString().substring(0, 4)), int.parse(resBody['data'][i]['appointment_date'].toString().substring(5, 7)), int.parse(resBody['data'][i]['appointment_date'].toString().substring(8, 10)))] = [temp];
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
    log(IdToken);
    final Size size = MediaQuery.of(context).size;
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
    return Scaffold(
      backgroundColor: Color(0xFF22232A),

      appBar: AppBar(
        elevation: 0.0,
        /*
        shape: Border(
          bottom: BorderSide(
            color: Color(0xFF3D3D3D),
            width: 1,
          ),
        ),

         */
        backgroundColor: Color(0xFF22232A),
        title: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Text(
            "매칭",
            style: TextStyle(
              color: Color(0xFFffffff),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        /*
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => NoticePage()));
              //Navigator.push(context, CupertinoPageRoute(builder: (context) => TableEventsExample()));
            },
            icon: Padding(
              padding: EdgeInsets.only(right: 200),
              child: Icon(
                Icons.notifications_none,
                color: Color(0xFFffffff),
                size: 30.0,
              ),
            ),
          ),
        ],

         */
      ),

      /*
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF22232A),
        child: Container(
          width: size.width,
          //height: 60.0,
          height: size.height * 0.085,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                  //Route route = MaterialPageRoute(builder: (context) => HomePage());
                  //Navigator.pushReplacement(context, route);
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => HomePage(reload: false,),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                  /*
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );

                   */
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.home_filled,
                      color: Color(0xFF757575),
                      //size: 30.0,
                      size: size.width * 0.0763,
                    ),
                    Text(
                      '홈',
                      style: TextStyle(
                        color: Color(0xFF757575),
                        //fontSize: 10.0,
                        fontSize: size.width * 0.0253,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                  //Route route = MaterialPageRoute(builder: (context) => ChatListPage());
                  //Navigator.pushReplacement(context, route);
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => ChatListPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                  /*
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => ChatListPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );

                   */
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Color(0xFF757575),
                      //size: 30.0,
                      size: size.width * 0.0763,
                    ),
                    Text(
                      '내 대화',
                      style: TextStyle(
                        color: Color(0xFF757575),
                        //fontSize: 10.0,
                        fontSize: size.width * 0.0253,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                  //Route route = MaterialPageRoute(builder: (context) => MatchingPage());
                  //Navigator.pushReplacement(context, route);
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => MapPage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                  /*
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => MatchingPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );

                   */
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.map,
                      color: Color(0xFF757575),
                      //size: 30.0,
                      size: size.width * 0.0763,
                    ),
                    Text(
                      '피트니스장',
                      style: TextStyle(
                        color: Color(0xFF757575),
                        //fontSize: 10.0,
                        fontSize: size.width * 0.0253,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                  //Route route = MaterialPageRoute(builder: (context) => MatchingPage());
                  //Navigator.pushReplacement(context, route);

                  /*
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => MatchingPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );

                   */
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Color(0xFFffffff),
                      //size: 30.0,
                      size: size.width * 0.0763,
                    ),
                    Text(
                      '매칭',
                      style: TextStyle(
                        color: Color(0xFFffffff),
                        //fontSize: 10.0,
                        fontSize: size.width * 0.0253,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                  //Route route = MaterialPageRoute(builder: (context) => ProfilePage());
                  //Navigator.pushReplacement(context, route);
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                  /*
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return child;
                      },
                    ),
                  );

                   */
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.person,
                      color: Color(0xFF757575),
                      size: size.width * 0.0763,
                    ),
                    Text(
                      '프로필',
                      style: TextStyle(
                        color: Color(0xFF757575),
                        //fontSize: 10.0,
                        fontSize: size.width * 0.0253,
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
      bottomNavigationBar: bottomNavigationBar(context, 4),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
          child: FutureBuilder<bool>(
          future: getMatching(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _selectedDay = _focusedDay;
              _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
              return Column(
                children: [
                  TableCalendar<Event>(
                    calendarBuilders: CalendarBuilders(
                      singleMarkerBuilder: (context, date, _) {
                        DateTime now = DateTime.now();
                        DateFormat formatter = DateFormat('yyyy-MM-dd');
                        String strToday = formatter.format(now);
                        return Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (date == _selectedDay || date.toString() == '$strToday 00:00:00.000Z') ? Colors.white : Color(0xff2975CF)), //Change color
                          width: 5.0,
                          height: 5.0,
                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        );
                      },
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      leftChevronVisible: false,
                      rightChevronVisible: false,
                      titleTextStyle: TextStyle(
                        color: Color(0xFFffffff),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      headerMargin: EdgeInsets.only(bottom: 10),
                    ),
                    daysOfWeekHeight:30,
                    locale: 'ko_KO',
                    //focusedDay: kToday,
                    focusedDay: _focusedDay,
                    firstDay: kFirstDay,
                    lastDay: kLastDay,

                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    rangeStartDay: _rangeStart,
                    rangeEndDay: _rangeEnd,
                    calendarFormat: _calendarFormat,
                    rangeSelectionMode: _rangeSelectionMode,
                    eventLoader: _getEventsForDay,
                    //startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarStyle: CalendarStyle(
                      selectedTextStyle: TextStyle(
                        color: Color(0xFFDADADA),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      defaultTextStyle: TextStyle(
                        color: Color(0xFFDADADA),
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                      weekendTextStyle: TextStyle(
                        color: Color(0xFFDADADA),
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Color(0xff2975CF),
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Color(0xFF6FA2DE),
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDADADA),
                        fontSize: 17,
                      ),
                      outsideDaysVisible: false,
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
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 3,
                        color: Color(0xFF3D3D3D),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ValueListenableBuilder<List<Event>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _) {
                        print("value length : ${value.length}");
                        return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            /*
                            return Container(
                              height: 100,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 2.0,
                                vertical: 6.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ListTile(
                                onTap: () => print('${value[index]}'),
                                title: Text('이게 ddv머지 ${value[index].content['match_join_id']}'),
                              ),
                            );
                             */
                            if (value[index].content['isReviewed'] == false) {
                              return Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 2.0,
                                      vertical: 6.0,
                                    ),
                                    width: size.width - 50,
                                    height: 80,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF2975CF),
                                          //borderRadius: BorderRadius.circular(40),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          )
                                      ),
                                      onPressed: () {
                                        if(value[index].content['match_start_id'] == UserData['_id']) {
                                          Navigator.push(context, CupertinoPageRoute(builder : (context) => OtherProfilePage(profileId : value[index].content['match_join_id'], profileName : '내 파트너')));
                                        } else {
                                          Navigator.push(context, CupertinoPageRoute(builder : (context) => OtherProfilePage(profileId : value[index].content['match_start_id'], profileName : '내 파트너')));
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: size.width - 95,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: RichText(
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          strutStyle: StrutStyle(fontSize: 16),
                                                          text: TextSpan(
                                                            text: '${value[index].content['partnerName']}님과 매칭 운동 Day입니다!',
                                                            style: TextStyle(
                                                              color: Color(0xFFffffff),
                                                              fontSize: 17,
                                                              fontWeight: FontWeight.bold,
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
                                                      color: Color(0xFFDADADA),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  /*
                                                Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(50.0),
                                                      child: Image.network(
                                                        'https://picsum.photos/250?image=9',
                                                        width: 20.0,
                                                        height: 20.0,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Text(
                                                      '토마스 박',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Color(0xFFDADADA),
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                 */
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 2.0,
                                      vertical: 6.0,
                                    ),
                                    width: size.width - 50,
                                    height: 80,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF2B2C39),
                                          //borderRadius: BorderRadius.circular(40),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          )
                                      ),
                                      onPressed: () {
                                        //리뷰 페이지로 전환
                                        print('이거 머냐 : ${value[index].content}');
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewPage(
                                            recv_id : "${value[index].content['match_start_id'] == UserData['_id'] ? value[index].content['match_join_id'] : value[index].content['match_start_id']}",
                                            appointmentId : "${value[index].content['_id']}")
                                          )
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: size.width - 95,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: RichText(
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          strutStyle: StrutStyle(fontSize: 16),
                                                          text: TextSpan(
                                                            text: '${value[index].content['partnerName']}님과의 매칭은 어떠셨나요?',
                                                            style: TextStyle(
                                                              color: Color(0xFFffffff),
                                                              fontSize: 17,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        '리뷰하러가기 >',
                                                        style: TextStyle(
                                                          color: Color(0xFFDADADA),
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  /*
                                                Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(50.0),
                                                      child: Image.network(
                                                        'https://picsum.photos/250?image=9',
                                                        width: 20.0,
                                                        height: 20.0,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Text(
                                                      '토마스 박',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Color(0xFFDADADA),
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                 */
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2.0,
                                  vertical: 6.0,
                                ),
                                width: size.width - 50,
                                height: 80,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xFF2975CF),
                                      //borderRadius: BorderRadius.circular(40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      )
                                  ),
                                  onPressed: () {
                                    if(value[index].content['match_start_id'] == UserData['_id']) {
                                      Navigator.push(context, CupertinoPageRoute(builder : (context) => OtherProfilePage(profileId : value[index].content['match_join_id'], profileName : '매칭 대상')));
                                    } else {
                                      Navigator.push(context, CupertinoPageRoute(builder : (context) => OtherProfilePage(profileId : value[index].content['match_start_id'], profileName : '매칭 대상')));
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: size.width - 105,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      strutStyle: StrutStyle(fontSize: 16),
                                                      text: TextSpan(
                                                        text: '${value[index].content['partnerName']}님과 매칭 운동 Day입니다!',
                                                        style: TextStyle(
                                                          color: Color(0xFFffffff),
                                                          fontSize: 17,
                                                          fontWeight: FontWeight.bold,
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
                                                  color: Color(0xFFDADADA),
                                                  fontSize: 12,
                                                ),
                                              ),
                                              /*
                                            Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(50.0),
                                                  child: Image.network(
                                                    'https://picsum.photos/250?image=9',
                                                    width: 20.0,
                                                    height: 20.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  '토마스 박',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFFDADADA),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                             */
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  /*
                Container(
                  width: size.width - 50,
                  height: 105,
                  decoration: BoxDecoration(
                    color: Color(0xFF2975CF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '우파루파님과 매칭 운동 Day입니다!',
                          style: TextStyle(
                            color: Color(0xFFffffff),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          '장소 : 우릉 피트니스장      시간 : 3:20pm',
                          style: TextStyle(
                            color: Color(0xFFDADADA),
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.network(
                                'https://picsum.photos/250?image=9',
                                width: 20.0,
                                height: 20.0,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              '토마스 박',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFFDADADA),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                 */
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // 기본적으로 로딩 Spinner를 보여줍니다.
            return Center(child: CircularProgressIndicator());
          }

          ),
        ),
      ),
    );
  }
}


