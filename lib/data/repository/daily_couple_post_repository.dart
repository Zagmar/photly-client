import 'package:couple_seflie_app/data/model/daily_couple_post_model.dart';
import 'package:couple_seflie_app/data/model/post_model.dart';
import 'package:couple_seflie_app/ui/view_model/daily_couple_post_view_model.dart';
import 'package:intl/intl.dart';

import '../datasource/local_datasource.dart';
import '../datasource/remote_datasource.dart';

class DailyCouplePostRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();
  static const String DAILY_POST_LIST = PHOTLY + "photly/view/";

  /// Get dailyCouplePosts
  // input : userId, lastPostDate, nPosts
  // output : dailyPostDate, questionType, questionText, questionImageUrl, userPostId, userPostImageUrl, partnerPostId, partnerPostImageUrl
  Future<Object> getDailyCouplePosts(String userId, DateTime lastPostDate, int nPosts) async {
    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      'user_id' : userId,
      'date_time' : lastPostDate.toString(),
      'n_posts' : nPosts,
    };

    print(inputData);

    return Success(response: '[{"dailyPostDate": "2022-05-09 15:47:12", "questionType": "0", "questionText": "안녕하세요2", "userPostId": 1, "userPostImageUrl": "https://newsimg-hams.hankookilbo.com/2022/04/27/aa7ce712-ba18-4db1-a4d2-23bcad571774.jpg", "partnerPostId": 2, "partnerPostImageUrl": "https://cdnweb01.wikitree.co.kr/webdata/editor/202006/12/img_20200612112834_94fe831a.webp"},{"dailyPostDate": "2022-05-08 15:47:12.924688", "questionType": "1", "questionText": "안녕하세요1", "questionImageUrl": "https://item.kakaocdn.net/do/493188dee481260d5c89790036be0e66c37d537a8f2c6f426591be6b8dc7b36a", "partnerPostId": 2, "partnerPostImageUrl": "https://item.kakaocdn.net/do/493188dee481260d5c89790036be0e66c37d537a8f2c6f426591be6b8dc7b36a"}]');

    // call API
    return await _remoteDataSource.getFromUri(DAILY_POST_LIST, inputData);
  }


  /// Create today's new couplePost
  // input : userId
  Future<Object> createDailyCouplePost(String userId) async {
    // convert inputData to use for API
    Map<String, String> inputData = {
      'user_id' : userId,
      'date_time' : DateTime.now().toString(),
    };

   return Success(response: '[{"dailyPostDate": "2022-05-10 14:27:12", "questionType": "1", "questionText": "안녕하세요3", "questionImageUrl": "https://item.kakaocdn.net/do/493188dee481260d5c89790036be0e66c37d537a8f2c6f426591be6b8dc7b36a"}]');

    // call API
    return await _remoteDataSource.postToUri(DAILY_POST_LIST, inputData);
  }
}