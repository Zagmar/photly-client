import 'package:couple_seflie_app/data/model/daily_couple_post_model.dart';
import 'package:couple_seflie_app/data/model/post_model.dart';
import 'package:couple_seflie_app/ui/view_model/daily_couple_post_view_model.dart';
import 'package:intl/intl.dart';

import '../datasource/local_datasource.dart';
import '../datasource/remote_datasource.dart';

class DailyCouplePostRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();
  static const String DAILY_POST_LIST = "$PHOTLY/user";

  /// Get dailyCouplePosts
  // input : userId, lastPostDate, nPosts
  // output : dailyPostDate, questionType, questionText, questionImageUrl, userPostId, userPostImageUrl, partnerPostId, partnerPostImageUrl
  Future<Object> getDailyCouplePosts(String userId, String lastPostDate, int nPosts) async {
    // convert inputData to use for API
    Map<String, String> inputData = {
      'userId' : userId,
      'postDate' : lastPostDate,
      'nPosts' : nPosts.toString(),
    };

    // call API
    return await _remoteDataSource.getFromUri(DAILY_POST_LIST, inputData);
  }


  /// Create today's new couplePost
  // input : userId
  Future<Object> createDailyCouplePost(String userId) async {
    // convert inputData to use for API
    Map<String, String> inputData = {
      'userId' : userId,
      'postDate' : DateFormat('yyyyMMdd').format(DateTime.now()).toString(),
    };

    // call API
    return await _remoteDataSource.postToUri(DAILY_POST_LIST, inputData);
  }
}