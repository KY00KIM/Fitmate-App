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
          TextButton(
            onPressed: () {

            },
            style: TextButton.styleFrom(

            ),
            child: Text(
              '약속잡기',
              style: TextStyle(
                color: Color(0xFFffffff),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
           ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => NoticePage()));
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
