import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeBannerWidget extends StatelessWidget {
  List banner;
  HomeBannerWidget({Key? key, required this.banner}) : super(key: key);

  _launchURL(String url) async {
    final openUrl = Uri.parse('${url}');
    if (await canLaunchUrl(openUrl)) {
      launchUrl(openUrl, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        print("클릭");
        _launchURL(banner[0].connectUrl);
      },
      child: Container(
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
      ),
    );
  }
}
