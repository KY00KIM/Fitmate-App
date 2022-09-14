import '../../data/post_api.dart';
import '../util.dart';

class PostApiRepository {
  final postApi = PostApi();

  Future<void> getPostRepo() async {
    //여기서 새로고침 케이스 조절
    posts = await postApi.getPost();
  }
}