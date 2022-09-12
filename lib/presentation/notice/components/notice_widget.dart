import 'package:flutter/cupertino.dart';

class NoticeWidget extends StatelessWidget {
  const NoticeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
        height: 100,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.network(
                      'https://static.remove.bg/remove-bg-web/37843dee2531e43723b012aa78be4b91cc211fef/assets/start-1abfb4fe2980eabfbbaaa4365a0692539f7cd2725f324f904565a9a744f8e214.jpg',
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
                  Flexible(
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      text: TextSpan(
                        text: '토마스 박님이 매칭을 요청하였습니다. 허용하시겠습니까?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment : MainAxisAlignment.end,
                children: [
                  Text(
                    '2022-05-11 14:23',
                    style: TextStyle(
                      color: Color(0xFF6E7995),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
}