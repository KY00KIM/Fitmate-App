import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/data.dart';
import 'chat.dart';
import 'otherProfile.dart';

class DetailMachingPage extends StatefulWidget {
  String postId;

  DetailMachingPage(String this.postId, {Key? key}) : super(key: key);

  @override
  State<DetailMachingPage> createState() => _DetailMachingPageState();
}

class _DetailMachingPageState extends State<DetailMachingPage> {
  String makerLocationName = '';
  String makerUsersName = '';
  String makerUserImage = '';
  String makerCenterName = '';
  String makerUserId = '';
  String makerUserUid = '';

  Future<bool> addChat() async{
    //기존 채팅방이 있는지 확인
    http.Response response = await http.get(Uri.parse("${baseUrl}chats/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization' : 'bearer $IdToken',
        },
    );
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));

    if(response.statusCode != 200 && resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();

      http.Response response = await http.get(Uri.parse("${baseUrl}chats/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization' : 'bearer $IdToken',
        },
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    for(int i = 0; i < resBody['data'].length; i++) {
      if((resBody['data'][i]['chat_start_id'] == UserData['_id'] && resBody['data'][i]['chat_join_id'] == makerUserId) || (resBody['data'][i]['chat_join_id'] == UserData['_id'] && resBody['data'][i]['chat_start_id'] == makerUserId)) {
        return true;
      }
    }

    Map data = {
      "chat_join_id": "$makerUserId"
    };
    print(data);
    var body = json.encode(data);
    log(IdToken);
    http.Response response2 = await http.post(Uri.parse("${baseUrl}chats/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization' : 'bearer $IdToken',
        }, // this header is essential to send json data
        body: body
    );
    var resBody2 = jsonDecode(utf8.decode(response2.bodyBytes));
    print('오우 : ${response.body}');
    if(response.statusCode != 200 && resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();

      response2 = await http.post(Uri.parse("${baseUrl}chats/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization' : 'bearer $IdToken',
          }, // this header is essential to send json data
          body: body
      );
      resBody2 = jsonDecode(utf8.decode(response2.bodyBytes));
    }

    if(response2.statusCode == 201) return true;
    else return false;
  }

  Future<List> getPostDetail() async {
    print("idtoken : $IdToken");
    print("skflsjeifslf");
    http.Response response = await http.get(Uri.parse("${baseUrl}posts/${widget.postId}"),
      headers: {"Authorization" : "bearer $IdToken", "Content-Type": "application/json; charset=UTF-8", "postId" : "${widget.postId}"},
    );
    print("response 완료");
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    print("아 몰라");
    if(response.statusCode != 200 && resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();

      http.Response response = await http.get(Uri.parse("${baseUrl}posts/${widget.postId}"),
        headers: {"Authorization" : "bearer $IdToken", "Content-Type": "application/json; charset=UTF-8", "postId" : "${widget.postId}"},
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    http.Response responseFitness = await http.get(Uri.parse("${baseUrl}fitnesscenters/${resBody['data'][0]['promise_location'].toString()}"), headers: {
      // ignore: unnecessary_string_interpolations
      "Authorization" : "bearer ${IdToken.toString()}",
      "fitnesscenterId" : "${resBody['data'][0]['promise_location'].toString()}"});

    if(responseFitness.statusCode == 200) {
      var resBody2 = jsonDecode(utf8.decode(responseFitness.bodyBytes));

      makerCenterName = resBody2["data"]["center_name"];
    }

    makerUserId = resBody['data'][0]['user_id'].toString();
    http.Response responseUser = await http.get(Uri.parse("${baseUrl}users/${resBody['data'][0]['user_id'].toString()}"), headers: {
      // ignore: unnecessary_string_interpolations
      "Authorization" : "bearer ${IdToken.toString()}",
      "Content-Type" : "application/json; charset=UTF-8",
      "userId" : "${resBody['data'][0]['user_id'].toString()}"});
    var resBody3 = jsonDecode(utf8.decode(responseUser.bodyBytes));

    makerUserUid = resBody3['data']['social']['user_id'];
    makerUserImage = resBody3['data']['user_profile_img'];
    makerUsersName = resBody3['data']['user_nickname'];

    http.Response responseLocation = await http.get(Uri.parse("${baseUrl}locations/${resBody['data'][0]['location_id'].toString()}"), headers: {
      // ignore: unnecessary_string_interpolations
      "Authorization" : "bearer ${IdToken.toString()}",
      "locId" : "${resBody['data'][0]['location_id'].toString()}"});

    if(responseLocation.statusCode == 200) {
      var resBody3 = jsonDecode(utf8.decode(responseLocation.bodyBytes));

      makerLocationName = resBody3["data"]["location_name"];
    }


    print("반환 준비 : ${response.statusCode}");
    if(response.statusCode == 200) {
      print("반환 갑니다잉");
      return resBody["data"];
    }
    else {
      print("what the fuck");
      throw Exception('Failed to load post');
    }
  }

  void ReportPosets() async {
    http.Response response = await http.post(Uri.parse("${baseUrl}report/${widget.postId}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization' : 'bearer $IdToken',
          'postId' : '${widget.postId}'
        },
    );
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    print(resBody);

    if(response.statusCode == 201) {
      log(IdToken);
      FlutterToastBottom("신고가 접수되었습니다");
    } else if (resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();
      FlutterToastBottom("오류가 발생했습니다. 한번 더 시도해 주세요");
    } else {
      FlutterToastBottom("오류가 발생하였습니다");
    }

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF22232A),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF22232A),
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          width: size.width,
          height: size.height * 0.075,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(size.width * 0.1, 45),
                    primary: Color(0xFFC74646),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    ReportPosets();
                  },
                  child: Text(
                    '신고',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.02,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(size.width * 0.75, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    if(makerUserId != UserData['_id']) {
                      bool addChatAnswer = await addChat();
                      if (addChatAnswer == true) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(name : makerUsersName, imageUrl : makerUserImage, uid : makerUserUid, userId : makerUserId)));
                      }
                    }
                  },
                  child: Text(
                    '채팅하기',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List> (
          future: getPostDetail(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String? time = snapshot.data?[0]['promise_date'].toString().substring(11,13);
              String slot = int.parse(time!) > 12 ? '오후' : '오전';
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Stack(
                        children: [
                          Image.network(
                            '${snapshot.data?[0]['post_img']}',
                            fit: BoxFit.fitWidth,
                            width: size.width,
                            color: Color.fromRGBO(255, 255, 255, 0.8),
                            colorBlendMode: BlendMode.modulate,
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return Image.asset(
                                'assets/images/dummy.jpg',
                                fit: BoxFit.fitWidth,
                                width: size.width,
                                color: Color.fromRGBO(255, 255, 255, 0.8),
                                colorBlendMode: BlendMode.modulate,
                              );
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 8, 0, 0),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Color(0xFFffffff),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xFF22232A),
                        ),
                        transform: Matrix4.translationValues(0.0, -37.0, 0.0),
                        child:Padding(
                          padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                height: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Color(0xFF2975CF),
                                ),
                                child: Text(
                                  '${fitnessPart[snapshot.data?[0]['post_fitness_part'][0]]}',
                                  style: TextStyle(
                                    color: Color(0xFFffffff),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: size.width - 50,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                        strutStyle: StrutStyle(fontSize: 16),
                                        text: TextSpan(
                                          text: '${snapshot.data?[0]['post_title']}',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_pin,
                                    color: Color(0xFF2975CF),
                                    size: 20,
                                  ),
                                  Text(
                                    '  $makerLocationName / $makerCenterName',
                                    style: TextStyle(
                                      color: Color(0xFFDADADA),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    color: Color(0xFF2975CF),
                                    size: 20,
                                  ),
                                  Text(
                                    '  ${snapshot.data?[0]['promise_date'].toString().substring(2,4)}. ${snapshot.data?[0]['promise_date'].toString().substring(5,7)}. ${snapshot.data?[0]['promise_date'].toString().substring(8,10)}.  ${slot} ${int.parse(time) > 12 ? '${int.parse(time) - 12}' : '${int.parse(time)}'}:${snapshot.data?[0]['promise_date'].toString().substring(14,16)}',
                                    style: TextStyle(
                                      color: Color(0xFFDADADA),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Text(
                                '상세설명',
                                style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 35),
                                width: size.width,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, CupertinoPageRoute(builder : (context) => OtherProfilePage(profileId : snapshot.data?[0]['user_id'], profileName : '$makerUsersName')));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xFF22232A),
                                      elevation: 0
                                  ),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(100.0),
                                        child: Image.network(
                                          '$makerUserImage',
                                          width: 60.0,
                                          height: 60.0,
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                            return Image.asset(
                                              'assets/images/dummy.jpg',
                                              width: 60.0,
                                              height: 60.0,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '$makerUsersName',
                                        style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width - 50,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 50,
                                        strutStyle: StrutStyle(fontSize: 12),
                                        text: TextSpan(
                                          text: '${snapshot.data?[0]['post_main_text']}',
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // 기본적으로 로딩 Spinner를 보여줍니다.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

