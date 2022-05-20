import 'package:couple_seflie_app/data/repository/auth_service.dart';
import 'package:flutter/material.dart';

import '../../data/model/auth_credentials_model.dart';

class LoginViewModel with ChangeNotifier {
  String _email = "";
  String _password = "";
  bool _isIdOk = false;
  bool _isPwOk = false;
  String? _loginFail;
  bool _isVerified = false;
  String? _idErrorMessage = '이메일은 필수사항입니다.';
  String? _pwErrorMessage = '비밀번호는 필수사항입니다.';
  String? _loginFailMessage;
  String? _verificationFailMessage;
  late AuthService _authService;

  String? get idErrorMessage => _idErrorMessage;
  String? get pwErrorMessage => _pwErrorMessage;
  String? get loginFailMessage => _loginFailMessage;
  String? get verificationFailMessage => _verificationFailMessage;
  bool get isLoginOk => _isIdOk && _isPwOk;
  String? get loginFail => _loginFail;
  bool get isVerified => _isVerified;

  // Check Email Input
  checkEmail(String val){
    if(val.isEmpty) {
      _idErrorMessage = '이메일은 필수사항입니다.';
      _isIdOk = false;
    }
    else if(!RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(val)){
      _idErrorMessage = '잘못된 이메일 형식입니다.';
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
    print(val);
    if(val.isEmpty) {
      _pwErrorMessage = '비밀번호는 필수사항입니다.';
      _isPwOk = false;
    }
    else if(!RegExp(
        r'^([A-Za-z0-9]{8,})$')
        .hasMatch(val)){
      _pwErrorMessage = '비밀번호는 숫자와 문자가 포함된 8자 이상입니다';
      _isPwOk = false;
    }
    else{
      _password = val;
      _pwErrorMessage = null;
      _isPwOk = true;
    }
    notifyListeners();
  }

  Future<void> checkVerification() async {
    _authService = AuthService();
    final credentials = UserCredentialsModel(email: _email, password: _password);
    final result = await _authService.loginService(credentials);

    if(result == LoginStatus.success){
      _verificationFailMessage = null;
      _isVerified = true;
      notifyListeners();
    }
    else {
      _verificationFailMessage = "인증이 완료되지 않았습니다";
      _isVerified = false;
      notifyListeners();
    }
  }

  Future<void> doLogin() async {
    _authService = AuthService();
    final credentials = UserCredentialsModel(email: _email, password: _password);
    final result = await _authService.loginService(credentials);

    if(result == LoginStatus.success){
      _loginFailMessage = null;
      _loginFail = "success";
      notifyListeners();
    }
    else if(result == LoginStatus.nonVerification) {
      _loginFailMessage = "인증을 완료해주세요";
      _loginFail = "nonVerification";
      notifyListeners();
    }
    else if(result == LoginStatus.nonUserInfo) {
      _loginFailMessage = "사용자 정보 입력을 완료해주세요";
      _loginFail = "nonUserInfo";
      notifyListeners();
    }
    else if(result == LoginStatus.fail){
      _loginFailMessage = "일치하는 사용자 정보가 없습니다";
      _loginFail = "fail";
      notifyListeners();
    }
    else {
      _loginFailMessage = "재시도 후 지속적으로 오류가 발생 시 문의해주세요";
      _loginFail = "fail";
      notifyListeners();
    }
  }

  clear() {
    _email = "";
    _password = "";
    notifyListeners();
  }
}