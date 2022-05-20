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
      //'user_id' : userId,
      'user_id' : 1, // test
    };
    // call API
    var response = await _remoteDataSource.getFromUri(USER, inputData);
    print("PostInfoRepository성공");
    print(response);
    return response;
    return await _remoteDataSource.getFromUri(USER, inputData);
  }


}