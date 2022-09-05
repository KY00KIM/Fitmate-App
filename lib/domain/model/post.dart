class Post {
  Post({
    required this.underId,
    required this.userId,
    required this.locationId,
    required this.postFitnessPart,
    required this.postTitle,
    required this.postReadNo,
    required this.postHit,
    required this.isDeleted,
    required this.promiseLocation,
    required this.promiseDate,
    required this.postImg,
    required this.postMainText,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });
  late final String underId;
  late final UserId userId;
  late final String locationId;
  late final List<String> postFitnessPart;
  late final String postTitle;
  late final int postReadNo;
  late final int postHit;
  late final bool isDeleted;
  late final PromiseLocation promiseLocation;
  late final String promiseDate;
  late final String postImg;
  late final String postMainText;
  late final String createdAt;
  late final String updatedAt;
  late final String id;

  Post.fromJson(Map<String, dynamic> json){
    underId = json['_id'];
    userId = UserId.fromJson(json['user_id']);
    locationId = json['location_id'];
    postFitnessPart = List.castFrom<dynamic, String>(json['post_fitness_part']);
    postTitle = json['post_title'];
    postReadNo = json['post_readNo'];
    postHit = json['post_hit'];
    isDeleted = json['is_deleted'];
    promiseLocation = PromiseLocation.fromJson(json['promise_location']);
    promiseDate = json['promise_date'];
    postImg = json['post_img'];
    postMainText = json['post_main_text'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = underId;
    _data['user_id'] = userId.toJson();
    _data['location_id'] = locationId;
    _data['post_fitness_part'] = postFitnessPart;
    _data['post_title'] = postTitle;
    _data['post_readNo'] = postReadNo;
    _data['post_hit'] = postHit;
    _data['is_deleted'] = isDeleted;
    _data['promise_location'] = promiseLocation.toJson();
    _data['promise_date'] = promiseDate;
    _data['post_img'] = postImg;
    _data['post_main_text'] = postMainText;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['id'] = id;
    return _data;
  }
}

class UserId {
  UserId({
    required this.underId,
    required this.userNickname,
    required this.userProfileImg,
    required this.id,
  });
  late final String underId;
  late final String userNickname;
  late final String userProfileImg;
  late final String id;

  UserId.fromJson(Map<String, dynamic> json){
    underId = json['_id'];
    userNickname = json['user_nickname'];
    userProfileImg = json['user_profile_img'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = underId;
    _data['user_nickname'] = userNickname;
    _data['user_profile_img'] = userProfileImg;
    _data['id'] = id;
    return _data;
  }
}

class PromiseLocation {
  PromiseLocation({
    required this.underId,
    required this.centerName,
    required this.centerAddress,
    required this.centerLocation,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });
  late final String underId;
  late final String centerName;
  late final String centerAddress;
  late final String centerLocation;
  late final String createdAt;
  late final String updatedAt;
  late final String id;

  PromiseLocation.fromJson(Map<String, dynamic> json){
    underId = json['_id'];
    centerName = json['center_name'];
    centerAddress = json['center_address'];
    centerLocation = json['center_location'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = underId;
    _data['center_name'] = centerName;
    _data['center_address'] = centerAddress;
    _data['center_location'] = centerLocation;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['id'] = id;
    return _data;
  }
}