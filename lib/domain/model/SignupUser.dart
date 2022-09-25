class SignupUser {
  SignupUser({
    required this.userNickname,
    required this.userAddress,
    required this.userScheduleTime,
    required this.userWeekday,
    required this.userGender,
    required this.userLongitude,
    required this.userLatitude,
    required this.fitnessCenterId,
    required this.deviceToken,
  });
  late final String userNickname;
  late final String userAddress;
  late final int userScheduleTime;
  late final UserWeekday userWeekday;
  late final bool userGender;
  late final double userLongitude;
  late final double userLatitude;
  late final String fitnessCenterId;
  late final String deviceToken;

  SignupUser.fromJson(Map<String, dynamic> json) {
    userNickname = json['user_nickname'];
    userAddress = json['user_address'];
    userScheduleTime = json['user_schedule_time'];
    userWeekday = UserWeekday.fromJson(json['user_weekday']);
    userGender = json['user_gender'];
    userLongitude = json['user_longitude'];
    userLatitude = json['user_latitude'];
    fitnessCenterId = json['fitness_center_id'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_nickname'] = userNickname;
    _data['user_address'] = userAddress;
    _data['user_schedule_time'] = userScheduleTime;
    _data['user_weekday'] = userWeekday.toJson();
    _data['user_gender'] = userGender;
    _data['user_longitude'] = userLongitude;
    _data['user_latitude'] = userLatitude;
    _data['fitness_center_id'] = fitnessCenterId;
    _data['device_token'] = deviceToken;
    return _data;
  }
}

class UserWeekday {
  UserWeekday({
    required this.mon,
    required this.tue,
    required this.wed,
    required this.thu,
    required this.fri,
    required this.sat,
    required this.sun,
  });
  late final bool mon;
  late final bool tue;
  late final bool wed;
  late final bool thu;
  late final bool fri;
  late final bool sat;
  late final bool sun;

  UserWeekday.fromJson(Map<String, dynamic> json) {
    mon = json['mon'];
    tue = json['tue'];
    wed = json['wed'];
    thu = json['thu'];
    fri = json['fri'];
    sat = json['sat'];
    sun = json['sun'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['mon'] = mon;
    _data['tue'] = tue;
    _data['wed'] = wed;
    _data['thu'] = thu;
    _data['fri'] = fri;
    _data['sat'] = sat;
    _data['sun'] = sun;
    return _data;
  }
}
