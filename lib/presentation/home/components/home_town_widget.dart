import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../domain/util.dart';

class HomeTownWidget extends StatelessWidget {
  const HomeTownWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      height: 412,
      child: Column(
        children: [
          Container(
            height:52,
            child:Center(
              child:Text(
                '${UserData['user_address'].toString()}',
                style: TextStyle(
                  color: Color(0xff000000),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            height:240,
            color: Colors.yellow,
          ),
          Container(
            height: 120,
            padding: EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${UserCenterName}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: TextSpan(
                          text:
                          '${UserData['user_address']}',
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icon/star_icon.svg",
                      width: 16,
                      height: 16,
                    ),
                    SizedBox(width: 4,),
                    SvgPicture.asset(
                      "assets/icon/star_icon.svg",
                      width: 16,
                      height: 16,
                    ),
                    SizedBox(width: 4,),
                    SvgPicture.asset(
                      "assets/icon/star_icon.svg",
                      width: 16,
                      height: 16,
                    ),
                    SizedBox(width: 4,),
                    SvgPicture.asset(
                      "assets/icon/star_icon.svg",
                      width: 16,
                      height: 16,
                    ),
                    SizedBox(width: 4,),
                    SvgPicture.asset(
                      "assets/icon/star_icon.svg",
                      width: 16,
                      height: 16,
                    ),
                    SizedBox(width: 8,),
                    Text(
                      '3.0',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
