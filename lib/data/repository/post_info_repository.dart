import 'dart:io';
import 'package:couple_seflie_app/data/model/post_model.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../datasource/local_datasource.dart';
import '../datasource/remote_datasource.dart';
import 'auth_service.dart';

class PostInfoRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();
  static const String POST = "$PHOTLY/post";

  Future<Object> readPost(int postId) async {
    Map<String, dynamic> inputData = {
      'post_id' : postId,
    };

    var response = await _remoteDataSource.getFromUri(POST, inputData);
    return response;
  }

  Future<Object> createPost(PostModel postModel) async {
    Map<String, dynamic> inputData = {
      'user_id' : postModel.postUserId,
      'post_text' : postModel.postText??"",
      'post_emotion' : postModel.postEmotion??0,
      'post_location' : postModel.postLocation??"",
      'post_time' : postModel.postEditTime.toString(),
      'post_is_public' : postModel.postIsPublic,
      'post_weather' : postModel.postWeather??0,
    };

    return await _remoteDataSource.postToUri(POST, inputData);
  }

  Future<Object> createS3(File image, String url) async {
    var inputData = image.openRead();

    try{
      final response = await Dio().put(
          url,
          data: inputData,
          options: Options(headers: {
            Headers.contentLengthHeader: await image.length(),
          })
      ).timeout(const Duration(seconds: 600))
          .catchError((e) {
        print(e.message);
      });

      if(response.statusCode == OK) {
        return Success(response: response.data);
      }
      return Failure(code: INVALID_RESPONSE, errorResponse: "Invalid Response");
    } on HttpException{
      return Failure(code: NO_INTERNET, errorResponse: "No Internet");
    } on FormatException{
      return Failure(code: INVALID_FORMAT, errorResponse: "Invalid Format");
    }
    catch(e) {
      return Failure(code: UNKNOWN_ERROR, errorResponse: "Unknown Error");
    }
  }

  Future<Object> updatePost(PostModel postModel) async {
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

    return await _remoteDataSource.putToUri(POST, inputData);
  }

  Future<File?> readImage(ImageSource source) async {
    ImageSource imageSource;
    if(source == ImageSource.gallery) {
      imageSource = ImageSource.gallery;
      return await _localDataSource.getImage(imageSource);
    }
    else {
      imageSource = ImageSource.camera;
      return await _localDataSource.getImage(imageSource);
    }
  }

  Future<Object> deleteUserPostData() async {
    Map<String, dynamic> inputData = {
      'user_id': await AuthService().getCurrentUserId(),
    };

    return await _remoteDataSource.deleteFromUri(POST, inputData);
  }

  Future<Object> downloadImage(String url) async {
    return await _remoteDataSource.downloadFromUrl(url);
  }
}