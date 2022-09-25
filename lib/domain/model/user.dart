class User {
  User({
    required this.id,
    required this.userName,
    required this.userAddress,
    required this.userNickname,
    required this.userEmail,
    required this.userProfileImg,
    required this.userScheduleTime,
    required this.userWeekday,
    required this.userIntroduce,
    required this.userFitnessPart,
    required this.userAge,
    required this.userGender,
    required this.userLocBound,
    required this.fitnessCenterId,
    required this.userLongitude,
    required this.userLatitude,
    required this.locationId,
    required this.social,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final String userName;
  late final String userAddress;
  late final String userNickname;
  late final String userEmail;
  late final String userProfileImg;
  late final int userScheduleTime;
  late final UserWeekday userWeekday;
  late final String userIntroduce;
  late final List<String> userFitnessPart;
  late final int userAge;
  late final bool userGender;
  late final int userLocBound;
  late final String fitnessCenterId;
  late final int userLongitude;
  late final int userLatitude;
  late final String locationId;
  late final Social social;
  late final bool isDeleted;
  late final String createdAt;
  late final String updatedAt;

  User.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    userName = json['user_name'];
    userAddress = json['user_address'];
    userNickname = json['user_nickname'];
    userEmail = json['user_email'];
    userProfileImg = json['user_profile_img'];
    userScheduleTime = json['user_schedule_time'];
    userWeekday = UserWeekday.fromJson(json['user_weekday']);
    userIntroduce = json['user_introduce'];
    userFitnessPart = List.castFrom<dynamic, String>(json['user_fitness_part']);
    userAge = json['user_age'];
    userGender = json['user_gender'];
    userLocBound = json['user_loc_bound'];
    fitnessCenterId = json['fitness_center_id'];
    userLongitude = json['user_longitude'];
    userLatitude = json['user_latitude'];
    locationId = json['location_id'];
    social = Social.fromJson(json['social']);
    isDeleted = json['is_deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['user_name'] = userName;
    _data['user_address'] = userAddress;
    _data['user_nickname'] = userNickname;
    _data['user_email'] = userEmail;
    _data['user_profile_img'] = userProfileImg;
    _data['user_schedule_time'] = userScheduleTime;
    _data['user_weekday'] = userWeekday.toJson();
    _data['user_introduce'] = userIntroduce;
    _data['user_fitness_part'] = userFitnessPart;
    _data['user_age'] = userAge;
    _data['user_gender'] = userGender;
    _data['user_loc_bound'] = userLocBound;
    _data['fitness_center_id'] = fitnessCenterId;
    _data['user_longitude'] = userLongitude;
    _data['user_latitude'] = userLatitude;
    _data['location_id'] = locationId;
    _data['social'] = social.toJson();
    _data['is_deleted'] = isDeleted;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
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

  UserWeekday.fromJson(Map<String, dynamic> json){
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

class Social {
  Social({
    required this.userId,
    required this.userName,
    required this.provider,
    required this.deviceToken,
    required this.firebaseInfo,
  });
  late final String userId;
  late final String userName;
  late final String provider;
  late final List<String> deviceToken;
  late final FirebaseInfo firebaseInfo;

  Social.fromJson(Map<String, dynamic> json){
    userId = json['user_id'];
    userName = json['user_name'];
    provider = json['provider'];
    deviceToken = List.castFrom<dynamic, String>(json['device_token']);
    firebaseInfo = FirebaseInfo.fromJson(json['firebase_info']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['user_name'] = userName;
    _data['provider'] = provider;
    _data['device_token'] = deviceToken;
    _data['firebase_info'] = firebaseInfo.toJson();
    return _data;
  }
}

class FirebaseInfo {
  FirebaseInfo();

  FirebaseInfo.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}