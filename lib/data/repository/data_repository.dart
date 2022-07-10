import '../datasource/remote_datasource.dart';
import 'auth_service.dart';

class DataRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  static const String DATA = "$PHOTLY/user/data";

  Future<void> sendExecutionPoint() async {
    print("sendExecutionPoint");
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
      'date_time' : DateTime.now(),
      'data_type' : 1,
    };

    await _remoteDataSource.getFromUri(DATA, inputData);
  }

  Future<void> sendPeriodically() async {
    print("sendPeriodically");
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
      'data_type' : 2,
    };
    await _remoteDataSource.getFromUri(DATA, inputData);
  }

  Future<void> sendPostPoint() async {
    print("sendPostPoint");
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
      'date_time' : DateTime.now(),
      'data_type' : 3,
    };
    await _remoteDataSource.getFromUri(DATA, inputData);
  }

  Future<void> sendReadPoint() async {
    print("sendReadPoint");
    Map<String, dynamic> inputData = {
      'user_id' : await AuthService().getCurrentUserId(),
      'date_time' : DateTime.now(),
      'data_type' : 4,
    };
    await _remoteDataSource.getFromUri(DATA, inputData);
  }
}