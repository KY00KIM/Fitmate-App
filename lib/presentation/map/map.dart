import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

import 'package:flutter/foundation.dart';

import '../../domain/util.dart';
import '../../ui/bar_widget.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin{
  Completer<NaverMapController> _controller = Completer();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  MapType _mapType = MapType.Basic;
  List<Marker> _markers = [];
  final barWidget = BarWidget();

  late AnimationController controller;
  double _height = 0;

  @override
  void initState() {
    super.initState();
    _markers.add(Marker(
        markerId: 'id',
        position: LatLng(37.545768699999996, 126.72145169999999),
        captionText: "커스텀 아이콘",
        captionColor: Colors.indigo,
        captionTextSize: 20.0,
        alpha: 0.8,
        captionOffset: 30,
        icon: null,
        anchor: AnchorPoint(0.3, 1),
        width: 45,
        height: 45,
        infoWindow: '인포 윈도우',
        onMarkerTab: null));
    controller = BottomSheet.createAnimationController(this);
    controller.duration = Duration(seconds: 3);
    //controller.lowerBound;
  }

  // Text('${snapshot.data?[index]['post_title']}');
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    print(UserData);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      key: scaffoldKey,
      bottomNavigationBar: barWidget.bottomNavigationBar(context, 3),
      body: Stack(
        children: <Widget>[
          NaverMap(
            useSurface: kReleaseMode,
            initLocationTrackingMode: LocationTrackingMode.Follow,
            initialCameraPosition: CameraPosition(
              target: LatLng(37.566570, 126.978442),
              zoom: 17,
            ),
            onMapCreated: onMapCreated,
            mapType: _mapType,
            markers: _markers,
            //initLocationTrackingMode: _trackingMode,
            locationButtonEnable: true,
            indoorEnable: true,
            onCameraChange: _onCameraChange,
            onCameraIdle: _onCameraIdle,
            onMapTap: _onMapTap,
            onMapLongTap: _onMapLongTap,
            onMapDoubleTap: _onMapDoubleTap,
            onMapTwoFingerTap: _onMapTwoFingerTap,
            //onSymbolTap: _onMarkerTap,
            //maxZoom: 17,
            minZoom: 13,  //최대 지도 범위
          ),
          Positioned(
            right: 20,
            top: 100,
            child: Container(
              padding: EdgeInsets.all(8),
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Color(0xFF3F51B5),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(63, 81, 181, 0.5),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SvgPicture.asset(
                'assets/icon/map_location_icon.svg',
                fit: BoxFit.cover,
              ),
            )
            /*
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF3F51B5),
                maximumSize: Size(40, 40),
                minimumSize: Size(40, 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              ),
              onPressed: () {

              },
              child: SvgPicture.asset(
                'assets/icon/map_location_icon.svg',
                width: 34,
                height: 34,
              ),

             */
            ),
          Positioned(
              bottom : 80,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _height=300;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  width: size.width - 40,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFF3F51B5),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(63, 81, 181, 0.5),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '이 지역 피트니스 클럽',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFffffff)
                      ),
                    ),
                  ),
                ),
              )
              /*
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(size.width - 40, 52),
                  maximumSize: Size(size.width - 40, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 4,
                  primary: Color(0xFF3F51B5),
                  shadowColor: Color.fromRGBO(63, 81, 181, 0.5),
                ),
                onPressed: () async {

                },
                child: Text(
                  '이 지역 피트니스 클럽',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

               */
            /*
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF3F51B5),
                maximumSize: Size(40, 40),
                minimumSize: Size(40, 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              ),
              onPressed: () {

              },
              child: SvgPicture.asset(
                'assets/icon/map_location_icon.svg',
                width: 34,
                height: 34,
              ),

             */
          ),
          //_trackingModeSelector(),
        ],
      ),
      bottomSheet: BottomSheet(
        animationController: controller,
        enableDrag: true,
        builder: (BuildContext context) {
          return Container(
            height: 0,
          );
        },
        onClosing: () {  },
      ),
    );
  }

  _onMapTap(LatLng position) async {
    //지도 터치 효과
    /*
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text('[onTap] lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));

     */
  }

  _onMapLongTap(LatLng position) {
    /*
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '[onLongTap] lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));

     */
  }

  _onMapDoubleTap(LatLng position) {
    /*
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '[onDoubleTap] lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));

     */
  }

  _onMapTwoFingerTap(LatLng position) {
    /*
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '[onTwoFingerTap] lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));

     */
  }

  _onSymbolTap(LatLng position, String caption) {
    /*
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '[onSymbolTap] caption: $caption, lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));

     */
  }

  _mapTypeSelector() {
    return SizedBox(
      height: kToolbarHeight,
      child: ListView.separated(
        itemCount: MapType.values.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => SizedBox(
          width: 12,
        ),
        itemBuilder: (_, index) {
          final type = MapType.values[index];
          String title;
          switch (type) {
            case MapType.Basic:
              title = '기본';
              break;
            case MapType.Navi:
              title = '내비';
              break;
            case MapType.Satellite:
              title = '위성';
              break;
            case MapType.Hybrid:
              title = '위성혼합';
              break;
            case MapType.Terrain:
              title = '지형도';
              break;
          }

          return GestureDetector(
            onTap: () => _onTapTypeSelector(type),
            child: Container(
              decoration: BoxDecoration(
                  color: _mapType == type ? Color(0xFF2975CF) : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)]),
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                      color: _mapType == type ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _trackingModeSelector() {
    return Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: _onTapTakeSnapShot,
        child: Container(
          margin: EdgeInsets.only(right: 16, bottom: 48),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                )
              ]),
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.photo_camera,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 지도 생성 완료시
  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  /// 지도 유형 선택시
  void _onTapTypeSelector(MapType type) async {
    if (_mapType != type) {
      setState(() {
        _mapType = type;
      });
    }
  }

  /// my location button
  // void _onTapLocation() async {
  //   final controller = await _controller.future;
  //   controller.setLocationTrackingMode(LocationTrackingMode.Follow);
  // }

  void _onCameraChange(
      LatLng? latLng, CameraChangeReason? reason, bool? isAnimated) {
    print('카메라 움직임 >>> 위치 : ${latLng!.latitude}, ${latLng.longitude}'
        '\n원인: $reason'
        '\n에니메이션 여부: $isAnimated');
  }

  void _onCameraIdle() {
    print('카메라 움직임 멈춤');
  }

  /// 지도 스냅샷

  void _onTapTakeSnapShot() async {
    print("여기 클릭");
    final controller = await _controller.future;
    controller.takeSnapshot((path) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: path != null
                  ? Image.file(
                      File(path),
                    )
                  : Text('path is null!'),
              titlePadding: EdgeInsets.zero,
            );
          });
    });
  }
}
