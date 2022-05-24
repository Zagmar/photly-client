import 'package:couple_seflie_app/data/model/auth_credentials_model.dart';
import 'package:flutter/material.dart';

import '../../data/datasource/remote_datasource.dart';
import '../../data/repository/auth_service.dart';

class Register1ViewModel with ChangeNotifier {
  String? _email;
  String? _password;

  bool _isIdOk = false;
  bool _isPwOk = false;
  bool _isPwCheckOk = false;
  bool _isRegistered = false;
  String? _idErrorMessage = '아이디는 필수사항입니다';
  String? _pwErrorMessage = '비밀번호는 필수사항입니다';
  String? _pwCheckErrorMessage = '비밀번호 확인은 필수사항입니다';
  String? _registrationFailMessage;
  late AuthService _authService;

  String? get idErrorMessage => _idErrorMessage;
  String? get pwErrorMessage => _pwErrorMessage;
  String? get pwCheckErrorMessage => _pwCheckErrorMessage;
  bool get isRegisterOk => _isIdOk && _isPwOk && _isPwCheckOk;
  bool get isRegistered => _isRegistered;
  String? get registrationFailMessage => _registrationFailMessage;

  // Check Email Input
  checkEmail(String val){
    if(val.isEmpty) {
      _idErrorMessage = '이메일은 필수사항입니다';
      _isIdOk = false;
    }
    else if(!RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(val)){
      _idErrorMessage = '잘못된 이메일 형식입니다';
      _isIdOk = false;
    }
    else{
      _email = val;
      _idErrorMessage = null;
      _isIdOk = true;
    }
    notifyListeners();
  }

  // Check Password Input
  checkPassword(String val){
    if(val.isEmpty) {
      _pwErrorMessage = '비밀번호는 필수사항입니다';
      _isPwOk = false;
    }
    else if(!RegExp(
        r'^([A-Za-z0-9]{8,})$')
        .hasMatch(val)){
      _pwErrorMessage = '비밀번호는 숫자와 문자가 포함된 8자 이상으로 등록해주세요';
      _isPwOk = false;
    }
    else{
      _password = val;
      _pwErrorMessage = null;
      _isPwOk = true;
    }
    notifyListeners();
  }

  // Check Password Check Input
  checkPasswordCheck(String val){
    if(val.isEmpty) {
      _pwCheckErrorMessage = '비밀번호 확인은 필수사항입니다';
      _isPwCheckOk = false;
    }
    else if(val != _password){
      _pwCheckErrorMessage = '비밀번호가 일치하지 않습니다';
      _isPwCheckOk = false;
    }
    else{
      _pwCheckErrorMessage = null;
      _isPwCheckOk = true;
    }
    notifyListeners();
  }

  Future<void> doRegistration() async {
    _authService = AuthService();
    final credentials = UserCredentialsModel(email: _email!, password: _password!);
    final response = await _authService.registerService(credentials);

    if(response == SignUpStatus.success){
      _isRegistered = true;
      _registrationFailMessage = null;
      notifyListeners();
    }
    else if(response == SignUpStatus.existUser) {
      _isRegistered = false;
      _registrationFailMessage = "이미 가입된 사용자입니다";
      notifyListeners();
    }
    else {
      _isRegistered = false;
      _registrationFailMessage = "재시도 후 지속적으로 오류가 발생 시 문의해주세요";
      notifyListeners();
    }
  }

  clear() {
    _email = null;
    _password = null;
    _isIdOk = false;
    _isPwOk = false;
    _isPwCheckOk = false;
    _isRegistered = false;
    notifyListeners();
  }
}