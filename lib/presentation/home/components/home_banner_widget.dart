import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeBannerWidget extends StatelessWidget {
  List banner;
  HomeBannerWidget({Key? key, required this.banner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      width: size.width - 40,
      height: 120,
      child : ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          "${banner[0].bannerImageUrl}",
          fit: BoxFit.cover,
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Image.asset(
              'assets/images/dummy.jpg',
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
