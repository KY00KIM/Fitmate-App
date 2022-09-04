import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/presentation/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../domain/util.dart';
import '../ui/bar_widget.dart';


class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

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
      backgroundColor: Color(0xFF22232A),
      appBar: barWidget.appBar(context),
      bottomNavigationBar: barWidget.bottomNavigationBar(context, 2),
      body: SafeArea(
        child: FutureBuilder<List> (
          future: getChatList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    if(snapshot.data![index]['chat_start_id']['_id'] == UserData['_id'] || snapshot.data![index]['chat_join_id']['_id'] == UserData['_id']) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.zero,
                            minimumSize: Size(size.width, 75),
                            maximumSize: Size(size.width, 75),
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
                          //Route route = MaterialPageRoute(builder: (context) => ChatPage());
                          //Navigator.pushReplacement(context, route);
                          //Navigator.push(context, CupertinoPageRoute(builder : (context) => ChatPage()));

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
                                      width: 45.0,
                                      height: 45.0,
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
                                      fontSize: 16,
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