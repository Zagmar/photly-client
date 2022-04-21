import 'package:couple_seflie_app/data/model/post_model.dart';

import '../datasource/local_datasource.dart';
import '../datasource/remote_datasource.dart';

class PostInfoRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();
  static const String POST = "$PHOTLY/post";

  /// Get post
  // input : postId
  // output : postModel
  Future<Object> getPost(int postId) async {
    // convert inputData to use for API
    Map<String, String> inputData = {
      'postId' : postId.toString(),
    };

    // call API
    return await _remoteDataSource.getFromUri(POST, inputData);
  }

  /// Create post
  // input : postModel
  Future<Object> createPost(PostModel postModel) async {
    // convert inputData to use for API
    Map<String, String> inputData = {
      'postId' : postModel.postId.toString(),
      'postUserId' : postModel.postUserId,
      'postImageUrl' : postModel.postImageUrl,
      'postText' : postModel.postText.toString(),
      'postEmotion' : postModel.postEmotion.toString(),
      'postLocation' : postModel.postLocation.toString(),
      'postEditTime' : postModel.postEditTime.toString(),
      'postIsPublic' : postModel.postIsPublic.toString(),
      'postWeather' : postModel.postWeather.toString(),
    };

    // call API
    return await _remoteDataSource.postToUri(POST, inputData);
  }

  /// Edit post
  // input : postModel
  Future<Object> editPost(PostModel postModel) async {
    // convert inputData to use for API
    Map<String, String> inputData = {
      'postId' : postModel.postId.toString(),
      'postImageUrl' : postModel.postImageUrl,
      'postText' : postModel.postText.toString(),
      'postEmotion' : postModel.postEmotion.toString(),
      'postLocation' : postModel.postLocation.toString(),
      'postEditTime' : postModel.postEditTime.toString(),
      'postIsPublic' : postModel.postIsPublic.toString(),
      'postWeather' : postModel.postWeather.toString(),
    };

    // call API
    return await _remoteDataSource.putToUri(POST, inputData);
  }
}