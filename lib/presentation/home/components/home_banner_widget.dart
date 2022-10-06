import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/util.dart';


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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("banner 길이 : ${widget.banner}");
    final Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      width: size.width,
      height: 140,
      child: widget.banner.length != 1 ? Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: widget.banner.length < 2 ? false : true, // 자동재생 여부
              height: 140,
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
                        image: CachedNetworkImageProvider(item.bannerImageUrl),
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
      ) : Stack(
        children: [
          GestureDetector(
            onTap: () {
              print("클릭");
              _launchURL(widget.banner[0]['connect_url']);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image : DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(widget.banner[0]['banner_image_url']),
                ),
              ),
            ),
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
                  '1/1',
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
  }
}

