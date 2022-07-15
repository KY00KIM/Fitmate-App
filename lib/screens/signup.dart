import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

//import 'package:kpostal/kpostal.dart';
//import 'package:get/get.dart';
//import 'package:kopo/kopo.dart';
//import 'package:daum_postcode_search/daum_postcode_search.dart';

/*

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}


class _SignupPageState extends State<SignupPage> {
  final textController = TextEditingController();


  TextEditingController _AddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("sfefe"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: const EdgeInsets.only(top: 10)),
                  GestureDetector(
                    onTap: () {
                      currentFocus.unfocus();
                      HapticFeedback.mediumImpact();
                      _addressAPI();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('주소', style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
                        TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            isDense: false,
                          ),
                          controller: _AddressController,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget AddressText() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _addressAPI(); // 카카오 주소 API
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('주소', style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
          TextFormField(
            enabled: false,
            decoration: InputDecoration(
              isDense: true,
            ),
            controller: _AddressController,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  _addressAPI() async {
    KopoModel model = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => RemediKopo(),
      ),
    );
    _AddressController.text =
    '${model.zonecode!} ${model.address!} ${model.buildingName!}';
  }

}

 */

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final isSelectedSex = <bool>[false, false];
  final isSelectedWeekDay = <bool>[
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  final isSelectedTime = <bool>[false, false, false];
  String location = '동네 입력';
  String center = '센터 등록';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xff22232A),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '회원가입',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.0),
                  child: Text(
                    '프로필',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width - 165,
                      height: 45,
                      child: TextField(
                        style: TextStyle(color: Color(0xff878E97)),
                        decoration: InputDecoration(
                          hintText: '닉네임',
                          contentPadding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                          hintStyle: TextStyle(
                            color: Color(0xff878E97),
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
                      width: 110,
                      height: 45,
                      margin: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Color(0xFF878E97),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      ),
                      child: Center(
                        child: ToggleButtons(
                          color: Color(0xFF878E97),
                          selectedColor: Color(0xFFffffff),
                          //selectedBorderColor: Color(0xFF6200EE),
                          fillColor: Color(0xFF22232A).withOpacity(0.08),
                          splashColor: Color(0xFF22232A).withOpacity(0.12),
                          //hoverColor: Color(0xFF6200EE).withOpacity(0.04),
                          borderColor: Color(0xFF22232A),
                          borderRadius: BorderRadius.circular(4.0),
                          renderBorder: false,
                          constraints: BoxConstraints(minHeight: 36.0),
                          isSelected: isSelectedSex,
                          onPressed: (index) {
                            // Respond to button selection
                            setState(() {
                              if (!isSelectedSex[0] & !isSelectedSex[1]) {
                                isSelectedSex[index] = !isSelectedSex[index];
                              } else {
                                isSelectedSex[index] = !isSelectedSex[index];
                                isSelectedSex[index == 1 ? 0 : 1] =
                                    !isSelectedSex[index == 1 ? 1 : 0];
                              }
                            });
                          },
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                '남',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: isSelectedSex[0] == true
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                '여',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: isSelectedSex[1] == true
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '운동 스케쥴',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14.0),
                        ),
                        Container(
                          width: 150,
                          height: 25,
                          margin: EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Color(0xFF878E97),
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                          ),
                          child: Center(
                            child: ToggleButtons(
                              color: Color(0xFF878E97),
                              selectedColor: Color(0xFFffffff),
                              //selectedBorderColor: Color(0xFF6200EE),
                              fillColor: Color(0xFF22232A).withOpacity(0.08),
                              splashColor: Color(0xFF22232A).withOpacity(0.12),
                              //hoverColor: Color(0xFF6200EE).withOpacity(0.04),
                              borderColor: Color(0xFF22232A),
                              borderRadius: BorderRadius.circular(4.0),
                              renderBorder: false,
                              constraints: BoxConstraints(minHeight: 36.0),
                              isSelected: isSelectedTime,
                              onPressed: (index) {
                                // Respond to button selection
                                setState(() {
                                  if (isSelectedTime[index]) {
                                  } else if (!isSelectedTime[0] &
                                      !isSelectedTime[1] &
                                      !isSelectedTime[2]) {
                                    isSelectedTime[index] =
                                        !isSelectedTime[index];
                                  } else {
                                    isSelectedTime[index] =
                                        !isSelectedTime[index];
                                    if (index == 0) {
                                      isSelectedTime[1] = false;
                                      isSelectedTime[2] = false;
                                    } else if (index == 1) {
                                      isSelectedTime[0] = false;
                                      isSelectedTime[2] = false;
                                    } else if (index == 2) {
                                      isSelectedTime[1] = false;
                                      isSelectedTime[0] = false;
                                    }
                                  }
                                  print(isSelectedTime);
                                });
                              },
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    '오전',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelectedTime[0] == true
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    '오후',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelectedTime[1] == true
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    '저녁',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelectedTime[2] == true
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      child: Text(
                        '월',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelectedWeekDay[0] == false
                              ? Color(0xFF878E97)
                              : Color(0xFFffffff),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isSelectedWeekDay[0] = !isSelectedWeekDay[0];
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(40, 40),
                        minimumSize: Size(40, 40),
                        padding: EdgeInsets.only(right: 0),
                        shape: const CircleBorder(),
                        primary: isSelectedWeekDay[0] == false
                            ? Color(0xFF22232A)
                            : Color(0xFF2975CF),
                        elevation: 0,
                        side: BorderSide(
                          color: Color(0xFF878E97),
                          width: isSelectedWeekDay[0] == false ? 1 : 0,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      child: Text(
                        '화',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelectedWeekDay[1] == false
                              ? Color(0xFF878E97)
                              : Color(0xFFffffff),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isSelectedWeekDay[1] = !isSelectedWeekDay[1];
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(40, 40),
                        padding: EdgeInsets.only(right: 0),
                        fixedSize: const Size(40, 40),
                        shape: const CircleBorder(),
                        primary: isSelectedWeekDay[1] == false
                            ? Color(0xFF22232A)
                            : Color(0xFF2975CF),
                        elevation: 0,
                        side: BorderSide(
                          color: Color(0xFF878E97),
                          width: isSelectedWeekDay[1] == false ? 1 : 0,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      child: Text(
                        '수',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelectedWeekDay[2] == false
                              ? Color(0xFF878E97)
                              : Color(0xFFffffff),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isSelectedWeekDay[2] = !isSelectedWeekDay[2];
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(40, 40),
                        padding: EdgeInsets.only(right: 0),
                        fixedSize: const Size(40, 40),
                        shape: const CircleBorder(),
                        primary: isSelectedWeekDay[2] == false
                            ? Color(0xFF22232A)
                            : Color(0xFF2975CF),
                        elevation: 0,
                        side: BorderSide(
                          color: Color(0xFF878E97),
                          width: isSelectedWeekDay[2] == false ? 1 : 0,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      child: Text(
                        '목',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelectedWeekDay[3] == false
                              ? Color(0xFF878E97)
                              : Color(0xFFffffff),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isSelectedWeekDay[3] = !isSelectedWeekDay[3];
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(40, 40),
                        padding: EdgeInsets.only(right: 0),
                        fixedSize: const Size(40, 40),
                        shape: const CircleBorder(),
                        primary: isSelectedWeekDay[3] == false
                            ? Color(0xFF22232A)
                            : Color(0xFF2975CF),
                        elevation: 0,
                        side: BorderSide(
                          color: Color(0xFF878E97),
                          width: isSelectedWeekDay[3] == false ? 1 : 0,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      child: Text(
                        '금',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelectedWeekDay[4] == false
                              ? Color(0xFF878E97)
                              : Color(0xFFffffff),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isSelectedWeekDay[4] = !isSelectedWeekDay[4];
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(40, 40),
                        padding: EdgeInsets.only(right: 0),
                        fixedSize: const Size(40, 40),
                        shape: const CircleBorder(),
                        primary: isSelectedWeekDay[4] == false
                            ? Color(0xFF22232A)
                            : Color(0xFF2975CF),
                        elevation: 0,
                        side: BorderSide(
                          color: Color(0xFF878E97),
                          width: isSelectedWeekDay[4] == false ? 1 : 0,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      child: Text(
                        '토',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelectedWeekDay[5] == false
                              ? Color(0xFF878E97)
                              : Color(0xFFffffff),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isSelectedWeekDay[5] = !isSelectedWeekDay[5];
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(40, 40),
                        padding: EdgeInsets.only(right: 0),
                        fixedSize: const Size(40, 40),
                        shape: const CircleBorder(),
                        primary: isSelectedWeekDay[5] == false
                            ? Color(0xFF22232A)
                            : Color(0xFF2975CF),
                        elevation: 0,
                        side: BorderSide(
                          color: Color(0xFF878E97),
                          width: isSelectedWeekDay[5] == false ? 1 : 0,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      child: Text(
                        '일',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelectedWeekDay[6] == false
                              ? Color(0xFF878E97)
                              : Color(0xFFffffff),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isSelectedWeekDay[6] = !isSelectedWeekDay[6];
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(40, 40),
                        padding: EdgeInsets.only(right: 0),
                        fixedSize: const Size(40, 40),
                        shape: const CircleBorder(),
                        primary: isSelectedWeekDay[6] == false
                            ? Color(0xFF22232A)
                            : Color(0xFF2975CF),
                        elevation: 0,
                        side: BorderSide(
                          color: Color(0xFF878E97),
                          width: isSelectedWeekDay[6] == false ? 1 : 0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.0),
                  child: Text(
                    '지역 등록',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14.0),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: Color(0xFF878E97),
                            size: 17.0,
                          ),
                          Text(
                            ' $location',
                            style: TextStyle(
                              color: Color(0xFF878E97),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          primary: Color(0xFF22232A),
                          shape: RoundedRectangleBorder(
                            // 테두리를 라운드하게 만들기
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          side: BorderSide(
                            width: 1.0,
                            color: Color(0xFF878E97),
                          ),
                          minimumSize: Size((size.width - 55) / 2, 45)),
                      onPressed: () async {},
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                      child: Row(
                        children: [
                          Icon(
                            Icons.fitness_center,
                            color: Color(0xFF878E97),
                            size: 17.0,
                          ),
                          Text(
                            ' $center',
                            style: TextStyle(
                              color: Color(0xFF878E97),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          primary: Color(0xFF22232A),
                          shape: RoundedRectangleBorder(
                            // 테두리를 라운드하게 만들기
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          side: BorderSide(
                            width: 1.0,
                            color: Color(0xFF878E97),
                          ),
                          minimumSize: Size((size.width - 55) / 2, 45)),
                      onPressed: () async {},
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    //primary: Color(0xFF3F93D1)
                    primary: Color(0xFF3889D1),
                    minimumSize: Size(size.width-40, 45),
                  ),
                  onPressed: () {

                  },
                  child: Text(
                    '가입하기',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
