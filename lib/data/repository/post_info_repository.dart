import 'package:couple_seflie_app/data/model/post_model.dart';

import '../datasource/local_datasource.dart';
import '../datasource/remote_datasourcee.dart';

class PostInfoRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();
  static const String POST = "https://jsonplaceholder.typicode.com/users";



  /// input : postId
  /// output : postImageUrl, postUserId, postIsPublic, postEditTime, postText, postEmotion, postWeather, postLocation
  Future<Object> getPost(String postId) async {
    return await _remoteDataSource.getFromUri(POST);
  }

  newPost(PostModel newPost) {
    return _remoteDataSource.postToUri(POST,);
  }

  editPost(PostModel editedPost) {
    return _remoteDataSource.putToUri(POST);
  }

  deletePost() {
    return _remoteDataSource.deleteFromUri(POST);
  }

  changeIsPublic() {
    return _remoteDataSource.putToUri(POST);
  }
}