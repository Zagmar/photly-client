import 'package:couple_seflie_app/data/datasource/remote_datasource.dart';
import 'package:couple_seflie_app/data/repository/user_info_repository.dart';
import 'package:flutter/cupertino.dart';

class UserProfileViewModel extends ChangeNotifier {
  String? _userName;
  DateTime? _userEnrolledDate;
  DateTime? _coupleAnniversary;
  int? _days;

  final UserInfoRepository _infoRepository = UserInfoRepository();

  String? get userName => _userName;
  DateTime? get coupleAnniversary => _coupleAnniversary;
  int? get days => _days;

  Future<void> setCurrentUser() async {
    var response = await _infoRepository.getUserInfo();

    if(response is Success) {
      _userName = response.response["userName"];
      _coupleAnniversary = DateTime.parse(response.response["coupleAnniversary"]);
      _days = DateTime.now().difference(_coupleAnniversary!).inDays;
    }

    if(response is Failure){
      _userName = "#unknown";
      _coupleAnniversary = null;
    }
  }
}