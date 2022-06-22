import '../datasource/local_datasource.dart';
import '../datasource/remote_datasource.dart';
import 'auth_service.dart';

class UserInfoRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();
  static const String USER = "$PHOTLY/user/info";
  static const String USER_PARTNER = "$PHOTLY/user/partner";

  /// Create post
  // input : postModel
  Future<Object> createUserInfo(String userName, DateTime coupleAnniversary) async {
    print("_userId");
    String _userId = await AuthService().getCurrentUserId();
    print(_userId);
    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      'user_id' : _userId,
      'user_name' : userName,
      'user_enrolled_date' : DateTime.now().toString(),
      'couple_anniversary' : coupleAnniversary.toString(),
    };

    print(inputData);

    return await _remoteDataSource.postToUri(USER, inputData);
  }

  Future<Object> updateUsername(String username) async {
    String _userId = await AuthService().getCurrentUserId();
    Map<String, dynamic> inputData = {
      'user_id' : _userId,
      'user_name' : username,
    };

    print(inputData);

    return await _remoteDataSource.putToUri(USER, inputData);
  }

  Future<Object> updateAnniversary(DateTime coupleAnniversary) async {
    String _userId = await AuthService().getCurrentUserId();
    Map<String, dynamic> inputData = {
      'user_id' : _userId,
      'couple_anniversary' : coupleAnniversary.toString(),
    };

    print(inputData);

    return await _remoteDataSource.putToUri(USER, inputData);
  }

  /// Create post
  // input : postModel
  Future<Object> registerPartner(String coupleCode) async {
    print("여기3");
    String _userId = await AuthService().getCurrentUserId();
    print("여기4");

    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      'user_id' : _userId.toString(),
      'couple_code' : coupleCode.toString(),
      'couple_enrolled_date' : DateTime.now().toString()
    };

    print(inputData);

    return await _remoteDataSource.putToUri(USER_PARTNER, inputData);
  }

  /// Create post
  // input : postModel
  Future<Object> getPartner() async {
    String _userId = await AuthService().getCurrentUserId();

    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      'user_id' : _userId,
    };

    print("get Partner");
    print(inputData);

    return await _remoteDataSource.getFromUri(USER_PARTNER, inputData);
  }

  /// Clear post
  // input : postModel
  Future<Object> getUserInfo() async {
    String _userId = await AuthService().getCurrentUserId();

    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      'user_id' : _userId,
    };

    print(inputData);

    return await _remoteDataSource.getFromUri(USER, inputData);
  }

  Future<Object> clearPartner() async {
    String _userId = await AuthService().getCurrentUserId();

    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      'user_id' : _userId.toString(),
    };

    print(inputData);

    return await _remoteDataSource.deleteFromUri(USER_PARTNER, inputData);
  }

  Future<Object> clearUser() async {
    String _userId = await AuthService().getCurrentUserId();

    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      'user_id' : _userId.toString(),
    };

    print(inputData);

    return await _remoteDataSource.deleteFromUri(USER, inputData);
  }
}