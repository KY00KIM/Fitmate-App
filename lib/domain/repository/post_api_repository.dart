import '../../data/post_api.dart';

class PostApiRepository {
  final postApi = PostApi();

  Future<List> getPostRepo() async {
    //여기서 새로고침 케이스 조절
    List<dynamic> _posts = <dynamic>[];
    _posts = await postApi.getPost();
    return _posts;
  }
}