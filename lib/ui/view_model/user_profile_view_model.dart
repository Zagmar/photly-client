import 'package:couple_seflie_app/data/datasource/remote_datasource.dart';
import 'package:couple_seflie_app/data/model/user_credentials_model.dart';
import 'package:couple_seflie_app/data/repository/user_info_repository.dart';
import 'package:flutter/cupertino.dart';

class UserProfileViewModel extends ChangeNotifier {
  UserCredentialsModel? _userCredentials = UserCredentialsModel();
  int? _coupleDays;

  final UserInfoRepository _infoRepository = UserInfoRepository();

  String? get userName => _userCredentials!.userName;
  DateTime? get coupleAnniversary => _userCredentials!.coupleAnniversary;
  int? get coupleDays => _coupleDays;

  Future<void> setCurrentUser() async {
    var response = await _infoRepository.getUserInfo();

    if(response is Success) {
      _userCredentials = UserCredentialsModel.fromJson(response.response);
      _coupleDays = DateTime.now().difference(_userCredentials!.coupleAnniversary!).inDays;
    }

    if(response is Failure){
      _userCredentials!.userName = "Unknown";
      _userCredentials!.coupleAnniversary = DateTime.now();
      _coupleDays = 0;
    }
  }
}