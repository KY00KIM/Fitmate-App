import 'package:fitmate/domain/model/fitnesscenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../domain/util.dart';

class HomeTownWidget extends StatelessWidget {
  FitnessCenter fitness_center;
  HomeTownWidget({Key? key, required this.fitness_center}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("타운 가즈아");
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
                      '${fitness_center.centerName}',
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
                          '${fitness_center.centerAddress}',
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
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        print("zz");
                      },
                      child: Container(
                        width: 76,
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            width: 1,
                            color: Color(0xFFE8EAF6),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '리뷰 12',
                                style: TextStyle(
                                  color: Color(0xFF283593),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              SvgPicture.asset(
                                "assets/icon/right_arrow_icon.svg",
                                width: 12,
                                height: 12,
                                color: Color(0xFF283593),
                              )
                            ],
                          ),
                        ),
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
