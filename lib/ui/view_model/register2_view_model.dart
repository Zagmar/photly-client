import 'package:couple_seflie_app/data/model/auth_credentials_model.dart';
import 'package:flutter/material.dart';

import '../../data/datasource/remote_datasource.dart';
import '../../data/repository/auth_service.dart';
import '../../data/repository/user_info_repository.dart';

class Register2ViewModel with ChangeNotifier {
  final _userInfoRepository = UserInfoRepository();

  String _userId = "rjsgy0815@naver.com";
  String _username = "";
  DateTime? _anniversary;
  bool _isUsernameOk = false;
  bool _isAnniversaryOk = false;
  String? _usernameFailMessage = '닉네임은 필수사항입니다';
  String? _anniversaryFailMessage = '날짜를 선택해주세요';

  String? get usernameErrorMessage => _usernameFailMessage;
  String? get anniversaryFailMessage => _anniversaryFailMessage;
  bool get isUsernameOk => _isUsernameOk;
  bool get isAnniversaryOk => _isAnniversaryOk;
  String get username => _username;
  DateTime? get anniversary => _anniversary;

  setAnniversary(DateTime val) {
    _anniversary = val;
    _isAnniversaryOk = true;
    notifyListeners();
  }

  checkUsername(String val){
    if(val.isEmpty) {
      _usernameFailMessage = '닉네임은 필수사항입니다';
      _isUsernameOk = false;
    }
    else{
      _username = val;
      _usernameFailMessage = null;
      _isUsernameOk = true;
    }
    notifyListeners();
  }

  Future<void> uploadUserInfoToDB() async {
    var response = await _userInfoRepository.createUser(_userId, _username, _anniversary!);
  }

  clear() {
    _username = "";
    _anniversary = null;
    _isUsernameOk = false;
    _isAnniversaryOk = false;
    notifyListeners();
  }
}