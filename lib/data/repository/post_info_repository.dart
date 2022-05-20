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
  Future<Object> getPost(int postId) async {
    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      //'postId' : postId,
      'post_id' : 15, // test
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
      'postId' : postModel.postId,
      'postUserId' : postModel.postUserId,
      'postImageUrl' : postModel.postImageUrl,
      'postText' : postModel.postText.toString(),
      'postEmotion' : postModel.postEmotion.toString(),
      'postLocation' : postModel.postLocation.toString(),
      'postEditTime' : postModel.postEditTime.toString(),
      'postIsPublic' : postModel.postIsPublic.toString(),
      'postWeather' : postModel.postWeather.toString(),
    };

    return Success(response: '{"postId": "1", "postUserId": "00", "postImageUrl": "https://item.kakaocdn.net/do/493188dee481260d5c89790036be0e66c37d537a8f2c6f426591be6b8dc7b36a", "postIsPublic": "false", "postEditTime": "2022-05-10 15:47:12.924688", "postText": "hello", "postEmotion": "1", "postWeather": "1", "postLocation": "1"}');

    // call API
    return await _remoteDataSource.postToUri(POST, inputData);
  }

  /// Edit post
  // input : postModel
  Future<Object> editPost(PostModel postModel) async {
    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      'postId' : postModel.postId,
      'postImageUrl' : postModel.postImageUrl,
      'postText' : postModel.postText.toString(),
      'postEmotion' : postModel.postEmotion.toString(),
      'postLocation' : postModel.postLocation.toString(),
      'postEditTime' : postModel.postEditTime.toString(),
      'postIsPublic' : postModel.postIsPublic.toString(),
      'postWeather' : postModel.postWeather.toString(),
    };

    return Success(response: '{"postId": "1", "postUserId": "00", "postImageUrl": "https://item.kakaocdn.net/do/493188dee481260d5c89790036be0e66c37d537a8f2c6f426591be6b8dc7b36a", "postIsPublic": "false", "postEditTime": "2022-05-10 15:47:12.924688", "postText": "hello", "postEmotion": "1", "postWeather": "1", "postLocation": "1"}');

    // call API
    return await _remoteDataSource.putToUri(POST, inputData);
  }
  /// Remote

  /// Local
  /// Get Image From Gallery or Camera
  Future<File?> getImage(String source) async {
    ImageSource imageSource;
    // get image from gallery
    if(source == "gallery") {
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