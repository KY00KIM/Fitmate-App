class Review {
  Review({
    required this.underId,
    required this.reviewSendId,
    required this.reviewRecvId,
    required this.reviewBody,
    required this.userRating,
    required this.reviewCandidate,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String underId;
  late final String reviewSendId;
  late final String reviewRecvId;
  late final String reviewBody;
  late final int userRating;
  late final List<String> reviewCandidate;
  late final String createdAt;
  late final String updatedAt;

  Review.fromJson(Map<String, dynamic> json){
    underId = json['_id'];
    reviewSendId = json['review_send_id'];
    reviewRecvId = json['review_recv_id'];
    reviewBody = json['review_body'];
    userRating = json['user_rating'];
    reviewCandidate = List.castFrom<dynamic, String>(json['review_candidate']);
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = underId;
    _data['review_send_id'] = reviewSendId;
    _data['review_recv_id'] = reviewRecvId;
    _data['review_body'] = reviewBody;
    _data['user_rating'] = userRating;
    _data['review_candidate'] = reviewCandidate;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}