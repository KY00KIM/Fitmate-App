import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

final facebookAppEvents = FacebookAppEvents();
// const facebookSettingChannel = MethodChannel('com.hyeda.fitmate/facebook');

// Future setFacebookStatus(bool status) async {
//   final arguments = {'permission': status};
//   final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
//   print("with uuid: $uuid");
//   print("CONFIGURING IOS FB_TRACKING_PERMISSON...");

//   await facebookAppEvents.setAdvertiserTracking(enabled: true);
//   final bool fbPermissionStatus =
//       await facebookSettingChannel.invokeMethod('setFacebookStatus', arguments);
//   print("FB STATUS : ${fbPermissionStatus}");
// }

/**
 * function : get app_tracking_permission status
 * dependency : app_tracking_transparency
 */
Future<TrackingStatus> getAppTrackingPermissionStatus() async {
  TrackingStatus track_status =
      await AppTrackingTransparency.trackingAuthorizationStatus;
  // PermissionStatus track_status =
  //     await Permission.appTrackingTransparency.status;
  return track_status;
}

/**
 * function : request app_tracking_permission status
 * dependency : app_tracking_transparency
 */
Future<TrackingStatus> requestAppTrackingPermission() async {
  TrackingStatus track_status =
      await AppTrackingTransparency.requestTrackingAuthorization();
  // PermissionStatus track_status =
  //     await Permission.appTrackingTransparency.request();
  return track_status;
}

/**
 * function : 
 *            1. get app_tracking_permission status
 *            2. if not-determined, request permission
 *            3. return permission
 * dependency : app_tracking_transparency
 */
void checkAndRequestTrackingPermission() async {
  TrackingStatus status = await getAppTrackingPermissionStatus();
  print("tracking_permission initial : ${status}");
  if (status != TrackingStatus.authorized &&
      status != TrackingStatus.notSupported) {
    // await showCustomTrackingDialog(context);
    // await Future.delayed(const Duration(milliseconds: 200));

    TrackingStatus result_status = await requestAppTrackingPermission();
    print("tracking_permission requested : ${result_status}");
    // await setFacebookStatus(result_status == TrackingStatus.authorized);
    facebookAppEvents.setAdvertiserTracking(
        enabled: (result_status == TrackingStatus.authorized));
  } else {
    // await setFacebookStatus(status == TrackingStatus.authorized);
    facebookAppEvents.setAdvertiserTracking(
        enabled: (status == TrackingStatus.authorized));
  }
  // await setFacebookStatus(status == TrackingStatus.authorized);
}

// class FacebookAppLog {
//   final facebookAppEvents = FacebookAppEvents();

//   Future<String?> getId() async {
//     String? id = await facebookAppEvents.getApplicationId();
//     facebookAppEvents.logAdClick(adType: "Banner");
//     return id;
//   }
// }

Future<void> showCustomTrackingDialog(BuildContext context) async =>
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dear User'),
        content: const Text(
          'We care about your privacy and data security. We keep this app free by showing ads. '
          'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
          'Our partners will collect data and use a unique identifier on your device to show you ads.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
