import 'package:flutter/material.dart';

import '../../data/datasource/remote_datasource.dart';
import '../../data/model/auth_credentials_model.dart';
import '../../data/repository/auth_service.dart';

class UserInfoViewModel with ChangeNotifier {
  String? _email;
  String? _password;
  String? _verificationCode;
  bool _isIdOk = false;
  bool _isPwOk = false;
  bool _isPwCheckOk = false;
  bool _isVerificationCodeOk = false;
  bool _isRegistered = false;
  bool _isVerified = false;
  String? _loginFail;
  String? _idErrorMessage = '이메일은 필수사항입니다.';
  String? _pwErrorMessage = '비밀번호는 필수사항입니다.';
  String? _pwCheckErrorMessage = '비밀번호 확인은 필수사항입니다';
  String? _verificationCodeErrorMessage = '인증코드 입력은 필수사항입니다';
  String? _loginFailMessage;
  String? _logoutFailMessage;
  String? _registrationFailMessage;
  String? _verificationFailMessage;

  late AuthService _authService;

  String? get idErrorMessage => _idErrorMessage;
  String? get pwErrorMessage => _pwErrorMessage;
  String? get pwCheckErrorMessage => _pwCheckErrorMessage;
  String? get verificationCodeErrorMessage => _verificationCodeErrorMessage;
  String? get loginFailMessage => _loginFailMessage;
  String? get logoutFailMessage => _logoutFailMessage;
  String? get registrationFailMessage => _registrationFailMessage;
  String? get verificationFailMessage => _verificationFailMessage;
  bool get isLoginOk => _isIdOk && _isPwOk;
  bool get isRegisterOk => _isIdOk && _isPwOk && _isPwCheckOk;
  bool get isVerificationCodeOk => _isVerificationCodeOk;
  String? get loginFail => _loginFail;
  bool get isVerified => _isVerified;
  bool get isRegistered => _isRegistered;

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
    if(val.isEmpty) {
      _pwErrorMessage = '비밀번호는 필수사항입니다.';
      _isPwOk = false;
    }
    else if(!RegExp(
        r'^([A-Za-z0-9]{8,})$')
        .hasMatch(val)){
      _pwErrorMessage = '비밀번호는 숫자와 문자가 1개 이상 포함된 8자 이상입니다';
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
      _pwCheckErrorMessage = '비밀번호를 다시 확인해주세요';
      _isPwCheckOk = false;
    }
    else{
      _pwCheckErrorMessage = null;
      _isPwCheckOk = true;
    }
    notifyListeners();
  }

  // Check Verification Code
  checkVerificationCode(String val){
    if(val.isEmpty) {
      _verificationCodeErrorMessage = '인증코드를 입력해주세요';
      _isVerificationCodeOk = false;
    }
    else if(!RegExp(
        r'^([0-9]{6,6})$')
        .hasMatch(val)){
      _verificationCodeErrorMessage = '인증코드는 6자리 숫자입니다';
      _isVerificationCodeOk = false;
    }
    else{
      _verificationCode = val;
      _verificationCodeErrorMessage = null;
      _isVerificationCodeOk = true;
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

  Future<void> doVerification() async {
    print("checkVerification");
    _authService = AuthService();
    final result = await _authService.verificationService(_email!, _verificationCode!);
    print(result);

    if(result == VerifyStatus.success){
      _verificationFailMessage = null;
      _isVerified = true;
      notifyListeners();
    }
    else {
      _verificationFailMessage = "인증에 실패했습니다";
      _isVerified = false;
      notifyListeners();
    }
  }

  Future<void> doLogin() async {
    _authService = AuthService();
    final credentials = UserCredentialsModel(email: _email!, password: _password!);
    final result = await _authService.loginService(credentials);

    if(result == LoginStatus.success){
      _loginFailMessage = null;
      _loginFail = "success";
      print(_loginFail);
      notifyListeners();
    }
    else if(result == LoginStatus.nonVerification) {
      _loginFailMessage = "인증을 완료해주세요";
      _loginFail = "nonVerification";
      print(_loginFail);
      notifyListeners();
    }
    else if(result == LoginStatus.nonUserInfo) {
      _loginFailMessage = "사용자 정보 입력을 완료해주세요";
      _loginFail = "nonUserInfo";
      print(_loginFail);
      notifyListeners();
    }
    else if(result == LoginStatus.fail){
      _loginFailMessage = "일치하는 사용자 정보가 없습니다";
      _loginFail = "fail";
      print(_loginFail);
      notifyListeners();
    }
    else {
      _loginFailMessage = "재시도 후 지속적으로 오류가 발생 시 문의해주세요";
      _loginFail = "fail";
      notifyListeners();
    }
  }

  Future<bool> doLogout() async {
    _authService = AuthService();
    final result = await _authService.logOutService();

    if(result is Failure){
      _logoutFailMessage = result.errorResponse;
      notifyListeners();
      return false;
    }
    else {
      _logoutFailMessage = null;
      notifyListeners();
      return true;
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

  clearSecret(){
    _password = null;
  }
}