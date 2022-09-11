class SignupUser {
  SignupUser({
    required this.userNickname,
    required this.userAddress,
    required this.userScheduleTime,
    required this.userWeekday,
    required this.userGender,
    required this.userLongitude,
    required this.userLatitude,
    required this.fitnessCenter,
    required this.deviceToken,
  });
  late final String userNickname;
  late final String userAddress;
  late final int userScheduleTime;
  late final UserWeekday userWeekday;
  late final bool userGender;
  late final int userLongitude;
  late final int userLatitude;
  late final FitnessCenter fitnessCenter;
  late final String deviceToken;

  SignupUser.fromJson(Map<String, dynamic> json) {
    userNickname = json['user_nickname'];
    userAddress = json['user_address'];
    userScheduleTime = json['user_schedule_time'];
    userWeekday = UserWeekday.fromJson(json['user_weekday']);
    userGender = json['user_gender'];
    userLongitude = json['user_longitude'];
    userLatitude = json['user_latitude'];
    fitnessCenter = FitnessCenter.fromJson(json['fitness_center']);
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
    _data['fitness_center'] = fitnessCenter.toJson();
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

class FitnessCenter {
  FitnessCenter({
    required this.centerName,
    required this.centerAddress,
    required this.fitnessLongitude,
    required this.fitnessLatitude,
  });
  late final String centerName;
  late final String centerAddress;
  late final double fitnessLongitude;
  late final double fitnessLatitude;

  FitnessCenter.fromJson(Map<String, dynamic> json) {
    centerName = json['center_name'];
    centerAddress = json['center_address'];
    fitnessLongitude = json['fitness_longitude'];
    fitnessLatitude = json['fitness_latitude'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['center_name'] = centerName;
    _data['center_address'] = centerAddress;
    _data['fitness_longitude'] = fitnessLongitude;
    _data['fitness_latitude'] = fitnessLatitude;
    return _data;
  }
}
