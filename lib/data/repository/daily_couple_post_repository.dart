import '../datasource/local_datasource.dart';
import '../datasource/remote_datasourcee.dart';

class DailyCouplePostRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();
  static const String DAILY_POST_LIST = "https://jsonplaceholder.typicode.com/users";

  /// input : nPosts, date
  /// output : postImageUrl, postUserId, postIsPublic, postEditTime, postText, postEmotion, postWeather, postLocation
  /// PostList 불러오기
  Future<Object> getDailyPosts(DateTime lastPostDate, int nPosts) async {
    return await _remoteDataSource.getFromUri(DAILY_POST_LIST);
  }
}