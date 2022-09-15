import 'dart:developer';

import 'package:geolocator/geolocator.dart';

import '../../data/banner_api.dart';
import '../../data/post_api.dart';
import '../model/fitnesscenter.dart';
import '../model/post.dart';
import '../model/banner.dart';
import '../util.dart';
import 'fitness_center_api_repository.dart';

class HomeApiRepository {
  final postApi = PostApi();
  final bannerApi = BannerApi();
  final fitnessCenterRepo = FitnessCenterApiRepository();

  Future<Map> getHomeRepo() async {
    List<Post> _posts = <Post>[];
    List<Banner> _banners = <Banner>[];

    _posts = await postApi.getPost();
    _banners = await bannerApi.getBanner();


    Position _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);


    print("long : ${_position.longitude}");


    print("lati : ${_position.latitude}");

    FitnessCenter _fitness = await fitnessCenterRepo.getFitnessRepo(1, _position.longitude, _position.latitude, _position.longitude, _position.latitude);
    //FitnessCenter _fitness = await fitnessCenterRepo.getFitnessRepo(1, 100, 100, 100, 100);

    posts = _posts;
    banners = _banners;
    myFitnessCenter = _fitness;

    return {
      "posts" : _posts,
      "banners" : _banners,
      "fitness_center" : _fitness
    };

  }
}