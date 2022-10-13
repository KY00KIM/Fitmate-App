import 'package:flutter/material.dart';

class HomeHeadTextWidget extends StatelessWidget {
  HomeHeadTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: 40,
          width: size.width,
          // color: Colors.white,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "우리 동네",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        Container(
          height: 35,
          width: size.width,
          padding: EdgeInsets.only(bottom: 5),
          // color: Colors.grey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "핏메이트",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3F51B5),
                    letterSpacing: 1),
                textAlign: TextAlign.start,
              ),
              Text(
                "를 찾아보세요",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.start,
              ),
              Text(
                "🏃🏻‍♂️🏃🏻‍♂️",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  // letterSpacing: 1,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
