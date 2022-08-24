//import 'dart:html' as http;
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/data.dart';
import 'matching.dart';

class ReviewPage extends StatefulWidget {
  String appointmentId;
  String recv_id;
  ReviewPage({Key? key, required this.appointmentId, required this.recv_id}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    Key? key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 30,
              height: 40,
              child: Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Color(0xff878E97),
                ),
                child: Checkbox(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),

                  value: value,
                  onChanged: (bool? newValue) {
                    onChanged(newValue);
                  },
                ),
              ),
            ),
            SizedBox(width: 10,),
            Text(
                label,
              style: TextStyle(
                color: Color(0xFFffffff),
                //fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ReviewPageState extends State<ReviewPage> {
  late List reviewData;
  String description = "";
  List<bool> checkBoxList = [false, false, false, false, false, false, false];
  List<String> checkBoxListId = [
    '62c66ef64b8212e4674dbe20',
    '62c66f0b4b8212e4674dbe21',
    '62c66ead4b8212e4674dbe1f',
    '62c66f224b8212e4674dbe22',
    '62dbb2e126e97374cf97aec7',
    '62dbb2fb26e97374cf97aec8',
    '62dbb30f26e97374cf97aec9'
  ];

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.parse('${baseUrl}reviews/candidates'),
        headers: {
          'Authorization': 'bearer $IdToken',
          'Content-Type': 'application/json; charset=UTF-8'
        });
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode != 200 && resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken =
          (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
              .token
              .toString();

      response = await http.get(
        Uri.parse("${baseUrl}reviews/candidates"),
        headers: {
          'Authorization': 'bearer $IdToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    if (response.statusCode != 200) {
      FlutterToastTop("알수 없는 에러가 발생하였습니다");
    } else {
      this.setState(() {
        reviewData = resBody["data"];
      });
    }
    return "success";
  }

  @override
  void initState() {
    super.initState();
    //this.getData();
  }

  Future<void> PostReview() async {
    List choice = [];
    for(int i = 0; i < checkBoxList.length; i++) {
      if(checkBoxList[i] == true) choice.add(checkBoxListId[i]);
    }
    Map data = {
      "review_recv_id": "${widget.recv_id}",
      "review_body": "${description}",
      "user_rating": 3,
      "review_candidates": choice,
      "appointmentId": "${widget.appointmentId}"
    };
    print(data);
    var body = json.encode(data);

    http.Response response = await http.post(Uri.parse("${baseUrl}reviews/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization' : 'bearer $IdToken',
        }, // this header is essential to send json data
        body: body
    );
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    print(resBody);

    if(response.statusCode == 201) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => MatchingPage(),
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
              "리뷰 작성",
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
                (checkBoxList[0] == true || checkBoxList[1] == true || checkBoxList[2] == true || checkBoxList[3] == true || checkBoxList[4] == true || checkBoxList[5] == true || checkBoxList[6] == true) && description != '' ?
                PostReview() :
                  FlutterToastBottom("매칭 리뷰 선택 및 후기 작성을 해주세요!");
              },
              child: Text(
                '완료',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: (checkBoxList[0] == true || checkBoxList[1] == true || checkBoxList[2] == true || checkBoxList[3] == true || checkBoxList[4] == true || checkBoxList[5] == true || checkBoxList[6] == true) && description != '' ? Color(0xFF2975CF) : Color(0xFF878E97),
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
                    ' 이번 매칭이 어떠셨나요?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  LabeledCheckbox(
                    label: '매너가 좋아요.',
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    value: checkBoxList[0],
                    onChanged: (bool newValue) {
                      setState(() {
                        checkBoxList[0] = newValue;
                      });
                    },
                  ),
                  LabeledCheckbox(
                    label: '시간 약속을 잘 지켜요',
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    value: checkBoxList[1],
                    onChanged: (bool newValue) {
                      setState(() {
                        checkBoxList[1] = newValue;
                      });
                    },
                  ),
                  LabeledCheckbox(
                    label: '친절하고 매너가 좋아요.',
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    value: checkBoxList[2],
                    onChanged: (bool newValue) {
                      setState(() {
                        checkBoxList[2] = newValue;
                      });
                    },
                  ),
                  LabeledCheckbox(
                    label: '열정적이에요.',
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    value: checkBoxList[3],
                    onChanged: (bool newValue) {
                      setState(() {
                        checkBoxList[3] = newValue;
                      });
                    },
                  ),
                  LabeledCheckbox(
                    label: '채팅 응답이 빨라요.',
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    value: checkBoxList[4],
                    onChanged: (bool newValue) {
                      setState(() {
                        checkBoxList[4] = newValue;
                      });
                    },
                  ),
                  LabeledCheckbox(
                    label: '자세를 잘 봐줘요.',
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    value: checkBoxList[5],
                    onChanged: (bool newValue) {
                      setState(() {
                        checkBoxList[5] = newValue;
                      });
                    },
                  ),
                  LabeledCheckbox(
                    label: '모르는 운동법을 잘 알려줘요.',
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    value: checkBoxList[6],
                    onChanged: (bool newValue) {
                      setState(() {
                        checkBoxList[6] = newValue;
                      });
                    },
                  ),
                  /*
                  ListView.builder(
                    itemCount: reviewData == null ? 0 : reviewData.length,
                    itemBuilder: (BuildContext context, int idx) {
                      return ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WriteCenterPage()),
                          ).then((onValue) {
                            print(onValue);
                            onValue == null ? null : setState(() {
                              centerName = onValue['place_name'];
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
                              ' $centerName',
                              style: TextStyle(
                                color: Color(0xFF878E97),
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                   */
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    ' 후기를 남겨주세요!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 20,
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
                        hintText: '여기에 적어주세요.',
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
