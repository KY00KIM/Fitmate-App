import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeBannerWidget extends StatefulWidget {
  List banner;

  HomeBannerWidget({Key? key, required this.banner}) : super(key: key);

  @override
  State<HomeBannerWidget> createState() => _HomeBannerWidget();
}

class _HomeBannerWidget extends State<HomeBannerWidget>{
  int page = 1;

  _launchURL(String url) async {
    final openUrl = Uri.parse('${url}');
    if (await canLaunchUrl(openUrl)) {
      launchUrl(openUrl, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 120,
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: widget.banner.length < 2 ? false : true, // 자동재생 여부
              height: 120,
              viewportFraction: 1,
              autoPlayAnimationDuration: Duration(milliseconds : 200),
              onPageChanged : (index, reason) {
                setState((){
                  page = index + 1;
                });
              }
            ),
            items : widget.banner.map((item) {
              print("item : ${item.bannerImageUrl}");
              return Builder(builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    print("클릭");
                    _launchURL(item.connectUrl);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image : DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(item.bannerImageUrl),
                      ),
                    ),
                  ),
                );
              });
            }).toList(),
          ),
          Positioned(
            right: 12,
            bottom : 12,
            child: Container(
              width: 44,
              height: 24,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${page}/${widget.banner.length}',
                  style: TextStyle(
                    color: Color(0xFFffffff),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    /*
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
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: true, //자동재생 여부
          ),
          items : banner.map((item) {
            return Builder(builder: (BuildContext context) {
              return Container();
            });
          }).toList(),
        ),
        /*
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

         */
      ),
    );

     */
  }
}
