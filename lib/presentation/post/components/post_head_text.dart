import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'dart:math' as math;

import '../../../data/post_api.dart';
import '../../../domain/util.dart';

class PostHeadTextWidget extends StatefulWidget {
  PostHeadTextWidget({Key? key}) : super(key: key);

  @override
  State<PostHeadTextWidget> createState() => _PostHeadTextWidget();
}

class _PostHeadTextWidget extends State<PostHeadTextWidget> {

  final _valueList = ['최신 순', '거리 순'];
  var _selectedVaue = '최신 순';

  final postApi = PostApi();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          Container(
            height: 40,
            width: size.width,
            // color: Colors.white,
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
                  "🏃🏻‍♂️️",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    // letterSpacing: 1,
                  ),
                  textAlign: TextAlign.start,
                ),
                /*
                Spacer(),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    icon: Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Transform.rotate(
                        angle: 90 * math.pi / 180,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFF000000),
                          size: 16,
                        ),
                      ),
                    ),
                    value: _selectedVaue,
                    items: _valueList.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) async {
                      if(value == '최신 순') sort = 'sort';
                      else sort = "distance";

                      context.loaderOverlay.show();
                      if(value != _selectedVaue)  {
                        setState(() {
                          _selectedVaue = value.toString();
                        });
                      } else {
                        setState(() {
                          _selectedVaue = value.toString();
                        });
                      }
                    },
                  ),
                ),

                 */
              ],
            ),
          ),
        ],
      ),
    );
  }
}
