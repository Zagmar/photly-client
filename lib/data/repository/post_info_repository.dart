import 'dart:io';

import 'package:couple_seflie_app/data/model/post_model.dart';
import 'package:image_picker/image_picker.dart';

import '../datasource/local_datasource.dart';
import '../datasource/remote_datasource.dart';

class PostInfoRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();
  static const String POST = "$PHOTLY/post";

  /// Remote
  /// Get post
  // input : postId
  // output : postModel
  Future<Object> readPost(int postId) async {
    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      'post_id' : postId,
    };

    //return Success(response: '{"postId": "1", "postUserId": "00", "postImageUrl": "https://item.kakaocdn.net/do/493188dee481260d5c89790036be0e66c37d537a8f2c6f426591be6b8dc7b36a", "postIsPublic": "false", "postEditTime": "2022-05-10 15:47:12.924688", "postText": "hello", "postEmotion": "1", "postWeather": "1", "postLocation": "1"}');

    // call API
    var response = await _remoteDataSource.getFromUri(POST, inputData);
    print("PostInfoRepository성공");
    print(response);
    return response;
    return await _remoteDataSource.getFromUri(POST, inputData);
  }

  /// Create post
  // input : postModel
  Future<Object> createPost(PostModel postModel) async {
    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      'user_id' : postModel.postUserId,
      'post_text' : postModel.postText.toString(),
      'post_emotion' : postModel.postEmotion.toString(),
      'post_location' : postModel.postLocation.toString(),
      'post_time' : postModel.postEditTime.toString(),
      'post_is_public' : postModel.postIsPublic.toString(),
      'post_weather' : postModel.postWeather.toString(),
    };

    //return Success(response: '{"postId": "1", "postUserId": "00", "postImageUrl": "https://item.kakaocdn.net/do/493188dee481260d5c89790036be0e66c37d537a8f2c6f426591be6b8dc7b36a", "postIsPublic": "false", "postEditTime": "2022-05-10 15:47:12.924688", "postText": "hello", "postEmotion": "1", "postWeather": "1", "postLocation": "1"}');

    // call API
    return await _remoteDataSource.postToUri(POST, inputData);
  }

  /// Edit post
  // input : postModel
  Future<Object> updatePost(PostModel postModel) async {
    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      'post_id' : postModel.postId,
      'user_id' : postModel.postUserId,
      'post_text' : postModel.postText,
      'post_emotion' : postModel.postEmotion,
      'post_location' : postModel.postLocation,
      'post_time' : DateTime.now().toString(),
      'post_is_public' : postModel.postIsPublic ? 1 : 0,
      'post_weather' : postModel.postWeather,
    };

    print(inputData);

    //return Success(response: '{"postId": "1", "postUserId": "00", "postImageUrl": "https://item.kakaocdn.net/do/493188dee481260d5c89790036be0e66c37d537a8f2c6f426591be6b8dc7b36a", "postIsPublic": "false", "postEditTime": "2022-05-10 15:47:12.924688", "postText": "hello", "postEmotion": "1", "postWeather": "1", "postLocation": "1"}');

    // call API
    return await _remoteDataSource.putToUri(POST, inputData);
  }
  /// Remote

  /// Local
  /// Get Image From Gallery or Camera
  Future<File?> readImage(ImageSource source) async {
    ImageSource imageSource;
    // get image from gallery
    if(source == ImageSource.gallery) {
      imageSource = ImageSource.gallery;
      return await _localDataSource.getImage(imageSource);
    }

    // get image from camera
    else {
      imageSource = ImageSource.camera;
      return await _localDataSource.getImage(imageSource);
    }
  }
  /// Local
}