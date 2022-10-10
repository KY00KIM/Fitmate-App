import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/data/http_api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../domain/util.dart';

Future<Map> userCertify() async {
  HttpApi api = HttpApi();
  Map data = await locator.getSomeLocation();
  data['fitnesscenterId'] = UserData['fitness_center_id'];
  print("data : $data");
  http.Response response = await api.post(2, "trace/certificate", data);

  var resBody = jsonDecode(utf8.decode(response.bodyBytes));
  print("res : $resBody");
  return resBody;
}

void centerAuthenicate(context) {
  showDialog(
      context: context,
      barrierDismissible: true,
      // 바깥 영역 터치시 닫을지 여부
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("센터 인증하기", style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Text("현재 등록하신 피트니스 센터 근처에 있어야 합니다.\n필수: 위치정보를 허용해주세요.",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
          ),
          insetPadding: const EdgeInsets.fromLTRB(20, 80, 20, 80),
          actions: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              width: 60,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFF2F3F7),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFffffff),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(-2, -2),
                  ),
                  BoxShadow(
                    color: const Color.fromRGBO(55, 84, 170, 0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: TextButton(
                  child: Text(
                    '아니오',
                    style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 20, 10),
              width: 70,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFF2F3F7),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFffffff),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(-1, -1),
                  ),
                  BoxShadow(
                    color: const Color.fromRGBO(55, 84, 170, 0.1),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: TextButton(
                  child: Text(
                    "인증하기",
                    style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    showDialog(
                        // The user CANNOT close this dialog  by pressing outsite it
                        barrierDismissible: false,
                        context: context,
                        builder: (_) {
                          return Dialog(
                            // The background color
                            backgroundColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  // The loading indicator
                                  CircularProgressIndicator(),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  // Some text
                                  Text(
                                    '인증중입니다',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                    Map resBody = await userCertify();
                    Fluttertoast.showToast(
                        msg: (resBody["data"]["is_certificated"]
                            ? "인증되었습니다"
                            : "인증에 실패했습니다"),
                        gravity: ToastGravity.TOP);

                    // 기본적으로 로딩 Spinner를 보여줍니다.

                    Navigator.pop(
                      context,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      });
}
