
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/presentation/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/util.dart';
import '../../ui/show_toast.dart';
import 'package:http/http.dart' as http;

import 'dart:io';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  String nickname = '';
  Map isSelectedWeekDay = {
    "mon": false,
    "tue": false,
    "wed": false,
    "thu": false,
    "fri": false,
    "sat": false,
    "sun": false
  };
  final isSelectedTime = <bool>[false, false, false];
  String location = '동네 입력';
  String centerName = '센터 등록';
  late Map center;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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

  void PatchPosets() async {

    int schedule;
    if (isSelectedTime[0] == true) schedule = 0;
    else if(isSelectedTime[1] == true) schedule = 1;
    else schedule = 2;

    String imgUrl = _image == null ? UserData['user_profile_img'] : '';
    if(_image != null) {
      List<int> imageBytes = _image!.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
    }

    Map data = {
      "_id": "${UserData['_id']}",
      "user_name": "${UserData['user_name']}",
      "user_address": "${UserData['user_address']}",
      "user_nickname": "$nickname",
      "user_email": "${UserData['user_email']}",
      "user_profile_img": imgUrl,
      "user_schedule_time": schedule,
      "user_weekday": isSelectedWeekDay,
      "user_introduce": "",
      "user_fitness_part": UserData['user_fitness_part'],
      "user_age": 0,
      "user_gender": UserData['user_gender'],
      "user_loc_bound": 3,
      "fitness_center_id": "${UserData['fitness_center_id']}",
      "user_longitude": UserData['user_longitude'],
      "user_latitude": UserData['user_latitude'],
      "location_id": "${UserData['location_id']}",
      "social": {
        "user_id": "${UserData['social']['user_id']}",
        "user_name": "${UserData['social']['user_name']}",
        "provider": "${UserData['social']['provider']}",
        "device_token": [
          "${UserData['social']['device_token']}"
        ],
        "firebase_info": {}
      },
      "is_deleted": false,
      "createdAt": "",
      "updatedAt": ""
    };
    print(data);
    var body = json.encode(data);

    http.Response response = await http.patch(Uri.parse("${baseUrlV1}users/${UserData['_id']}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization' : 'bearer $IdToken',
          'userId' : 'bearer ${UserData['_id']}',
        }, // this header is essential to send json data
        body: body
    );

    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    if(response.statusCode == 200) {
      UserData['user_nickname'] = nickname;
      UserData['user_schedule_time'] = schedule;
      UserData['user_weekday'] = isSelectedWeekDay;

      if(_image != null) {
        var request = http.MultipartRequest('POST', Uri.parse("${baseUrlV1}users/image/"));
        request.headers.addAll({"Authorization" : "bearer $IdToken"});
        request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
        var res = await request.send();
        print(res.statusCode);
        if(res.statusCode == 200) {
          var resbodyimg = json.decode(await res.stream.bytesToString());
          print(resbodyimg);
          UserData['user_profile_img'] = resbodyimg["data"].toString();
        }
      }

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
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
    log(IdToken.toString());
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
              onPressed: () {
                nickname == "" || (isSelectedTime[0] == false && isSelectedTime[1] == false && isSelectedTime[2] == false) ?
                FlutterToastBottom("상세 설명 외의 모든 항목을 입력하여주세요")
                    : PatchPosets();
              },
              child: Text(
                '저장',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: nickname == "" || (isSelectedTime[0] == false && isSelectedTime[1] == false && isSelectedTime[2] == false) ? Color(0xFF878E97) : Color(0xFF2975CF),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            width: size.width - 50,
            margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    _openImagePicker();
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      _image == null ? ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.network(
                          '${UserData['user_profile_img']}',
                          width: 85.0,
                          height: 85.0,
                          fit: BoxFit.cover,
                        ),
                      ) : ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.file(
                          _image!,
                          width: 85.0,
                          height: 85.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.photo_camera,
                          size: 20,
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xFF878E97),
                            border: Border.all(
                              color: Color(0xFF878E97),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    shape: CircleBorder(),
                    fixedSize: const Size(85, 85),
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
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '월',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["mon"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["mon"] = !isSelectedWeekDay["mon"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(40, 40),
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.all(0),
                          shape: CircleBorder(),
                          primary: isSelectedWeekDay["mon"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["mon"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '화',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["tue"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["tue"] = !isSelectedWeekDay["tue"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.all(0),
                          fixedSize: Size(40, 40),
                          shape: CircleBorder(),
                          primary: isSelectedWeekDay["tue"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["tue"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '수',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["wed"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["wed"] = !isSelectedWeekDay["wed"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.all(0),
                          fixedSize: Size(40, 40),
                          shape: CircleBorder(),
                          primary: isSelectedWeekDay["wed"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["wed"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '목',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["thu"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["thu"] = !isSelectedWeekDay["thu"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.all(0),
                          fixedSize: const Size(40, 40),
                          shape: const CircleBorder(),
                          primary: isSelectedWeekDay["thu"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["thu"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '금',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["fri"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["fri"] = !isSelectedWeekDay["fri"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.all(0),
                          fixedSize: const Size(40, 40),
                          shape: const CircleBorder(),
                          primary: isSelectedWeekDay["fri"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["fri"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '토',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["sat"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["sat"] = !isSelectedWeekDay["sat"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.all(0),
                          fixedSize: const Size(40, 40),
                          shape: const CircleBorder(),
                          primary: isSelectedWeekDay["sat"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["sat"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ElevatedButton(
                        child: Text(
                          '일',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelectedWeekDay["sun"] == false
                                ? Color(0xFF878E97)
                                : Color(0xFFffffff),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectedWeekDay["sun"] = !isSelectedWeekDay["sun"];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          padding: EdgeInsets.all(0),
                          fixedSize: const Size(40, 40),
                          shape: const CircleBorder(),
                          primary: isSelectedWeekDay["sun"] == false
                              ? Color(0xFF22232A)
                              : Color(0xFF2975CF),
                          elevation: 0,
                          side: BorderSide(
                            color: Color(0xFF878E97),
                            width: isSelectedWeekDay["sun"] == false ? 1 : 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
