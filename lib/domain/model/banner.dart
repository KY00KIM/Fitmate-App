class Banner {
  Banner({
    required this.underId,
    required this.bannerImageUrl,
    required this.connectUrl,
    required this.expireDate,
    required this.isDeleted,
    required this.clickNum,
    required this.updatedAt,
  });
  late final String underId;
  late final String bannerImageUrl;
  late final String connectUrl;
  late final String expireDate;
  late final bool isDeleted;
  late final int clickNum;
  late final String updatedAt;

  Banner.fromJson(Map<String, dynamic> json){
    underId = json['_id'];
    bannerImageUrl = json['banner_image_url'];
    connectUrl = json['connect_url'];
    expireDate = json['expire_date'];
    isDeleted = json['is_deleted'];
    clickNum = json['click_num'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = underId;
    _data['banner_image_url'] = bannerImageUrl;
    _data['connect_url'] = connectUrl;
    _data['expire_date'] = expireDate;
    _data['is_deleted'] = isDeleted;
    _data['click_num'] = clickNum;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}