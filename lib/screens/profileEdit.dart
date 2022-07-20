import 'package:fitmate/screens/writeCenter.dart';
import 'package:fitmate/screens/writeLocation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  String _selectedTime = '시간 선택';
  String _selectedDate = '날짜 선택';
  String nickname = '';
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
  String centerName = '센터 등록';
  late Map center;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final ImagePicker _picker = ImagePicker();
  late PickedFile _image;

  Future _getImage() async {
    PickedFile? image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = (image == null ? null : image)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
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
            transform:  Matrix4.translationValues(-20.0, 0.0, 0.0),
            child: Text(
              "프로필 수정",
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
                '저장',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFffffff)
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            width: size.width - 50,
            margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
            /*
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.network(
                    'http://newsimg.hankookilbo.com/2018/03/07/201803070494276763_1.jpg',
                    width: 85.0,
                    height: 85.0,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.0),
                  child: Text(
                    '닉네임',
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
                SizedBox(
                  width: size.width - 50,
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
              ],
            ),
             */
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.network(
                    'http://newsimg.hankookilbo.com/2018/03/07/201803070494276763_1.jpg',
                    width: 85.0,
                    height: 85.0,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.0),
                      child: Text(
                        '닉네임',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width - 50,
                      height: 45,
                      child: TextField(
                        onChanged: (value) {
                          nickname = value;
                        },
                        style: TextStyle(color: Color(0xffFFFFFF)),
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
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '운동 루틴',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16.0),
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
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 7.0),
                          child: Text(
                            '내 동네',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16.0),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: Color(0xFF878E97),
                                size: 17.0,
                              ),
                              Flexible(
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  strutStyle: StrutStyle(fontSize: 15),
                                  text: TextSpan(
                                    text: ' $location',
                                    style: TextStyle(
                                      color: Color(0xFF878E97),
                                      fontSize: 15,
                                    ),
                                  ),
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
                            minimumSize: Size((size.width - 65) / 2, 45),
                            maximumSize: Size((size.width - 65) / 2, 45),
                          ),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WriteLocationPage()),
                            ).then((onValue) {
                              print(onValue);
                              onValue == null ? null : setState(() {
                                location = onValue;
                              });
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 7.0),
                          child: Text(
                            '내 피트니스장',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16.0),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          child: Row(
                            children: [
                              Icon(
                                Icons.fitness_center,
                                color: Color(0xFF878E97),
                                size: 17.0,
                              ),
                              Flexible(
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  strutStyle: StrutStyle(fontSize: 15),
                                  text: TextSpan(
                                    text: ' $centerName',
                                    style: TextStyle(
                                      color: Color(0xFF878E97),
                                      fontSize: 15,
                                    ),
                                  ),
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
                            minimumSize: Size((size.width - 65) / 2, 45),
                            maximumSize: Size((size.width - 65) / 2, 45),
                          ),
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
                                centerName = onValue['place_name'];
                              });
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                /*
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
                          Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              strutStyle: StrutStyle(fontSize: 15),
                              text: TextSpan(
                                text: ' $location',
                                style: TextStyle(
                                  color: Color(0xFF878E97),
                                  fontSize: 15,
                                ),
                              ),
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
                        minimumSize: Size((size.width - 55) / 2, 45),
                        maximumSize: Size((size.width - 55) / 2, 45),
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WriteLocationPage()),
                        ).then((onValue) {
                          print(onValue);
                          onValue == null ? null : setState(() {
                            location = onValue;
                          });
                        });
                      },
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
                          Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              strutStyle: StrutStyle(fontSize: 15),
                              text: TextSpan(
                                text: ' $centerName',
                                style: TextStyle(
                                  color: Color(0xFF878E97),
                                  fontSize: 15,
                                ),
                              ),
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
                        minimumSize: Size((size.width - 55) / 2, 45),
                        maximumSize: Size((size.width - 55) / 2, 45),
                      ),
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
                            centerName = onValue['place_name'];
                          });
                        });
                      },
                    ),
                  ],
                ),

                 */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
