import 'dart:developer';

import 'package:location/location.dart';

import '../../data/banner_api.dart';
import '../../data/post_api.dart';
import '../model/fitnesscenter.dart';
import '../model/post.dart';
import '../model/banner.dart';
import '../util.dart';
import 'fitness_center_api_repository.dart';
import '../instance_preference/location.dart';

class HomeApiRepository {
  final postApi = PostApi();
  final bannerApi = BannerApi();
  final fitnessCenterRepo = FitnessCenterApiRepository();

  Future<Map> getHomeRepo() async {
    List<Post> _posts = <Post>[];
    List<Banner> _banners = <Banner>[];
    _posts = await postApi.getPost();
    print("posts : $_posts");
    _banners = await bannerApi.getBanner();
    print("banner : $_banners");

    //Map _position = await locator.getAndSendLocation(null);

    //FitnessCenter _fitness = await fitnessCenterRepo.getFitnessRepo(1, _position.longitude, _position.latitude, _position.longitude, _position.latitude);
    // FitnessCenter _fitness =
    //     await fitnessCenterRepo.getFitnessRepo(1, 100, 100, 100, 100);

    FitnessCenter _fitness = await fitnessCenterRepo.getFitnessRepo(1, 126.76573544490464, 34.65468910081279, 128.67164341811144,  37.80553607680439);
    //FitnessCenter _fitness = await fitnessCenterRepo.getFitnessRepo(1, 100, 100, 100, 100);
    print(_fitness);
    print("hihihi");

    posts = _posts;
    banners = _banners;
    myFitnessCenter = _fitness;

    print("START");
    print("posts" +
        _posts.toString() +
        "banners" +
        _banners.toString() +
        "fitness_center" +
        _fitness.toString());
    print("END");

    return {"posts": _posts, "banners": _banners, "fitness_center": _fitness};
  }
}
