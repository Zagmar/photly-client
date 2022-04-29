import '../datasource/local_datasource.dart';
import '../datasource/remote_datasource.dart';

class UserInfoRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();


}