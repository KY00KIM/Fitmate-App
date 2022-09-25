import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../domain/model/post.dart';

class DetailTitleWidget extends StatelessWidget {
  Post post;
  DetailTitleWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
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
      width: size.width,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 50,
                  text: TextSpan(
                    text:
                    '${post.postTitle}',
                    style: TextStyle(
                      color: Color(0xFF6E7995),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '작성일 : ${post.createdAt.toString().substring(0, 4)}년 ${post.createdAt.toString().substring(5, 7)}월 ${post.createdAt.toString().substring(8, 10)}일',
                style: TextStyle(
                  color: Color(0xFF6E7995),
                  fontSize: 12,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
