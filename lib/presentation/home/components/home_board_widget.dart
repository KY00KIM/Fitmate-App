import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../domain/model/posts.dart';
import '../../writing.dart';

class HomeBoardWidget extends StatelessWidget {
  const HomeBoardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget> [
          GestureDetector(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WritingPage()));
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(8, 10, 8, 10),
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
              width: 292,
            ),
          ),
        ],
      ),
    );
  }
}
