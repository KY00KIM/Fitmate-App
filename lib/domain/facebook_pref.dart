import 'dart:html';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:permission_handler/permission_handler.dart';

final facebookAppEvents = FacebookAppEvents();

Future<PermissionStatus> getAppTrackingPermissionStatus() async {
  PermissionStatus track_status =
      await Permission.appTrackingTransparency.status;
  return track_status;
}

Future<PermissionStatus> requestAppTrackingPermission() async {
  PermissionStatus track_status =
      await Permission.appTrackingTransparency.request();
  return track_status;
}

void checkAndRequestTrackingPermission() async {
  PermissionStatus status = await getAppTrackingPermissionStatus();
  print("tracking_permission initial : ${status}");
  if (status != PermissionStatus.granted) {
    PermissionStatus result_status = await requestAppTrackingPermission();
    print("tracking_permission requested : ${result_status}");
  }
}

// class FacebookAppLog {
//   final facebookAppEvents = FacebookAppEvents();

//   Future<String?> getId() async {
//     String? id = await facebookAppEvents.getApplicationId();
//     facebookAppEvents.logAdClick(adType: "Banner");
//     return id;
//   }
// }
