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
 *  1. Location 객체 생성
 * 
 */
  init() async {
    location = Location();
    isAviailable = await requestPermission();
    if (isAviailable == false) return;
    location.changeSettings(accuracy: LocationAccuracy.high);
  }

/**
 * @기능 
 *    1. listener 시작
 * @요구사항
 *    위치정보 권한 
 *    백그라운드 권한
 */
  initListner() async {
    location = new Location();
    isAviailable = await requestPermission();
    if (isAviailable == false) return;

    try {
      await location.enableBackgroundMode(enable: true);
      print("set background mode");
    } catch (error) {
      print("Can't set background mode");
    }
    location.changeSettings(accuracy: LocationAccuracy.high);

    // _listenLocation();
    print("LocationListener paused : ${_locationSubscription?.isPaused}");
  }

/**
 * @권한 요구
 */
  Future<bool> requestPermission() async {
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
      if ((currentlocation.time! - lasttime) >= 100000) {
        await getAndSendLocation(currentlocation);
        lasttime = currentlocation.time!;
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
      if (_serviceEnabled == false ||
          _permissionGranted == PermissionStatus.denied) {
        print("is rejected : $_serviceEnabled    $_permissionGranted");
        return {"user_longitude": 0.0, "user_latitude": 0.0};
      }
      locationData = locationData ?? await location.getLocation();
      Map _location = {
        "user_longitude": locationData.longitude,
        "user_latitude": locationData.latitude
      };
      if (isSignedIn()) {
        await api.postLocation(_location);
      }
      return _location;
    } catch (error) {
      print("error at get&send : ${error}");
    }
    return {"user_longitude": 0.0, "user_latitude": 0.0};
  }

  Future<Map> getSomeLocation() async {
    try {
      if (_serviceEnabled == false ||
          _permissionGranted == PermissionStatus.denied) {
        print("is rejected : $_serviceEnabled    $_permissionGranted");
        return {"user_longitude": 0.0, "user_latitude": 0.0};
      }
      LocationData locationData = await location.getLocation();
      Map _location = {
        "user_longitude": locationData.longitude,
        "user_latitude": locationData.latitude
      };

      return _location;
    } catch (error) {
      print("error at get&send : ${error}");
    }
    return {"user_longitude": 0.0, "user_latitude": 0.0};
  }

  pauseListener() {
    _locationSubscription?.cancel();
  }
}
