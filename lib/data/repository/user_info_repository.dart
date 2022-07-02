import '../datasource/remote_datasource.dart';
import 'auth_service.dart';

class UserInfoRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  static const String USER = "$PHOTLY/user/info";
  static const String USER_PARTNER = "$PHOTLY/user/partner";

  Future<Object> createUserInfo(String userName, DateTime coupleAnniversary) async {
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
      'user_name' : userName,
      'user_enrolled_date' : DateTime.now().toString(),
      'couple_anniversary' : coupleAnniversary.toString(),
    };
    return await _remoteDataSource.postToUri(USER, inputData);
  }

  Future<Object> updateUsername(String username) async {
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
      'user_name' : username,
    };
    return await _remoteDataSource.putToUri(USER, inputData);
  }

  Future<Object> updateAnniversary(DateTime coupleAnniversary) async {
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
      'couple_anniversary' : coupleAnniversary.toString(),
    };
    return await _remoteDataSource.putToUri(USER, inputData);
  }

  Future<Object> registerPartner(String coupleCode) async {
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
      'couple_code' : coupleCode,
      'couple_enrolled_date' : DateTime.now().toString()
    };
    return await _remoteDataSource.putToUri(USER_PARTNER, inputData);
  }

  Future<Object> getPartner() async {
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
    };
    return await _remoteDataSource.getFromUri(USER_PARTNER, inputData);
  }

  Future<Object> getUserInfo() async {
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
    };
    return await _remoteDataSource.getFromUri(USER, inputData);
  }

  Future<Object> clearPartner() async {
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
    };
    return await _remoteDataSource.deleteFromUri(USER_PARTNER, inputData);
  }

  Future<Object> clearUser() async {
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
    };
    return await _remoteDataSource.deleteFromUri(USER, inputData);
  }
}