import 'dart:async';
import 'package:background_location_tracker/background_location_tracker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fitmate/domain/util.dart';

Future<void> initTrackManager() async {
  await BackgroundLocationTrackerManager.initialize(
    backgroundCallback,
    config: const BackgroundLocationTrackerConfig(
      loggingEnabled: false,
      androidConfig: AndroidConfig(
        trackingInterval: Duration(seconds: 5),
        distanceFilterMeters: null,
      ),
      iOSConfig: IOSConfig(
        distanceFilterMeters: null,
        restartAfterKill: true,
      ),
    ),
  );
}

String _trace_id = "63367815762ac8c4a8b291d9";

void startTrackManager() async {
  await BackgroundLocationTrackerManager.startTracking();
}

void stopTrackManager() async {
  await BackgroundLocationTrackerManager.stopTracking();
}

@pragma('vm:entry-point')
void backgroundCallback() {
  BackgroundLocationTrackerManager.handleBackgroundUpdated(
    (data) async => {
      await sendTrace(data),
    },
  );
}

Future<void> sendTrace(BackgroundLocationUpdateData data) async {
  String baseUrl = "https://fitmate.co.kr/";
  await updateUserId();
  print("FETCH ID : $_trace_id");
  var bodyParse = json.encode({
    "user_longitude": data.lon,
    "user_latitude": data.lat,
    "user_id": _trace_id
  });
  http.Response response = await http.post(
      Uri.parse("${baseUrl}v2/trace/noauth"),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
      body: bodyParse);
  var resBody = jsonDecode(utf8.decode(response.bodyBytes));
  print("SENT DONE! with : $resBody");
}

Future<String> updateUserId() async {
  try {
    String idFromUtil = fetchUserFromUtil();
    if (idFromUtil == "") {
      _trace_id = await UserIdData().getUserId();
    } else {
      await UserIdData().saveUser(idFromUtil);
      _trace_id = idFromUtil;
    }
  } catch (e) {
    print(e);
  }
  return _trace_id;
}

String fetchUserFromUtil() {
  try {
    print("USERDATA!!!!!");
    print(UserData['_id']);
    return UserData['_id'];
  } catch (e) {
    print(e);
  }
  return "";
}

class UserIdData {
  static const _userKey = 'background_user_data';
  static const _userSeparator = '-/-/-/';

  static UserIdData? _instance;
  UserIdData._();
  factory UserIdData() => _instance ??= UserIdData._();
  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<void> saveUser(String newId) async {
    final userIds = newId;
    final prefs = await this.prefs;
    await prefs.reload();

    await (await prefs).setString(_userKey, newId);
  }

  Future<String> getUserId() async {
    final prefs = await this.prefs;
    await prefs.reload();
    final userId = prefs.getString(_userKey);
    if (userId == null) return "63367815762ac8c4a8b291d9";
    return userId;
  }

  Future<void> clear() async => (await prefs).clear();
}
