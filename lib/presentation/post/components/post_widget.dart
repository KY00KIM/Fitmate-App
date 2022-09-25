import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../domain/model/post.dart';
import '../../../domain/util.dart';
import '../../detail/detail.dart';
import '../../login/login.dart';

class PostWidget extends StatelessWidget {
  final Post posts;

  const PostWidget({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    String? time = posts.promiseDate.toString().substring(11, 13);
    String slot = int.parse(time) > 12 ? '오후' : '오전';
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      width: size.width,
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
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero,
            minimumSize: Size(size.width, 100),
            maximumSize: Size(size.width, 100),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(8),
            ),
            primary: Color(0xFFF2F3F7)
        ),
        onPressed: () {
          if(visit == true) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (BuildContext context) =>
                    LoginPage()), (route) => false);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailMachingPage(post: posts,)));
          }
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image(
                  image: CachedNetworkImageProvider(
                    "${posts.postImg}",
                  ),
                  width: 68.0,
                  height: 68.0,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Image.asset(
                      'assets/images/dummy.jpg',
                      width: 68.0,
                      height: 68.0,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                /*
                child: Image.network(
                  "${posts.postImg}",
                  width: 68.0,
                  height: 68.0,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Image.asset(
                      'assets/images/dummy.jpg',
                      width: 68.0,
                      height: 68.0,
                      fit: BoxFit.cover,
                    );
                  },
                ),

                 */
              ),
              SizedBox(
                width: 16,
              ),
              Container(
                height: 68.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: size.width - 156,
                      child: Row(
                        children: [
                          Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              strutStyle: StrutStyle(fontSize: 16),
                              text: TextSpan(
                                text: '${posts.postTitle}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: size.width - 156,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            "assets/icon/dumbbell_icon.svg",
                            width: 12,
                            height: 12,
                          ),
                          SizedBox(width: 8,),
                          Flexible(
                            fit: FlexFit.tight,
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              text: TextSpan(
                                text: '${posts.promiseLocation.centerName}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6E7995),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8,),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icon/clock_icon.svg",
                                width: 12,
                                height: 12,
                              ),
                              SizedBox(width: 8,),
                              Text(
                                '${slot} ${int.parse(time) > 12 ? '${int.parse(time) - 12}' : '${int.parse(time)}'}시 ${posts.promiseDate.toString().substring(14, 16)}분',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6E7995),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Container(
                      width: size.width - 156,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${posts.promiseDate.toString().substring(0, 4)} ${posts.promiseDate.toString().substring(5, 7)} ${posts.promiseDate.toString().substring(8, 10)}',
                            style: TextStyle(
                              color: Color(0xFF6E7995),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
