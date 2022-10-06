import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../domain/model/post.dart';
import '../../profile/other_profile.dart';

class DetailMakerWidget extends StatelessWidget {
  Post post;
  DetailMakerWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => OtherProfilePage(
              profileId: post.userId.underId,
              profileName: '${post.userId.userNickname}', chatButton: false,
            ),
          ),
        );
      },
      child: Container(
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
        height: 64,
        padding: EdgeInsets.fromLTRB(19.5, 16.5, 20.5, 15.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(100.0),
                  child: Image(
                    image: CachedNetworkImageProvider('${post.userId.userProfileImg}'),
                    width: 32.0,
                    height: 32.0,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context,
                        Object exception,
                        StackTrace? stackTrace) {
                      return Image.asset(
                        'assets/images/profile_null_image.png',
                        width: 32.0,
                        height: 32.0,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                SizedBox(
                  width : 16,
                ),
                Text(
                  '${post.userId.userNickname}',
                  style: TextStyle(
                    color: Color(0xff000000),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Container(
              width: 32,
              height: 32,
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
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    "assets/icon/right_arrow_icon.svg",
                    width: 16,
                    height: 16,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => OtherProfilePage(
                          profileId: post.userId.underId,
                          profileName: '${post.userId.userNickname}', chatButton: false,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
