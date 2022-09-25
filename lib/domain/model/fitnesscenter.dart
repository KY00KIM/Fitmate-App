class FitnessCenter {
  FitnessCenter({
    required this.underId,
    required this.centerName,
    required this.centerAddress,
    required this.centerLocation,
    required this.fitnessLongitude,
    required this.fitnessLatitude,
    required this.kakaoUrl,
    required this.reviews,
  });
  late final String underId;
  late final String centerName;
  late final String centerAddress;
  late final String centerLocation;
  late final double fitnessLongitude;
  late final double fitnessLatitude;
  late final String kakaoUrl;
  late final List<Reviews> reviews;

  FitnessCenter.fromJson(Map<String, dynamic> json){
    underId = json['_id'];
    centerName = json['center_name'];
    centerAddress = json['center_address'];
    centerLocation = json['center_location'];
    fitnessLongitude = json['fitness_longitude'];
    fitnessLatitude = json['fitness_latitude'];
    kakaoUrl = json['kakao_url'];
    reviews = List.from(json['reviews']).map((e)=>Reviews.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = underId;
    _data['center_name'] = centerName;
    _data['center_address'] = centerAddress;
    _data['center_location'] = centerLocation;
    _data['fitness_longitude'] = fitnessLongitude;
    _data['fitness_latitude'] = fitnessLatitude;
    _data['kakao_url'] = kakaoUrl;
    _data['reviews'] = reviews.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Reviews {
  Reviews({
    required this.underId,
    required this.centerId,
    required this.reviewSendId,
    required this.centerRating,
    required this.centerReview,
    required this.centerReviewBySelect,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });
  late final String underId;
  late final String centerId;
  late final String reviewSendId;
  late final int centerRating;
  late final String centerReview;
  late final List<String> centerReviewBySelect;
  late final String createdAt;
  late final String updatedAt;
  late final String id;

  Reviews.fromJson(Map<String, dynamic> json){
    underId = json['_id'];
    centerId = json['center_id'];
    reviewSendId = json['review_send_id'];
    centerRating = json['center_rating'];
    centerReview = json['center_review'];
    centerReviewBySelect = List.castFrom<dynamic, String>(json['center_review_by_select']);
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = underId;
    _data['center_id'] = centerId;
    _data['review_send_id'] = reviewSendId;
    _data['center_rating'] = centerRating;
    _data['center_review'] = centerReview;
    _data['center_review_by_select'] = centerReviewBySelect;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['id'] = id;
    return _data;
  }
}