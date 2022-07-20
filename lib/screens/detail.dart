import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat.dart';

class DetailMachingPage extends StatefulWidget {
  const DetailMachingPage({Key? key}) : super(key: key);

  @override
  State<DetailMachingPage> createState() => _DetailMachingPageState();
}

class _DetailMachingPageState extends State<DetailMachingPage> {
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
          height: size.height * 0.085,
          child: Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width * 0.9, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
              },
              child: Text(
                '채팅하기',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.network(
                    'http://newsimg.hankookilbo.com/2018/03/07/201803070494276763_1.jpg',
                    fit: BoxFit.fitWidth,
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                    colorBlendMode: BlendMode.modulate,
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
                          '승모근',
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
                      Text(
                        '러닝머신 자세 봐드립니다!',
                        style: TextStyle(
                          color: Color(0xFFffffff),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
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
                            '  서울 강남구 / 보령헬스장',
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
                            '  22. 08. 29. (월) 오전 10:00',
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
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.network(
                                'http://newsimg.hankookilbo.com/2018/03/07/201803070494276763_1.jpg',
                                width: 60.0,
                                height: 60.0,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '우천류',
                              style: TextStyle(
                                color: Color(0xffFFFFFF),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '요세 운동할 시간이 없어서 운동 겸 몸풀기로 당분간 러닝할 생각인데 같이 하실분 구해요!',
                        style: TextStyle(
                          color: Color(0xFFffffff),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

