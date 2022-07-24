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
          /*
          child: SingleChildScrollView(
            child: ListBody(
              children: [
                Container(
                  width: size.width,
                  height: 110,
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Color(0xFF22232A),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.network(
                            'http://newsimg.hankookilbo.com/2018/03/07/201803070494276763_1.jpg',
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: size.width - 110,
                              child: Flexible(
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 100,
                                  strutStyle: StrutStyle(fontSize: 16),
                                  text: TextSpan(
                                    text: '안녕하세요아아아아아아아ㅏ아아dkdkdk아아ㅏ~',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              '1일전',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF757575)
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
              ],
            ),
          ),
          */
        ),
      ),
    );
  }
}
