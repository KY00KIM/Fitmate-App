import 'dart:ui';

import 'package:fitmate/screens/makePromise.dart';
import 'package:fitmate/screens/matching.dart';
import 'package:fitmate/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitmate/screens/writing.dart';
import 'package:fitmate/screens/detail.dart';
import 'package:fitmate/screens/notice.dart';
import 'package:http/http.dart' as http;

import 'chatList.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF22232A),
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
            "우천류",
            style: TextStyle(
              color: Color(0xFFffffff),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => MakePromisePage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(80, 35),
                primary: Color(0xFF22232A),
                alignment: Alignment.center,
                side: BorderSide(
                  width: 1.5,
                  color: Color(0xFFffffff),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0)),
              ),
              child:Text(
                '약속잡기',
                style: TextStyle(
                  color: Color(0xFFffffff),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 10,),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    backgroundColor: Color(0xFF22232A),
                    title: Text(
                      '채팅방을 나가면 채팅 목록 및 대화 내용이 삭제되고 복구할 수 없습니다. 나가시겠습니까?',
                      style: TextStyle(
                        color: Color(0xFFffffff),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {

                              });
                            },
                            child: Text(
                              '네, 나갈래요',
                              style: TextStyle(
                                color: Color(0xFFffffff),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: Color(0xFF3889D1),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              '취소',
                              style: TextStyle(
                                color: Color(0xFF757575),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF22232A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: Padding(
              padding: EdgeInsets.only(right: 200),
              child: Icon(
                Icons.delete,
                color: Color(0xFFffffff),
                size: 30.0,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('hello world'),
            ],
          ),
        ),
      ),
    );
  }
}
