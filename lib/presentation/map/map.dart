import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmate/presentation/fitness_center/fitness_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/android.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../domain/util.dart';
import '../../ui/bar_widget.dart';
import '../../ui/colors.dart';
import '../fitness_map/fitness_map.dart';
import '../login/login.dart';

// map 전체보기 / 게시물 보기

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  Completer<NaverMapController> _controller = Completer();
  late NaverMapController navarMapController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  MapType _mapType = MapType.Basic;
  List<Marker> markers = [];
  final barWidget = BarWidget();
  int _tabIconIndexSelected = 0;

  late AnimationController aniController;
  List pins = [];
  bool zoomOut = false;
  var alignment = Alignment.bottomCenter;
  double alignHeight = 30;
  String alignCenterName = '';
  String alignCenterAddress = '';
  String alignCenterId = '';
  String alignCenterX = '';
  String alignCenterY = '';

  String region_1depth_name = "";
  String region_2depth_name = "";
  String region_3depth_name = '';

  int MarkerTapWidgetHeight = 0;
  bool bottomSheet = false;
  bool seePost = false;
  bool markerClick = false;

  @override
  void initState() {
    super.initState();

    aniController = BottomSheet.createAnimationController(this);
    aniController.duration = Duration(seconds: 3);
    print("map init");
  }

  //새로고침 방지
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  // Text('${snapshot.data?[index]['post_title']}');
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    print("맵 빌드 : ${markers}");
    super.build(context);
    return Scaffold(
      extendBody: true,
      key: scaffoldKey,
      //bottomNavigationBar: barWidget.bottomNavigationBar(context, 3),
      body: Builder(builder: (context) {
        return Stack(
          children: <Widget>[
            NaverMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(37.566570, 126.978442),
                zoom: 17,
              ),
              //liteModeEnable: true,
              //useSurface: kReleaseMode,
              markers: markers,
              onMapCreated: onMapCreated,
              mapType: _mapType,
              initLocationTrackingMode: LocationTrackingMode.Follow,
              locationButtonEnable: false,
              indoorEnable: true,
              onCameraChange: _onCameraChange,
              onCameraIdle: _onCameraIdle,
              onMapTap: _onMapTap,
              onMapLongTap: _onMapLongTap,
              onMapDoubleTap: _onMapDoubleTap,
              onMapTwoFingerTap: _onMapTwoFingerTap,
              //onSymbolTap: _onSymbolTap,
              minZoom: 11,
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 50),
                  width: size.width - 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: const Color(0xFFffffff),
                    boxShadow: [
                      const BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  /*
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '$region_1depth_name',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF000000)
                              ),
                            ),
                            SvgPicture.asset(
                              "assets/icon/right_arrow_icon.svg",
                              width: 16,
                              height: 16,
                              color: const Color(0xFFCED3EA),
                            ),
                            Text(
                              '$region_2depth_name',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF000000)
                              ),
                            ),
                            SvgPicture.asset(
                              "assets/icon/right_arrow_icon.svg",
                              width: 16,
                              height: 16,
                              color: const Color(0xFFCED3EA),
                            ),
                            Text(
                              '$region_3depth_name',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF000000)
                              ),
                            ),
                          ],
                        ),
                      ),
                       */
                  child: FlutterToggleTab(
                    //width: (size.width - 40) / 2,
                    width: 90,
                    height: 40,
                    borderRadius: 15,
                    selectedIndex: _tabIconIndexSelected,
                    selectedTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                    unSelectedTextStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                    selectedBackgroundColors: [
                      Color(0xFF3F51B5),
                    ],
                    labels: ['전체보기', '게시물보기'],
                    //icons: _listIconTabToggle,
                    selectedLabelIndex: (index) async {
                      _tabIconIndexSelected = index;
                      LatLngBounds dontNow =
                          await navarMapController.getVisibleRegion();

                      var cameraPosition =
                          await navarMapController.getCameraPosition();
                      print("camera position : ${cameraPosition.target}");
                      print("camera zoom : ${cameraPosition.zoom}");

                      print("north : ${dontNow.northeast}");
                      print("north latitude : ${dontNow.northeast.latitude}");
                      print("south : ${dontNow.southwest}");
                      //print("first_longitude=${dontNow.southwest.longitude}&first_latitude=${dontNow.southwest.latitude}&second_longitude=${dontNow.northeast.longitude}&second_latitude=${dontNow.northeast.latitude}");
                      //13
                      http.Response response;
                      var resBody;

                      if (cameraPosition.zoom < 13) {
                        zoomOut = true;
                        response = await http.get(
                          Uri.parse(
                              "https://fitmate.co.kr/v2/fitnesscenters/zoom"),
                          headers: {
                            "Authorization": "bearer $IdToken",
                            "Content-Type": "application/json; charset=UTF-8"
                          },
                        );
                        resBody = jsonDecode(utf8.decode(response.bodyBytes));

                        if (response.statusCode != 201 &&
                            resBody["error"]["code"] ==
                                "auth/id-token-expired") {
                          IdToken = (await FirebaseAuth.instance.currentUser
                                  ?.getIdTokenResult(true))!
                              .token
                              .toString();

                          response = await http.get(
                            Uri.parse(
                                "https://fitmate.co.kr/v2/fitnesscenters/zoom"),
                            headers: {
                              "Authorization": "bearer $IdToken",
                              "Content-Type": "application/json; charset=UTF-8"
                            },
                          );
                          resBody = jsonDecode(utf8.decode(response.bodyBytes));
                        }

                        log("res body : $resBody");

                        markers.clear();

                        for (int i = 0; i < resBody['data'].length; i++) {
                          if (resBody['data'][i]['location'][0]
                                      ['location_latitude'] >=
                                  dontNow.southwest.latitude &&
                              resBody['data'][i]['location'][0]
                                      ['location_latitude'] <=
                                  dontNow.northeast.latitude &&
                              resBody['data'][i]['location'][0]
                                      ['location_longitude'] >=
                                  dontNow.southwest.longitude &&
                              resBody['data'][i]['location'][0]
                                      ['location_longitude'] <=
                                  dontNow.northeast.longitude) {
                            markers.add(Marker(
                              markerId: '${resBody['data'][i]['_id']}',
                              position: LatLng(
                                  resBody['data'][i]['location'][0]
                                      ['location_latitude'],
                                  resBody['data'][i]['location'][0]
                                      ['location_longitude']),
                              alpha: 1,
                              captionOffset: -67,
                              captionText: '${resBody['data'][i]['count']}',
                              captionColor: Colors.white,
                              icon: await OverlayImage.fromAssetImage(
                                assetName:
                                    'assets/icon/non_icon_map_pin.png', /*size: Size(36, 36)*/
                              ),
                              anchor: AnchorPoint(0.5, 0.7),
                              width: 100,
                              height: 100,
                            ));
                          }
                        }
                      } else {
                        zoomOut = false;
                        if (visit == true) {
                          response = await http.get(
                            Uri.parse(
                                "https://fitmate.co.kr/v2/visitor/fitnesscenter?page=1&limit=200&first_longitude=${dontNow.southwest.longitude}&first_latitude=${dontNow.southwest.latitude}&second_longitude=${dontNow.northeast.longitude}&second_latitude=${dontNow.northeast.latitude}"),
                          );
                          resBody = jsonDecode(utf8.decode(response.bodyBytes));
                          print("visit resbody : $resBody");
                        } else {
                          response = await http.get(
                            Uri.parse(
                                "https://fitmate.co.kr/v2/fitnesscenters?page=1&limit=200&first_longitude=${dontNow.southwest.longitude}&first_latitude=${dontNow.southwest.latitude}&second_longitude=${dontNow.northeast.longitude}&second_latitude=${dontNow.northeast.latitude}"),
                            headers: {
                              "Authorization": "bearer $IdToken",
                              "Content-Type": "application/json; charset=UTF-8"
                            },
                          );
                          resBody = jsonDecode(utf8.decode(response.bodyBytes));
                          if (response.statusCode != 200 &&
                              resBody["error"]["code"] ==
                                  "auth/id-token-expired") {
                            IdToken = (await FirebaseAuth.instance.currentUser
                                    ?.getIdTokenResult(true))!
                                .token
                                .toString();

                            response = await http.get(
                              Uri.parse(
                                  "https://fitmate.co.kr/v2/fitnesscenters?page=1&limit=50&first_longitude=${dontNow.southwest.longitude}&first_latitude=${dontNow.southwest.latitude}&second_longitude=${dontNow.southwest.longitude}&second_latitude=${dontNow.southwest.latitude}"),
                              headers: {
                                "Authorization": "bearer $IdToken",
                                "Content-Type":
                                    "application/json; charset=UTF-8"
                              },
                            );
                            resBody =
                                jsonDecode(utf8.decode(response.bodyBytes));
                          }
                        }
                        pins = resBody['data']['docs'];

                        log("res body : $resBody");

                        markers.clear();
                        print("pin 개수 : ${resBody['data']['docs'].length}");

                        for (int i = 0;
                            i < resBody['data']['docs'].length;
                            i++) {
                          if (_tabIconIndexSelected == 1 &&
                              resBody['data']['docs'][i]['posts'].length != 0) {
                            markers.add(Marker(
                                markerId:
                                    '${resBody['data']['docs'][i]['_id']}->${resBody['data']['docs'][i]['center_name']}->${resBody['data']['docs'][i]['center_address']}->${resBody['data']['docs'][i]['fitness_longitude']}->${resBody['data']['docs'][i]['fitness_latitude']}',
                                position: LatLng(
                                    resBody['data']['docs'][i]
                                        ['fitness_latitude'],
                                    resBody['data']['docs'][i]
                                        ['fitness_longitude']),
                                alpha: 1,
                                icon: resBody['data']['docs'][i]['posts']
                                            .length ==
                                        0
                                    ? await OverlayImage.fromAssetImage(
                                        assetName:
                                            'assets/icon/map_pin.png', /*size: Size(44, 44)*/
                                      )
                                    : await OverlayImage.fromAssetImage(
                                        assetName:
                                            'assets/icon/Ping.png', /*size: Size(64, 64)*/
                                      ),
                                anchor: AnchorPoint(0.5, 0.7),
                                width: resBody['data']['docs'][i]['posts']
                                            .length ==
                                        0
                                    ? 70
                                    : 90,
                                height: resBody['data']['docs'][i]['posts']
                                            .length ==
                                        0
                                    ? 70
                                    : 90,
                                onMarkerTab: (Marker? a, Map b) async {
                                  print("여기다!");

                                  print("a : $a");
                                  print("b : $b");
                                  var temp = a?.markerId.split('->');
                                  log("temp0 : ${temp![0]}");
                                  log("temp1 : ${temp[1]}");
                                  log("temp2 : ${temp[2]}");
                                  log("temp3 : ${temp[3]}");
                                  log("temp4 : ${temp[4]}");

                                  setState(() {
                                    alignment = Alignment.center;
                                    alignHeight = 80;
                                    alignCenterId = temp[0];
                                    alignCenterName = temp[1];
                                    alignCenterAddress = temp[2];
                                    alignCenterY = temp[3];
                                    alignCenterX = temp[4];
                                    markerClick = true;
                                  });
                                }));
                          } else if (_tabIconIndexSelected == 0) {
                            markers.add(Marker(
                                markerId:
                                    '${resBody['data']['docs'][i]['_id']}->${resBody['data']['docs'][i]['center_name']}->${resBody['data']['docs'][i]['center_address']}->${resBody['data']['docs'][i]['fitness_longitude']}->${resBody['data']['docs'][i]['fitness_latitude']}',
                                position: LatLng(
                                    resBody['data']['docs'][i]
                                        ['fitness_latitude'],
                                    resBody['data']['docs'][i]
                                        ['fitness_longitude']),
                                alpha: 1,
                                icon: resBody['data']['docs'][i]['posts']
                                            .length ==
                                        0
                                    ? await OverlayImage.fromAssetImage(
                                        assetName:
                                            'assets/icon/map_pin.png', /*size: Size(44, 44)*/
                                      )
                                    : await OverlayImage.fromAssetImage(
                                        assetName:
                                            'assets/icon/Ping.png', /*size: Size(64, 64)*/
                                      ),
                                anchor: AnchorPoint(0.5, 0.7),
                                width: resBody['data']['docs'][i]['posts']
                                            .length ==
                                        0
                                    ? 70
                                    : 90,
                                height: resBody['data']['docs'][i]['posts']
                                            .length ==
                                        0
                                    ? 70
                                    : 90,
                                onMarkerTab: (Marker? a, Map b) async {
                                  print("여기다!");

                                  print("a : $a");
                                  print("b : $b");
                                  var temp = a?.markerId.split('->');
                                  log("temp0 : ${temp![0]}");
                                  log("temp1 : ${temp[1]}");
                                  log("temp2 : ${temp[2]}");
                                  log("temp3 : ${temp[3]}");
                                  log("temp4 : ${temp[4]}");

                                  setState(() {
                                    alignment = Alignment.center;
                                    alignHeight = 80;
                                    alignCenterId = temp[0];
                                    alignCenterName = temp[1];
                                    alignCenterAddress = temp[2];
                                    alignCenterY = temp[3];
                                    alignCenterX = temp[4];
                                    markerClick = true;
                                  });
                                }));
                          }
                        }
                      }
                      setState(() {});
                      print("tabar selected : $_tabIconIndexSelected");
                    },
                    marginSelected:
                        EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  ),
                )),
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    _onTapLocation();
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 110, 20, 0),
                    padding: const EdgeInsets.all(8),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xFF3F51B5),
                      boxShadow: [
                        const BoxShadow(
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
            AnimatedAlign(
              duration: Duration(milliseconds: 100),
              alignment: alignment,
              child: GestureDetector(
                onTap: () {
                  if (visit == true) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginPage()),
                        (route) => false);
                  } else {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            FitnessCenterPage(fitnessId: '${alignCenterId}'),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: whiteTheme,
                    boxShadow: [
                      const BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  margin: EdgeInsets.only(top: 600),
                  height: alignHeight,
                  width: size.width - 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${alignCenterName}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: 28,
                            height: 28,
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
                                  "assets/icon/map_icon.svg",
                                  width: 16,
                                  height: 16,
                                ),
                                onPressed: () async {
                                  if (visit == true) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                LoginPage()),
                                        (route) => false);
                                  } else {
                                    await Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            FitnessMapPage(
                                          x: double.parse(alignCenterX),
                                          y: double.parse(alignCenterY),
                                          fitnessName: '${alignCenterName}',
                                          fitnessAddress:
                                              '${alignCenterAddress}',
                                        ),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Container(
                            width: 28,
                            height: 28,
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
                                  if (visit == true) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                LoginPage()),
                                        (route) => false);
                                  } else {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            FitnessCenterPage(
                                                fitnessId: '${alignCenterId}'),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              text: TextSpan(
                                text: '${alignCenterAddress}',
                                style: TextStyle(
                                  color: Color(0xFF6E7995),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  print("클릭");
                  bottomSheet = true;
                  showBottomSheet(
                    backgroundColor: whiteTheme,
                    context: context,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16))),
                    builder: (context) => DraggableScrollableSheet(
                      initialChildSize: 0.4,
                      minChildSize: 0.2,
                      maxChildSize: 0.968,
                      expand: false,
                      builder: (_, controller) => Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                          color: whiteTheme,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(55, 84, 170, 0.1),
                              spreadRadius: 5,
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.fromLTRB(
                            zoomOut ? 0 : 20, (Platform.isIOS) ? 40 : 10, 0, 0),
                        child: zoomOut
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          color: Color(0xFFD1D9E6),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: Text(
                                      '헬스장 정보를 보시려면 해당 지역으로 확대해주세요!',
                                      style: TextStyle(
                                          color: Color(0xFF6E7995),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 20),
                                        width: 40,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          color: Color(0xFFD1D9E6),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 28,
                                  ),
                                  Text(
                                    '이 지역 피트니스 클럽 ${pins.length}',
                                    style: TextStyle(
                                        color: Color(0xFF6E7995),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      controller: controller,
                                      itemCount: pins.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (visit == true) {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          LoginPage()),
                                                  (route) => false);
                                            } else {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context,
                                                          animation,
                                                          secondaryAnimation) =>
                                                      FitnessCenterPage(
                                                          fitnessId:
                                                              '${pins[index]["_id"]}'),
                                                  transitionDuration:
                                                      Duration.zero,
                                                  reverseTransitionDuration:
                                                      Duration.zero,
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 16, 20, 16),
                                            height: 80,
                                            width: size.width,
                                            color: whiteTheme,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      pins[index]['center_name']
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF000000),
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      width: 28,
                                                      height: 28,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color:
                                                            Color(0xFFF2F3F7),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color(
                                                                0xFFffffff),
                                                            spreadRadius: 2,
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(-2, -2),
                                                          ),
                                                          BoxShadow(
                                                            color:
                                                                Color.fromRGBO(
                                                                    55,
                                                                    84,
                                                                    170,
                                                                    0.1),
                                                            spreadRadius: 2,
                                                            blurRadius: 2,
                                                            offset:
                                                                Offset(2, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Theme(
                                                        data: ThemeData(
                                                          splashColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                        ),
                                                        child: IconButton(
                                                          icon:
                                                              SvgPicture.asset(
                                                            "assets/icon/map_icon.svg",
                                                            width: 16,
                                                            height: 16,
                                                          ),
                                                          onPressed: () async {
                                                            if (visit == true) {
                                                              Navigator.pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          LoginPage()),
                                                                  (route) =>
                                                                      false);
                                                            } else {
                                                              await Navigator
                                                                  .push(
                                                                context,
                                                                PageRouteBuilder(
                                                                  pageBuilder: (context,
                                                                          animation,
                                                                          secondaryAnimation) =>
                                                                      FitnessMapPage(
                                                                    x: pins[index]
                                                                        [
                                                                        'fitness_latitude'],
                                                                    y: pins[index]
                                                                        [
                                                                        'fitness_longitude'],
                                                                    fitnessName:
                                                                        '${pins[index]['center_name'].toString()}',
                                                                    fitnessAddress:
                                                                        '${pins[index]['center_address'].toString()}',
                                                                  ),
                                                                  transitionDuration:
                                                                      Duration
                                                                          .zero,
                                                                  reverseTransitionDuration:
                                                                      Duration
                                                                          .zero,
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 16,
                                                    ),
                                                    Container(
                                                      width: 28,
                                                      height: 28,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color:
                                                            Color(0xFFF2F3F7),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color(
                                                                0xFFffffff),
                                                            spreadRadius: 2,
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(-2, -2),
                                                          ),
                                                          BoxShadow(
                                                            color:
                                                                Color.fromRGBO(
                                                                    55,
                                                                    84,
                                                                    170,
                                                                    0.1),
                                                            spreadRadius: 2,
                                                            blurRadius: 2,
                                                            offset:
                                                                Offset(2, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Theme(
                                                        data: ThemeData(
                                                          splashColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                        ),
                                                        child: IconButton(
                                                          icon:
                                                              SvgPicture.asset(
                                                            "assets/icon/right_arrow_icon.svg",
                                                            width: 16,
                                                            height: 16,
                                                          ),
                                                          onPressed: () {
                                                            if (visit == true) {
                                                              Navigator.pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          LoginPage()),
                                                                  (route) =>
                                                                      false);
                                                            } else {
                                                              Navigator.push(
                                                                context,
                                                                PageRouteBuilder(
                                                                  pageBuilder: (context,
                                                                          animation,
                                                                          secondaryAnimation) =>
                                                                      FitnessCenterPage(
                                                                          fitnessId:
                                                                              '${pins[index]["_id"]}'),
                                                                  transitionDuration:
                                                                      Duration
                                                                          .zero,
                                                                  reverseTransitionDuration:
                                                                      Duration
                                                                          .zero,
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: RichText(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        text: TextSpan(
                                                          text: pins[index][
                                                                  'center_address']
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF6E7995),
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  /*
                                Expanded(
                                  child: ListView.builder(
                                    controller: controller,
                                    itemCount: 100,
                                    itemBuilder: (_, index) {
                                      return Card(
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text("Element at index($index)"),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                 */
                                ],
                              ),
                      ),
                    ),
                  );
                },
                child: AnimatedContainer(
                  margin:
                      EdgeInsets.only(bottom: (markerClick ? 95 : 0) + 80 + ((Platform.isIOS) ? 30 : 0)),
                  padding: const EdgeInsets.all(8),
                  width: 90,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF3F51B5),
                    boxShadow: [
                      const BoxShadow(
                        color: Color.fromRGBO(63, 81, 181, 0.5),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  duration: Duration(milliseconds: 100),
                  child: Center(
                    child: Text(
                      '목록보기',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFFffffff)),
                    ),
                  ),
                ),
              ),
            ),
            //_trackingModeSelector(),
          ],
        );
      }),
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
    if (bottomSheet) {
      bottomSheet = false;
      //Navigator.pop(context);
    }
    setState(() {
      alignment = Alignment.bottomCenter;
      alignHeight = 30;
      markerClick = false;
    });
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

  /*
  _onSymbolTap(LatLng? position, String? caption) {
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

   */

  /// 지도 생성 완료시
  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    navarMapController = controller;
    _controller.complete(controller);
  }

  /*
  /// 지도 유형 선택시
  void _onTapTypeSelector(MapType type) async {
    if (_mapType != type) {
      setState(() {
        _mapType = type;
      });
    }
  }

   */

  /// my location button
  void _onTapLocation() async {
    final controller = await _controller.future;
    controller.setLocationTrackingMode(LocationTrackingMode.Follow);
  }

  void _onCameraChange(
      LatLng? latLng, CameraChangeReason? reason, bool? isAnimated) {
    /*
    print('카메라 움직임 >>> 위치 : ${latLng!.latitude}, ${latLng.longitude}'
        '\n원인: $reason'
        '\n에니메이션 여부: $isAnimated');
    print("MARKERs : ${markers.length}");

     */
  }

  Future<void> _onCameraIdle() async {
    print('카메라 움직임 멈춤');

    LatLngBounds dontNow = await navarMapController.getVisibleRegion();

    var cameraPosition = await navarMapController.getCameraPosition();
    print("camera position : ${cameraPosition.target}");
    print("camera zoom : ${cameraPosition.zoom}");

    print("north : ${dontNow.northeast}");
    print("north latitude : ${dontNow.northeast.latitude}");
    print("south : ${dontNow.southwest}");
    //print("first_longitude=${dontNow.southwest.longitude}&first_latitude=${dontNow.southwest.latitude}&second_longitude=${dontNow.northeast.longitude}&second_latitude=${dontNow.northeast.latitude}");
    //13
    http.Response response;
    var resBody;

    if (cameraPosition.zoom < 13) {
      zoomOut = true;
      response = await http.get(
        Uri.parse("https://fitmate.co.kr/v2/fitnesscenters/zoom"),
        headers: {
          "Authorization": "bearer $IdToken",
          "Content-Type": "application/json; charset=UTF-8"
        },
      );
      resBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode != 201 &&
          resBody["error"]["code"] == "auth/id-token-expired") {
        IdToken =
            (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
                .token
                .toString();

        response = await http.get(
          Uri.parse("https://fitmate.co.kr/v2/fitnesscenters/zoom"),
          headers: {
            "Authorization": "bearer $IdToken",
            "Content-Type": "application/json; charset=UTF-8"
          },
        );
        resBody = jsonDecode(utf8.decode(response.bodyBytes));
      }

      log("res body : $resBody");

      markers.clear();

      for (int i = 0; i < resBody['data'].length; i++) {
        if (resBody['data'][i]['location'][0]['location_latitude'] >=
                dontNow.southwest.latitude &&
            resBody['data'][i]['location'][0]['location_latitude'] <=
                dontNow.northeast.latitude &&
            resBody['data'][i]['location'][0]['location_longitude'] >=
                dontNow.southwest.longitude &&
            resBody['data'][i]['location'][0]['location_longitude'] <=
                dontNow.northeast.longitude) {
          markers.add(Marker(
            markerId: '${resBody['data'][i]['_id']}',
            position: LatLng(
                resBody['data'][i]['location'][0]['location_latitude'],
                resBody['data'][i]['location'][0]['location_longitude']),
            alpha: 1,
            captionOffset: -67,
            captionText: '${resBody['data'][i]['count']}',
            captionColor: Colors.white,
            icon: await OverlayImage.fromAssetImage(
              assetName:
                  'assets/icon/non_icon_map_pin.png', /*size: Size(36, 36)*/
            ),
            anchor: AnchorPoint(0.5, 0.7),
            width: 100,
            height: 100,
          ));
        }
      }
    } else {
      zoomOut = false;
      if (visit == true) {
        response = await http.get(
          Uri.parse(
              "https://fitmate.co.kr/v2/visitor/fitnesscenter?page=1&limit=200&first_longitude=${dontNow.southwest.longitude}&first_latitude=${dontNow.southwest.latitude}&second_longitude=${dontNow.northeast.longitude}&second_latitude=${dontNow.northeast.latitude}"),
        );
        resBody = jsonDecode(utf8.decode(response.bodyBytes));
        print("visit resbody : $resBody");
      } else {
        response = await http.get(
          Uri.parse(
              "https://fitmate.co.kr/v2/fitnesscenters?page=1&limit=200&first_longitude=${dontNow.southwest.longitude}&first_latitude=${dontNow.southwest.latitude}&second_longitude=${dontNow.northeast.longitude}&second_latitude=${dontNow.northeast.latitude}"),
          headers: {
            "Authorization": "bearer $IdToken",
            "Content-Type": "application/json; charset=UTF-8"
          },
        );
        resBody = jsonDecode(utf8.decode(response.bodyBytes));
        if (response.statusCode != 200 &&
            resBody["error"]["code"] == "auth/id-token-expired") {
          IdToken =
              (await FirebaseAuth.instance.currentUser?.getIdTokenResult(true))!
                  .token
                  .toString();

          response = await http.get(
            Uri.parse(
                "https://fitmate.co.kr/v2/fitnesscenters?page=1&limit=50&first_longitude=${dontNow.southwest.longitude}&first_latitude=${dontNow.southwest.latitude}&second_longitude=${dontNow.southwest.longitude}&second_latitude=${dontNow.southwest.latitude}"),
            headers: {
              "Authorization": "bearer $IdToken",
              "Content-Type": "application/json; charset=UTF-8"
            },
          );
          resBody = jsonDecode(utf8.decode(response.bodyBytes));
        }
      }
      pins = resBody['data']['docs'];

      log("res body : $resBody");

      markers.clear();
      print("pin 개수 : ${resBody['data']['docs'].length}");

      for (int i = 0; i < resBody['data']['docs'].length; i++) {
        if (_tabIconIndexSelected == 1 &&
            resBody['data']['docs'][i]['posts'].length != 0) {
          markers.add(Marker(
              markerId:
                  '${resBody['data']['docs'][i]['_id']}->${resBody['data']['docs'][i]['center_name']}->${resBody['data']['docs'][i]['center_address']}->${resBody['data']['docs'][i]['fitness_longitude']}->${resBody['data']['docs'][i]['fitness_latitude']}',
              position: LatLng(resBody['data']['docs'][i]['fitness_latitude'],
                  resBody['data']['docs'][i]['fitness_longitude']),
              alpha: 1,
              icon: resBody['data']['docs'][i]['posts'].length == 0
                  ? await OverlayImage.fromAssetImage(
                      assetName:
                          'assets/icon/map_pin.png', /*size: Size(44, 44)*/
                    )
                  : await OverlayImage.fromAssetImage(
                      assetName: 'assets/icon/Ping.png', /*size: Size(64, 64)*/
                    ),
              anchor: AnchorPoint(0.5, 0.7),
              width: resBody['data']['docs'][i]['posts'].length == 0 ? 70 : 90,
              height: resBody['data']['docs'][i]['posts'].length == 0 ? 70 : 90,
              onMarkerTab: (Marker? a, Map b) async {
                print("여기다!");

                print("a : $a");
                print("b : $b");
                var temp = a?.markerId.split('->');
                log("temp0 : ${temp![0]}");
                log("temp1 : ${temp[1]}");
                log("temp2 : ${temp[2]}");
                log("temp3 : ${temp[3]}");
                log("temp4 : ${temp[4]}");
                //CameraUpdate cameraUpdate = CameraUpdate.scrollWithOptions(a!.position!);
                //await navarMapController.moveCamera(cameraUpdate);
                /*
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  width: double.infinity,
                  height: 200,
                );
              },
            );

             */
                /*
              var sheetController = scaffoldKey.currentState
                  ?.showBottomSheet((context) => BottomSheetWidget());
              sheetController?.closed.then((value) {
                print("closed");
              });
               */

                setState(() {
                  alignment = Alignment.center;
                  alignHeight = 80;
                  alignCenterId = temp[0];
                  alignCenterName = temp[1];
                  alignCenterAddress = temp[2];
                  alignCenterY = temp[3];
                  alignCenterX = temp[4];
                  markerClick = true;
                });
              }));
        } else if (_tabIconIndexSelected == 0) {
          markers.add(Marker(
              markerId:
                  '${resBody['data']['docs'][i]['_id']}->${resBody['data']['docs'][i]['center_name']}->${resBody['data']['docs'][i]['center_address']}->${resBody['data']['docs'][i]['fitness_longitude']}->${resBody['data']['docs'][i]['fitness_latitude']}',
              position: LatLng(resBody['data']['docs'][i]['fitness_latitude'],
                  resBody['data']['docs'][i]['fitness_longitude']),
              alpha: 1,
              icon: resBody['data']['docs'][i]['posts'].length == 0
                  ? await OverlayImage.fromAssetImage(
                      assetName:
                          'assets/icon/map_pin.png', /*size: Size(44, 44)*/
                    )
                  : await OverlayImage.fromAssetImage(
                      assetName: 'assets/icon/Ping.png', /*size: Size(64, 64)*/
                    ),
              anchor: AnchorPoint(0.5, 0.7),
              width: resBody['data']['docs'][i]['posts'].length == 0 ? 70 : 90,
              height: resBody['data']['docs'][i]['posts'].length == 0 ? 70 : 90,
              onMarkerTab: (Marker? a, Map b) async {
                print("여기다!");

                print("a : $a");
                print("b : $b");
                var temp = a?.markerId.split('->');
                log("temp0 : ${temp![0]}");
                log("temp1 : ${temp[1]}");
                log("temp2 : ${temp[2]}");
                log("temp3 : ${temp[3]}");
                log("temp4 : ${temp[4]}");
                //CameraUpdate cameraUpdate = CameraUpdate.scrollWithOptions(a!.position!);
                //await navarMapController.moveCamera(cameraUpdate);
                /*
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  width: double.infinity,
                  height: 200,
                );
              },
            );

             */
                /*
              var sheetController = scaffoldKey.currentState
                  ?.showBottomSheet((context) => BottomSheetWidget());
              sheetController?.closed.then((value) {
                print("closed");
              });
               */

                setState(() {
                  alignment = Alignment.center;
                  alignHeight = 80;
                  alignCenterId = temp[0];
                  alignCenterName = temp[1];
                  alignCenterAddress = temp[2];
                  alignCenterY = temp[3];
                  alignCenterX = temp[4];
                  markerClick = true;
                });
              }));
        }
      }
    }

    /*
    var url = Uri.parse('https://dapi.kakao.com/v2/local/geo/coord2address.json?x=${cameraPosition.target.longitude}&y=${cameraPosition.target.latitude}&input_coord=WGS84');
    response = await http
        .get(url, headers: {"Authorization": "KakaoAK 281e3d7d678f26ad3b6020d8fc517852"});
    var resBody2 = json.decode(response.body) ;
    print("resbody2 : $resBody2");

    region_1depth_name = resBody2['documents'][0]['address']['region_1depth_name'];
    region_2depth_name = resBody2['documents'][0]['address']['region_2depth_name'];
    region_3depth_name = resBody2['documents'][0]['address']['region_3depth_name'];
     */

    //log("markers : ${markers}");
    setState(() {});
  }

  /*
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

   */

  Future<void> _markerClick(Marker a, Map b) async {
    log("여기 클릭 : ${a.position}");
    //await navarMapController.moveCamera(CameraUpdate.scrollTo(a.position!));
    //CameraUpdate cameraUpdate = CameraUpdate.scrollWithOptions(a.position!);
    //await navarMapController.moveCamera(cameraUpdate);
    showBottomSheet(
      backgroundColor: whiteTheme,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.965,
        expand: false,
        builder: (_, controller) => Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (Platform.isIOS)
                  ? SizedBox(
                      height: 30,
                    )
                  : SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.0),
                      color: Color(0xFFD1D9E6),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 28,
              ),
              Text(
                '이 지역 피트니스 클럽 ${pins.length}',
                style: TextStyle(
                    color: Color(0xFF6E7995),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: pins.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (visit == true) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginPage()),
                              (route) => false);
                        } else {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      FitnessCenterPage(
                                          fitnessId: '${pins[index]["_id"]}'),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 16, 20, 16),
                        height: 80,
                        width: double.infinity,
                        color: whiteTheme,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  pins[index]['center_name'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF000000),
                                    fontSize: 14,
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: 28,
                                  height: 28,
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
                                        "assets/icon/map_icon.svg",
                                        width: 16,
                                        height: 16,
                                      ),
                                      onPressed: () async {
                                        if (visit == true) {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          LoginPage()),
                                              (route) => false);
                                        } else {
                                          await Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  FitnessMapPage(
                                                x: pins[index]
                                                    ['fitness_latitude'],
                                                y: pins[index]
                                                    ['fitness_longitude'],
                                                fitnessName:
                                                    '${pins[index]['center_name'].toString()}',
                                                fitnessAddress:
                                                    '${pins[index]['center_address'].toString()}',
                                              ),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration:
                                                  Duration.zero,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Container(
                                  width: 28,
                                  height: 28,
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
                                        if (visit == true) {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          LoginPage()),
                                              (route) => false);
                                        } else {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  FitnessCenterPage(
                                                      fitnessId:
                                                          '${pins[index]["_id"]}'),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration:
                                                  Duration.zero,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    text: TextSpan(
                                      text: pins[index]['center_address']
                                          .toString(),
                                      style: TextStyle(
                                        color: Color(0xFF6E7995),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    setState(() {});
  }
}
