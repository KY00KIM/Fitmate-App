import 'dart:async';
import 'dart:developer';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import '../../data/usertrace_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../util.dart';

class locationController {
  late Location location;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData curLocationData;
  StreamSubscription<LocationData>? _locationSubscription;
  UserTraceApi api = UserTraceApi();
  double lasttime = 0;
  bool isAviailable = false;

/**
 * @기능 
 *    1. listener 시작
 * @요구사항
 *    위치정보 권한 
 *    백그라운드 권한
 */
  init() async {
    location = new Location();
    isAviailable = await _requestPermission();
    if (isAviailable == false) return;

    try {
      await location.enableBackgroundMode(enable: true);
      print("set background mode");
    } catch (error) {
      print("Can't set background mode");
    }
    location.changeSettings(
        interval: 60000, distanceFilter: 1, accuracy: LocationAccuracy.high);

    _listenLocation();
    print("LocationListener paused : ${_locationSubscription?.isPaused}");
  }

/**
 * @권한 요구
 */
  Future<bool> _requestPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      print("Currently disabled, requesting location permission");
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print("Disabled by user, NO permission");
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      print("permission : " + _permissionGranted.toString());
      if (_permissionGranted != PermissionStatus.granted) {
        print("permission : " + _permissionGranted.toString());
        return false;
      }
    }
    return true;
  }

/**
 * 위치정보 Listener
 * 300초마다 위치정보 전송
 */
  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print("error occured while opening LocationListener");
      print(onError);
      _locationSubscription?.cancel();
    }).listen((LocationData currentlocation) async {
      if ((currentlocation.time! - lasttime) >= 60000) {
        print("true!");
        await getAndSendLocation(currentlocation);
        lasttime = currentlocation.time!;
      } else {
        print("false!");
      }
    });
  }

  /**
   * @기능 : 현재위치정보 바탕으로 위치 전송
   * @요구사항 
   *    Firebase 로그인
   */

  Future<Map> getAndSendLocation(LocationData? locationData) async {
    try {
      print("get & send");
      locationData ??= await location.getLocation();
      Map _location = {
        "user_longitude": locationData.longitude,
        "user_latitude": locationData.latitude
      };
      print("loc : $_location");
      if (isSignedIn()) await api.postLocation(_location);
      return _location;
    } catch (error) {
      print(error);
      return Future.error(Exception(error.toString()));
    }
  }
}
