import '../datasource/remote_datasource.dart';
import 'auth_service.dart';

class DailyCouplePostRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  static const String DAILY_POST_LIST = "$PHOTLY/view";

  Future<Object> getDailyCouplePosts(DateTime lastPostDate, int nPosts) async {
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
      'date_time' : lastPostDate.toString(),
      'n_posts' : nPosts,
    };

    return await _remoteDataSource.getFromUri(DAILY_POST_LIST, inputData);
  }

  Future<Object> createDailyCouplePost() async {
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
      'date_time' : DateTime.now().toString(),
    };

    return await _remoteDataSource.postToUri(DAILY_POST_LIST, inputData);
  }
}