import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import '../../domain/util.dart';
import '../../ui/bar_widget.dart';
import '../fitness_map/fitness_map.dart';

class SearchCenterPage extends StatefulWidget {
  const SearchCenterPage({Key? key}) : super(key: key);

  @override
  State<SearchCenterPage> createState() => _SearchCenterPageState();
}

class _SearchCenterPageState extends State<SearchCenterPage> {
  List data = [];
  String result = '';
  TextEditingController _editingController = new TextEditingController();
  final barWidget = BarWidget();
  bool serverVersion = true;  // true 시 서버 만으로 성공

  Future<String> getJSONData() async {
    var url = Uri.parse('https://fitmate.co.kr/v2/fitnesscenters/search?keyWord=${_editingController.text}&page=1&limit=100');

    var response = await http
        .get(url, headers: {"Authorization": "bearer ${IdToken}"});
    var resBody = json.decode(response.body);

    /*
    if(resBody['data']['docs'].length == 0) {
      print("서버 실패");
      url = Uri.parse('https://dapi.kakao.com/v2/local/search/keyword.json?size=15&sort=accuracy&query=${_editingController.text}&page=45');
      response = await http
          .get(url, headers: {"Authorization": "KakaoAK 281e3d7d678f26ad3b6020d8fc517852"});
      var resBody2 = json.decode(response.body) ;

      print("카카오 ; ${resBody2}");
      List temp = [];
      for(int i = 0; i< resBody2['documents'].length; i++) {
        temp.add({
          "center_name" : resBody2['documents'][i]['place_name'],
          "center_address" : resBody2['documents'][i]['address_name'],
          "fitness_longitude" : double.parse(resBody2['documents'][i]['y']),
          "fitness_latitude" : double.parse(resBody2['documents'][i]['x']),
          "kakao_url" : resBody2['documents'][i]['place_url'],
        });
      }

      setState(() {
        //serverVersion = false;
        data.clear();
        data.addAll(temp);
      });
    } else {
      print("서버 성공;");
      setState(() {
        //serverVersion = true;
        data.clear();
        List result = resBody['data']['docs'];
        print("result : ${result}");
        data.addAll(result);
      });
    }

     */
    if(resBody['data']['docs'].length != 0) {
      setState(() {
        data.clear();
        List result = resBody['data']['docs'];
        log("result : ${result}");
        data.addAll(result);
      });
    }


    return response.body;
  }

  Future<void> returnPop(BuildContext context, var data) async {
    print("함수에서 받은 값 : ${data}");

    print("바로 반환");
    Navigator.pop(context, data);

    /*
    if(serverVersion) {
      print("바로 반환");
      Navigator.pop(context, data);
    } else {
      print("바로 반환하지 않음");
      Map body = {
        "center_name": "${data['center_name'].toString()}",
        "center_address": "${data['center_address'].toString()}",
        "fitness_longitude": data['fitness_longitude'],
        "fitness_latitude": data['fitness_latitude'],
        "kakao_url": "${data['kakao_url'].toString()}"
      };
      var bodyParse = json.encode(body);
      http.Response response = await http.post(
        Uri.parse("https://fitmate.co.kr/v2/fitnesscenters"),
        headers: {
          "Authorization": "bearer $IdToken",
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: bodyParse,
      );
      var resBody = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 201 &&
          resBody["error"]["code"] == "auth/id-token-expired") {
        IdToken =
        (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
        .token
        .toString();
        response = await http.post(
          Uri.parse("https://fitmate.co.kr/v2/fitnesscenters"),
          headers: {
            "Authorization": "bearer $IdToken",
            "Content-Type": "application/json; charset=UTF-8"
          },
          body: bodyParse,
        );
        resBody = jsonDecode(utf8.decode(response.bodyBytes));
      }
      print("반환 값 : ${resBody['data']}");
      Navigator.pop(context, resBody['data']);
    }

     */
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //var res = searchCenter('YB휘트니스');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: whiteTheme,
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 64,
        centerTitle: false,
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
                  "assets/icon/bar_icons/x_icon.svg",
                  width: 16,
                  height: 16,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        backgroundColor: whiteTheme,
        title: Container(
          height: 44,
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
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Row(
              children: [
                Container(
                  width: size.width - 164,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    controller: _editingController,
                    decoration: InputDecoration(
                      hintText: "제목을 입력..",
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFD1D9E6),
                      ),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) async {
                      getJSONData();
                    },
                  ),
                ),
                IconButton(onPressed: () {
                  getJSONData();
                }, icon: SvgPicture.asset(
                  "assets/icon/search_outline_icon.svg",
                  width: 16,
                  height: 16,
                )),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: size.width,
        padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
        child: data.length == 0 && _editingController.text == ''
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "검색어 예시",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6E7995),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 27,),
                Text(
                  "피트니스 비엠",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 34,),
                Text(
                  "휘트니스 클럽",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 34,),
                Text(
                  "휘트니스",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 34,),
              ],
            )
            : (data.length == 0 ? Center(child: Text('검색 결과가 없습니다'),) : Container(
              width: size.width - 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '검색 결과 ${data.length}',
                    style: TextStyle(
                      color: Color(0xFF6E7995),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            returnPop(context, data[index]);
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 16, 20, 16),
                            height: 80,
                            width: size.width,
                            color: whiteTheme,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      data[index]['center_name'].toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF000000),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 28,
                                      height: 28,
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
                                            "assets/icon/map_icon.svg",
                                            width: 16,
                                            height: 16,
                                          ),
                                          onPressed: () async {
                                            bool outturn = await Navigator
                                                .push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                    animation,
                                                    secondaryAnimation) =>
                                                    FitnessMapPage(x: data[index]['fitness_latitude'], y: data[index]['fitness_longitude'], fitnessName: '${data[index]['center_name'].toString()}', fitnessAddress: '${data[index]['center_address'].toString()}',),
                                                transitionDuration:
                                                Duration.zero,
                                                reverseTransitionDuration:
                                                Duration.zero,
                                              ),
                                            );
                                            if(outturn) returnPop(context, data[index]);
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16,),
                                    Container(
                                      width: 28,
                                      height: 28,
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
                                            "assets/icon/right_arrow_icon.svg",
                                            width: 16,
                                            height: 16,
                                          ),
                                          onPressed: () {
                                            returnPop(context, data[index]);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        text: TextSpan(
                                          text: data[index]['center_address'].toString(),
                                          style: TextStyle(
                                            color: Color(0xFF6E7995),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

