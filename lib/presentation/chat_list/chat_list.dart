import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/presentation/chat/chat.dart';
import 'package:fitmate/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import '../../domain/util.dart';
import '../../ui/bar_widget.dart';


class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> with AutomaticKeepAliveClientMixin {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  var chatDocId;
  var data;
  var chat;

  final barWidget = BarWidget();

  Future<List> getChatList() async {
    print("가동시작!");
    http.Response response = await http.get(Uri.parse("${baseUrlV1}chats/info"),
      headers: {"Authorization" : "bearer $IdToken", "Content-Type": "application/json; charset=UTF-8"},
    );
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    if(response.statusCode != 200 && resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();

      response = await http.get(Uri.parse("${baseUrlV1}chats/info"),
        headers: {"Authorization" : "bearer $IdToken", "Content-Type": "application/json; charset=UTF-8"},
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    if(response.statusCode == 200) {
      chatList = resBody["data"];
      log("log : ${resBody['data']}");

      return resBody["data"];
    } else {
      print("what the fuck");
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();
    print("chat list init");
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteTheme,
      appBar: barWidget.appBar(context),
      //bottomNavigationBar: barWidget.bottomNavigationBar(context, 2),
      body: SafeArea(
        child: FutureBuilder<List> (
          future: getChatList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icon/chat_icon.svg",
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 12,),
                            Text(
                              '채팅',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            if(snapshot.data![index]['chat_start_id']['_id'] == UserData['_id'] || snapshot.data![index]['chat_join_id']['_id'] == UserData['_id']) {
                              return GestureDetector(
                                onTap: () async {
                                  bool rebuild = await Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
                                    name : snapshot.data![index]['chat_start_id']['_id'] == UserData['_id'] ? snapshot.data![index]['chat_join_id']['user_nickname'] : snapshot.data![index]['chat_start_id']['user_nickname'],
                                    imageUrl : snapshot.data![index]['chat_start_id']['_id'] == UserData['_id'] ? snapshot.data![index]['chat_join_id']['user_profile_img'] : snapshot.data![index]['chat_start_id']['user_profile_img'],
                                    uid : snapshot.data![index]['chat_start_id']['_id'] == UserData['_id'] ? snapshot.data![index]['chat_join_id']['social']['user_id'] : snapshot.data![index]['chat_start_id']['social']['user_id'],
                                    userId : snapshot.data![index]['chat_start_id']['_id'] == UserData['_id'] ? snapshot.data![index]['chat_join_id']['_id'] : snapshot.data![index]['chat_start_id']['_id'],
                                    chatId: snapshot.data![index]['_id'],
                                  )
                                  )
                                  ) as bool;
                                  if(rebuild) {
                                    setState(() {
                                      chatList;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  height: 84,
                                  margin: EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: whiteTheme,
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
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(100.0),
                                          child: Image(
                                            image: CachedNetworkImageProvider('${snapshot.data![index]['chat_start_id']['_id'] == UserData['_id'] ? snapshot.data![index]['chat_join_id']['user_profile_img'] : snapshot.data![index]['chat_start_id']['user_profile_img']}'),
                                            width: 55,
                                            height: 55,
                                            fit: BoxFit.cover,
                                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                              return Image.asset(
                                                'assets/images/profile_null_image.png',
                                                width: 40.0,
                                                height: 40.0,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: size.width - 155,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${snapshot.data![index]['chat_start_id']['_id'] == UserData['_id'] ? snapshot.data![index]['chat_join_id']['user_nickname'] : snapshot.data![index]['chat_start_id']['user_nickname']}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    '${snapshot.data![index]['updatedAt'].toString().substring(5, 7)}월 ${snapshot.data![index]['updatedAt'].toString().substring(8, 10)}일',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Color(0XFF6E7995),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 4,),
                                            Container(
                                              width: size.width - 155,
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    child: RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      text: TextSpan(
                                                        text: '${snapshot.data![index]['last_chat']}',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                ),
                              );
                            }
                            else return SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icon/chat_icon.svg",
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(width: 12,),
                          Text(
                            '채팅',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: chatList.length,
                        itemBuilder: (context, index) {
                          if(chatList[index]['chat_start_id']['_id'] == UserData['_id'] || chatList[index]['chat_join_id']['_id'] == UserData['_id']) {
                            return GestureDetector(
                              onTap: () async {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
                                  name : chatList[index]['chat_start_id']['_id'] == UserData['_id'] ? chatList[index]['chat_join_id']['user_nickname'] : chatList[index]['chat_start_id']['user_nickname'],
                                  imageUrl : chatList[index]['chat_start_id']['_id'] == UserData['_id'] ? chatList[index]['chat_join_id']['user_profile_img'] : chatList[index]['chat_start_id']['user_profile_img'],
                                  uid : chatList[index]['chat_start_id']['_id'] == UserData['_id'] ? chatList[index]['chat_join_id']['social']['user_id'] : chatList[index]['chat_start_id']['social']['user_id'],
                                  userId : chatList[index]['chat_start_id']['_id'] == UserData['_id'] ? chatList[index]['chat_join_id']['_id'] : chatList[index]['chat_start_id']['_id'],
                                  chatId: chatList[index]['_id'],
                                )
                                )
                                );
                              },
                              child: Container(
                                height: 84,
                                margin: EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: whiteTheme,
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(100.0),
                                            child: Image.network(
                                              '${chatList[index]['chat_start_id']['_id'] == UserData['_id'] ? chatList[index]['chat_join_id']['user_profile_img'] : chatList[index]['chat_start_id']['user_profile_img']}',
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                return Image.asset(
                                                  'assets/images/profile_null_image.png',
                                                  width: 45.0,
                                                  height: 45.0,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${chatList[index]['chat_start_id']['_id'] == UserData['_id'] ? chatList[index]['chat_join_id']['user_nickname'] : chatList[index]['chat_start_id']['user_nickname']}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '${chatList[index]['last_chat']}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                            /*
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(size.width, 84),
                                  maximumSize: Size(size.width, 84),
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(0),
                                  ),
                                  primary: whiteTheme
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
                                  name : chatList[index]['chat_start_id']['_id'] == UserData['_id'] ? chatList[index]['chat_join_id']['user_nickname'] : chatList[index]['chat_start_id']['user_nickname'],
                                  imageUrl : chatList[index]['chat_start_id']['_id'] == UserData['_id'] ? chatList[index]['chat_join_id']['user_profile_img'] : chatList[index]['chat_start_id']['user_profile_img'],
                                  uid : chatList[index]['chat_start_id']['_id'] == UserData['_id'] ? chatList[index]['chat_join_id']['social']['user_id'] : chatList[index]['chat_start_id']['social']['user_id'],
                                  userId : chatList[index]['chat_start_id']['_id'] == UserData['_id'] ? chatList[index]['chat_join_id']['_id'] : chatList[index]['chat_start_id']['_id'],
                                  chatId: chatList[index]['_id'],
                                )
                                )
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(100.0),
                                          child: Image.network(
                                            '${chatList[index]['chat_start_id']['_id'] == UserData['_id'] ? chatList[index]['chat_join_id']['user_profile_img'] : chatList[index]['chat_start_id']['user_profile_img']}',
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                              return Image.asset(
                                                'assets/images/profile_null_image.png',
                                                width: 45.0,
                                                height: 45.0,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          '${chatList[index]['chat_start_id']['_id'] == UserData['_id'] ? chatList[index]['chat_join_id']['user_nickname'] : chatList[index]['chat_start_id']['user_nickname']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );

                             */
                          }
                          else return SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/*
class _ChatListPageState extends State<ChatListPage> {

  final barWidget = BarWidget();

  Future<List> getChatList() async {
    http.Response response = await http.get(Uri.parse("${baseUrlV1}chats/info"),
      headers: {"Authorization" : "bearer $IdToken", "Content-Type": "application/json; charset=UTF-8"},
    );
    var resBody = jsonDecode(utf8.decode(response.bodyBytes));
    if(response.statusCode != 200 && resBody["error"]["code"] == "auth/id-token-expired") {
      IdToken = (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!.token.toString();

      response = await http.get(Uri.parse("${baseUrlV1}chats/info"),
        headers: {"Authorization" : "bearer $IdToken", "Content-Type": "application/json; charset=UTF-8"},
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));
    }

    print("반환 준비 : ${response.statusCode}");
    if(response.statusCode == 200) {
      print("반환 갑니다잉");
      log(resBody['data'].toString());
      log(UserData.toString());
      print(resBody);
      return resBody["data"];
    }
    else {
      print("what the fuck");
      throw Exception('Failed to load post');
    }
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteTheme,
      appBar: barWidget.appBar(context),
      bottomNavigationBar: barWidget.bottomNavigationBar(context, 2),
      body: SafeArea(
        child: FutureBuilder<List> (
          future: getChatList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icon/chat_icon.svg",
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 12,),
                            Text(
                              '채팅',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            if(snapshot.data![index]['chat_start_id']['_id'] == UserData['_id'] || snapshot.data![index]['chat_join_id']['_id'] == UserData['_id']) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(size.width, 84),
                                    maximumSize: Size(size.width, 84),
                                    shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(0),
                                    ),
                                    primary: Color(0xFF22232A)
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
                                      name : snapshot.data![index]['chat_start_id']['_id'] == UserData['_id'] ? snapshot.data![index]['chat_join_id']['user_nickname'] : snapshot.data![index]['chat_start_id']['user_nickname'],
                                      imageUrl : snapshot.data![index]['chat_start_id']['_id'] == UserData['_id'] ? snapshot.data![index]['chat_join_id']['user_profile_img'] : snapshot.data![index]['chat_start_id']['user_profile_img'],
                                      uid : snapshot.data![index]['chat_start_id']['_id'] == UserData['_id'] ? snapshot.data![index]['chat_join_id']['social']['user_id'] : snapshot.data![index]['chat_start_id']['social']['user_id'],
                                      userId : snapshot.data![index]['chat_start_id']['_id'] == UserData['_id'] ? snapshot.data![index]['chat_join_id']['_id'] : snapshot.data![index]['chat_start_id']['_id'],
                                      chatId: snapshot.data![index]['_id'],
                                      )
                                    )
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(100.0),
                                            child: Image.network(
                                              '${snapshot.data![index]['chat_start_id']['_id'] == UserData['_id'] ? snapshot.data![index]['chat_join_id']['user_profile_img'] : snapshot.data![index]['chat_start_id']['user_profile_img']}',
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                return Image.asset(
                                                  'assets/images/profile_null_image.png',
                                                  width: 45.0,
                                                  height: 45.0,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            '${snapshot.data![index]['chat_start_id']['_id'] == UserData['_id'] ? snapshot.data![index]['chat_join_id']['user_nickname'] : snapshot.data![index]['chat_start_id']['user_nickname']}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            else return SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // 기본적으로 로딩 Spinner를 보여줍니다.
            //return Center(child: CircularProgressIndicator());
            return SizedBox();
          },
        ),
      ),
    );
  }
}

 */