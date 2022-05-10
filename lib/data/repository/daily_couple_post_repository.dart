import 'package:couple_seflie_app/data/model/daily_couple_post_model.dart';
import 'package:couple_seflie_app/data/model/post_model.dart';
import 'package:couple_seflie_app/ui/view_model/daily_couple_post_view_model.dart';
import 'package:intl/intl.dart';

import '../datasource/local_datasource.dart';
import '../datasource/remote_datasource.dart';

class DailyCouplePostRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();
  static const String DAILY_POST_LIST = "$PHOTLY/view";

  /// Get dailyCouplePosts
  // input : userId, lastPostDate, nPosts
  // output : dailyPostDate, questionType, questionText, questionImageUrl, userPostId, userPostImageUrl, partnerPostId, partnerPostImageUrl
  Future<Object> getDailyCouplePosts(String userId, DateTime lastPostDate, int nPosts) async {
    // convert inputData to use for API
    Map<String, String> inputData = {
      'userId' : userId,
      'postDate' : lastPostDate.toString(),
      'nPosts' : nPosts.toString(),
    };

    return Success(response: '[{"dailyPostDate": "2022-05-09 15:47:12.924688", "questionType": "0", "questionText": "안녕하세요2", "userPostId": "1", "userPostImageUrl": "https://item.kakaocdn.net/do/493188dee481260d5c89790036be0e66c37d537a8f2c6f426591be6b8dc7b36a", "partnerPostId": "2", "partnerPostImageUrl": "https://item.kakaocdn.net/do/493188dee481260d5c89790036be0e66c37d537a8f2c6f426591be6b8dc7b36a"},{"dailyPostDate": "2022-05-08 15:47:12.924688", "questionType": "1", "questionText": "안녕하세요1", "questionImageUrl": "https://item.kakaocdn.net/do/493188dee481260d5c89790036be0e66c37d537a8f2c6f426591be6b8dc7b36a", "partnerPostId": "2", "partnerPostImageUrl": "https://item.kakaocdn.net/do/493188dee481260d5c89790036be0e66c37d537a8f2c6f426591be6b8dc7b36a"}]');

    // call API
    return await _remoteDataSource.getFromUri(DAILY_POST_LIST, inputData);
  }


  /// Create today's new couplePost
  // input : userId
  Future<Object> createDailyCouplePost(String userId) async {
    // convert inputData to use for API
    Map<String, String> inputData = {
      'userId' : userId,
      'postDate' : DateTime.now().toString(),
    };

   return Success(response: '[{"dailyPostDate": "2022-05-10 14:27:12.924688", "questionType": "1", "questionText": "안녕하세요3", "questionImageUrl": "https://item.kakaocdn.net/do/493188dee481260d5c89790036be0e66c37d537a8f2c6f426591be6b8dc7b36a"}]');

    // call API
    return await _remoteDataSource.postToUri(DAILY_POST_LIST, inputData);
  }
}