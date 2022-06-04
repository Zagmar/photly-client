import 'package:couple_seflie_app/data/datasource/remote_datasource.dart';
import 'package:couple_seflie_app/data/repository/user_info_repository.dart';
import 'package:flutter/cupertino.dart';

class UserProfileViewModel extends ChangeNotifier {
  String? _userName;
  String? _userImageUrl;
  DateTime? _userEnrolledDate;
  DateTime? _coupleAnniversary;

  final UserInfoRepository _infoRepository = UserInfoRepository();

  String? get userName => _userName;
  String? get userImageUrl => _userImageUrl;

  Future<void> setCurrentUser() async {
    var response = await _infoRepository.getUserInfo();

    if(response is Success) {
      _userName = response.response["userName"];
      _userEnrolledDate = response.response["userEnrrolledDate"];
      notifyListeners();
    }

    if(response is Failure){
      _userName = "#unknown";
      _userEnrolledDate = DateTime.now();
      notifyListeners();
    }
  }
}