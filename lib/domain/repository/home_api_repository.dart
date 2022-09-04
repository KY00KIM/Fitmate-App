import '../../data/banner_api.dart';
import '../../data/post_api.dart';

class HomeApiRepository {
  final postApi = PostApi();
  final bannerApi = BannerApi();

  Future<Map> getHomeRepo() async {

    List<dynamic> _posts = <dynamic>[];
    List<dynamic> _banners = <dynamic>[];

    _posts = await postApi.getPost();
    _banners = await bannerApi.getBanner();

    return {
      "posts" : _posts,
      "banners" : _banners
    };

  }
}