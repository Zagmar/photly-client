import '../datasource/local_datasource.dart';
import '../datasource/remote_datasource.dart';

class UserInfoRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();

  /*
  /// 로컬에서 사용자 정보를 불러옴
  Future<UserInfoModel> getCurrentUser() {
    return _localDataSource.getCurrentUser();
  }

  /// input : userId, userPw
  /// output : userName, userEnrolledDate, CoupleCode
  Future<Object> getUser() {
    return _remoteDataSource.getUserInfo();
  }

   */
}