import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../domain/model/post.dart';

class DetailImageWidget extends StatelessWidget {
  Post post;
  DetailImageWidget({Key? key, required this.post}) : super(key: key);

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
      padding: EdgeInsets.fromLTRB(20, 20.5, 20, 32),
      child: Column(
        children: [
          Image(
            image: CachedNetworkImageProvider('${post.postImg}'),
            fit: BoxFit.fitWidth,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Image.asset(
                'assets/images/dummy.jpg',
                fit: BoxFit.fitWidth,
              );
            },
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 50,
                  text: TextSpan(
                    text: '${post.postMainText}',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
