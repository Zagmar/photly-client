import '../datasource/local_datasource.dart';
import '../datasource/remote_datasource.dart';

class UserInfoRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();
  static const String USER = "$PHOTLY/user/info";

  /// Create post
  // input : postModel
  Future<Object> createUserInfo(String userId, String userName, DateTime coupleAnniversary) async {
    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      'user_id' : userId,
      'user_name' : userName,
      'user_enrolled_date' : DateTime.now().toString(),
      'couple_anniversary' : coupleAnniversary.toString(),
    };

    print(inputData);

    return await _remoteDataSource.postToUri(USER, inputData);
  }
}