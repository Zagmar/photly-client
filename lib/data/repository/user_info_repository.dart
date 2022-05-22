import '../datasource/local_datasource.dart';
import '../datasource/remote_datasource.dart';

class UserInfoRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();
  static const String USER = "$PHOTLY/user/info";

  /// Get post
  // input : postId
  // output : postModel
  Future<Object> getUserInfo(String userId) async {
    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      'user_id' : userId,
    };
    // call API
    var response = await _remoteDataSource.getFromUri(USER, inputData);
    return response;
    return await _remoteDataSource.getFromUri(USER, inputData);
  }

  /// Create post
  // input : postModel
  Future<Object> createUser(String userId, String userName, DateTime coupleAnniversary) async {
    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      'user_id' : userId,
      'user_name' : userName,
      'user_enrolled_date' : DateTime.now().toString(),
      'couple_anniversary' : coupleAnniversary.toString(),
    };

    return await _remoteDataSource.postToUri(USER, inputData);
  }
}