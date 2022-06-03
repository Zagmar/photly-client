import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:couple_seflie_app/data/model/auth_credentials_model.dart';
import 'package:flutter/material.dart';

import '../../data/datasource/remote_datasource.dart';
import '../../data/repository/auth_service.dart';
import '../../data/repository/user_info_repository.dart';

class Register2ViewModel with ChangeNotifier {
  final _userInfoRepository = UserInfoRepository();

  String _username = "";
  DateTime? _anniversary;
  bool _isUsernameOk = false;
  bool _isAnniversaryOk = false;
  bool _isUploaded = false;
  String? _usernameErrorMessage = '닉네임은 필수사항입니다';
  String? _anniversaryErrorMessage = '날짜를 선택해주세요';
  String? _uploadFailMessage = "다시 시도해주세요";

  String? get usernameErrorMessage => _usernameErrorMessage;
  String? get anniversaryErrorMessage => _anniversaryErrorMessage;
  bool get isUsernameOk => _isUsernameOk;
  bool get isAnniversaryOk => _isAnniversaryOk;
  String get username => _username;
  DateTime? get anniversary => _anniversary;
  bool get isUploaded => _isUploaded;
  String? get uploadFailMessage => _uploadFailMessage;

  setAnniversary(DateTime val) {
    _anniversary = val;
    _isAnniversaryOk = true;
    notifyListeners();
  }

  checkUsername(String val){
    if(val.isEmpty) {
      _usernameErrorMessage = '닉네임은 필수사항입니다';
      _isUsernameOk = false;
    }
    else{
      _username = val;
      _usernameErrorMessage = null;
      _isUsernameOk = true;
    }
    notifyListeners();
  }

  Future<void> uploadUserInfoToDB() async {
    print("_userId");
    var response = await _userInfoRepository.createUserInfo(_username, _anniversary!);
    if(response is Success) {
      _isUploaded = true;
      _uploadFailMessage = null;
    }
    else {
      _isUploaded = false;
      _uploadFailMessage = "요청을 실패하였습니다.";
    }
    notifyListeners();
  }

  clear() {
    _username = "";
    _anniversary = null;
    _isUsernameOk = false;
    _isAnniversaryOk = false;
    notifyListeners();
  }
}