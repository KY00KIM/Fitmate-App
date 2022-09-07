import 'package:flutter/material.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
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
              "알림",
              style: TextStyle(
                color: Color(0xFFffffff),
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Image.asset(
              'assets/images/cherry-no-messages2.png',
              width: 150,
            ),
          ),
        ),
      ),
    );
  }
}
