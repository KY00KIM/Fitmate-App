import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../domain/model/posts.dart';
import '../../detail.dart';

class PostWidget extends StatelessWidget {
  final Posts posts;

  const PostWidget({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.zero,
          minimumSize: Size(size.width, 144),
          maximumSize: Size(size.width, 144),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(0),
          ),
          primary: Color(0xFF22232A)
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailMachingPage('${posts.underId}')));
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    "${posts.postImg}",
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return Image.asset(
                        'assets/images/dummy.jpg',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  height: 100.0,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width - 155,
                            child: Row(
                              children: [
                                Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    strutStyle: StrutStyle(fontSize: 16),
                                    text: TextSpan(
                                      text: '${posts.postTitle}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Container(
                            width: size.width - 155,
                            child: Row(
                              children: [
                                Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    strutStyle: StrutStyle(fontSize: 16),
                                    text: TextSpan(
                                      text: '${posts.promiseDate.toString().substring(5,7)}/${posts.promiseDate.toString().substring(8,10)}  |  ${posts.promiseLocation.centerName}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF757575),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.network(
                              //'${userImage[index]}',
                              '${posts.userId.userProfileImg}',
                              width: 25.0,
                              height: 25.0,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  'assets/images/profile_null_image.png',
                                  width: 25.0,
                                  height: 25.0,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: size.width - 190,
                            child: Row(
                              children: [
                                Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    strutStyle: StrutStyle(fontSize: 16),
                                    text: TextSpan(
                                      text: '${posts.userId.userNickname}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF757575),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 2,
              width: size.width - 40,
              color: Color(0xFF303037),
            ),
          ],
        ),
      ),
    );
  }
}
