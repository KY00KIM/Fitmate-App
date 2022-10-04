import 'package:fitmate/domain/model/fitnesscenter.dart';
import 'package:fitmate/presentation/login/login.dart';
import 'package:fitmate/ui/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

import '../../../domain/util.dart';
import '../../fitness_center/fitness_center.dart';

/*
class HomeTownWidget extends StatefulWidget {
  FitnessCenter fitness_center;

  HomeTownWidget({Key? key, required this.fitness_center}) : super(key: key);

  @override
  State<HomeTownWidget> createState() => _HomeTownWidgetState();
}

class _HomeTownWidgetState extends State<HomeTownWidget> {
  int point = 0;

  List<Marker> _homeTownMarkers = [];

  Future<bool> setMarkers() async {
    _homeTownMarkers.add(Marker(
      markerId: 'id',
      position: LatLng(widget.fitness_center.fitnessLatitude, widget.fitness_center.fitnessLongitude),
      alpha: 1,
      //captionOffset: 30,
      icon: await OverlayImage.fromAssetImage(assetName: 'assets/icon/map_pin.png', /*size: Size(36, 36)*/),
      anchor: AnchorPoint(0.5, 0.7),
      width: 90,
      height: 90,));

    return true;
  }

  @override
  Widget build(BuildContext context) {
    print("타운 가즈아");
    if(widget.fitness_center.reviews.length != 0) {
      for(int i = 0; i< widget.fitness_center.reviews.length; i++) {
        point += widget.fitness_center.reviews[i].centerRating;
      }
      point = point ~/ widget.fitness_center.reviews.length;
    }

    return FutureBuilder(
        future: setMarkers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                if(visit == true) {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (BuildContext context) =>
                          LoginPage()), (route) => false);

                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FitnessCenterPage(fitnessId: '${widget.fitness_center.underId}',)));

                }
              },
              child: Container(
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
                      color: whiteTheme,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: NaverMap(
                          initLocationTrackingMode: LocationTrackingMode.None,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(widget.fitness_center.fitnessLatitude, widget.fitness_center.fitnessLongitude),
                            zoom: 17,
                          ),
                          //onMapCreated: onMapCreated,
                          mapType: MapType.Basic,
                          markers: _homeTownMarkers,
                          //initLocationTrackingMode: _trackingMode,
                          locationButtonEnable: false,
                          indoorEnable: true,
                        ),
                      ),
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
                                '${widget.fitness_center.centerName}',
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
                                    '${widget.fitness_center.centerAddress}',
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
                                point >= 1 ? "assets/icon/color_star_icon.svg" : "assets/icon/star_icon.svg",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(width: 4,),
                              SvgPicture.asset(
                                point >= 2 ? "assets/icon/color_star_icon.svg" : "assets/icon/star_icon.svg",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(width: 4,),
                              SvgPicture.asset(
                                point >= 3 ? "assets/icon/color_star_icon.svg" : "assets/icon/star_icon.svg",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(width: 4,),
                              SvgPicture.asset(
                                point >= 4 ? "assets/icon/color_star_icon.svg" : "assets/icon/star_icon.svg",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(width: 4,),
                              SvgPicture.asset(
                                point >= 5 ? "assets/icon/color_star_icon.svg" : "assets/icon/star_icon.svg",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(width: 8,),
                              Text(
                                '${point}.0',
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
                                          '리뷰 ${widget.fitness_center.reviews.length}',
                                          //'리뷰 0',
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
              ),
            );
          }
          return Center(child: CircularProgressIndicator(),);});
  }
}

 */

class HomeTownWidget extends StatelessWidget {
  FitnessCenter fitness_center;

  HomeTownWidget({Key? key, required this.fitness_center}) : super(key: key);

  int point = 0;

  List<Marker> _homeTownMarkers = [];

  Future<bool> setMarkers() async {
    _homeTownMarkers.add(Marker(
      markerId: 'id',
      position: LatLng(fitness_center.fitnessLatitude, fitness_center.fitnessLongitude),
      alpha: 1,
      //captionOffset: 30,
      icon: await OverlayImage.fromAssetImage(assetName: 'assets/icon/map_pin.png', /*size: Size(36, 36)*/),
      anchor: AnchorPoint(0.5, 0.7),
      width: 90,
      height: 90,));

    return true;
  }

  @override
  Widget build(BuildContext context) {
    print("타운 가즈아");
    if(fitness_center.reviews.length != 0) {
      for(int i = 0; i< fitness_center.reviews.length; i++) {
        point += fitness_center.reviews[i].centerRating;
      }
      point = point ~/ fitness_center.reviews.length;
    }

    return FutureBuilder(
        future: setMarkers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                if(visit == true) {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (BuildContext context) =>
                          LoginPage()), (route) => false);

                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FitnessCenterPage(fitnessId: '${fitness_center.underId}',)));

                }
              },
              child: Container(
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
                      color: whiteTheme,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: NaverMap(
                          initLocationTrackingMode: LocationTrackingMode.None,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(fitness_center.fitnessLatitude, fitness_center.fitnessLongitude),
                            zoom: 17,
                          ),
                          //onMapCreated: onMapCreated,
                          mapType: MapType.Basic,
                          markers: _homeTownMarkers,
                          useSurface: kReleaseMode,
                          //initLocationTrackingMode: _trackingMode,
                          locationButtonEnable: false,
                          indoorEnable: true,
                        ),
                      ),
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
                                point >= 1 ? "assets/icon/color_star_icon.svg" : "assets/icon/star_icon.svg",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(width: 4,),
                              SvgPicture.asset(
                                point >= 2 ? "assets/icon/color_star_icon.svg" : "assets/icon/star_icon.svg",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(width: 4,),
                              SvgPicture.asset(
                                point >= 3 ? "assets/icon/color_star_icon.svg" : "assets/icon/star_icon.svg",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(width: 4,),
                              SvgPicture.asset(
                                point >= 4 ? "assets/icon/color_star_icon.svg" : "assets/icon/star_icon.svg",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(width: 4,),
                              SvgPicture.asset(
                                point >= 5 ? "assets/icon/color_star_icon.svg" : "assets/icon/star_icon.svg",
                                width: 16,
                                height: 16,
                              ),
                              SizedBox(width: 8,),
                              Text(
                                '${point}.0',
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
                                          '리뷰 ${fitness_center.reviews.length}',
                                          //'리뷰 0',
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
              ),
            );
          }
          return Center(child: CircularProgressIndicator(),);});
  }
}
