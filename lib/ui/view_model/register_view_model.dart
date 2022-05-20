import 'package:couple_seflie_app/data/model/auth_credentials_model.dart';
import 'package:flutter/material.dart';

import '../../data/datasource/remote_datasource.dart';
import '../../data/repository/auth_service.dart';

class RegisterViewModel with ChangeNotifier {
  String _email = "";
  String? _password;
  String _username = "";
  late DateTime _anniversary;
  String _userCode = "sdfsdf"; // temp
  String? _partnerCode;
  late String _verificationCode;
  bool _isIdOk = false;
  bool _isPwOk = false;
  bool _isPwCheckOk = false;
  bool _isUsernameOk = false;
  bool _isAnniversaryOk = false;
  bool _isCoupleCodeMatched = false;
  bool _isVerificationOk = false;
  String? _idErrorMessage = '아이디는 필수사항입니다';
  String? _pwErrorMessage = '비밀번호는 필수사항입니다';
  String? _pwCheckErrorMessage = '비밀번호 확인은 필수사항입니다';
  String? _usernameErrorMessage = '닉네임은 필수사항입니다';
  String? _coupleCodeErrorMessage;
  late String _verificationResultMessage;
  late String _registrationResultMessage;
  late AuthService _authService;

  String? get idErrorMessage => _idErrorMessage;
  String? get pwErrorMessage => _pwErrorMessage;
  String? get pwCheckErrorMessage => _pwCheckErrorMessage;
  String? get usernameErrorMessage => _usernameErrorMessage;
  String? get coupleCodeErrorMessage => _coupleCodeErrorMessage;
  String get verificationResultMessage => _verificationResultMessage;
  String get registrationResultMessage => _registrationResultMessage;
  bool get isRegisterOk => _isIdOk && _isPwOk && _isPwCheckOk;
  bool get isUsernameOk => _isUsernameOk;
  bool get isAnniversaryOk => _isAnniversaryOk;
  bool get isCoupleCodeMatched => _isCoupleCodeMatched;
  bool get isVerificationOk => _isVerificationOk;
  String get email => _email;
  String get username => _username;
  String get userCode => _userCode;
  String get verificationCode => _verificationCode;


  checkCode(String str){
    if(str == "") {
      _coupleCodeErrorMessage = "등록할 상대방의 코드를 입력해주세요";
    }
    else {
      _partnerCode = str;
      // temp
      // code 찾기 - 같은 code 찾기, 파트너 없는지 확인
      _isCoupleCodeMatched = true;
      //temp
      if(!_isCoupleCodeMatched){
        _coupleCodeErrorMessage = "잘못된 코드입니다";
      }
      else{
        _coupleCodeErrorMessage = null;
      }
    }
    notifyListeners();
  }

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

  Future<bool> doRegistration() async {
    _authService = AuthService();
    final credentials = RegisterCredential(email: _email, password: _password!, username: _username, anniversary: _anniversary, coupleCode: _partnerCode);
    final result = await _authService.registerService(credentials);

    if(result is Failure){
      _registrationResultMessage = result.errorResponse;
      notifyListeners();
      return false;
    }
    else if(result is Success) {
      _registrationResultMessage = result.response;
      notifyListeners();
      return true;
    }
    else {
      return false;
    }
  }

  setVerificationCode(String verificationCode){
    _verificationCode = verificationCode;
    notifyListeners();
  }

  Future<bool> doVerification() async {
    _authService = AuthService();
    final result = await _authService.verifyService(_email, _verificationCode);

    if(result is Failure){
      _isVerificationOk = false;
      _verificationResultMessage = result.errorResponse;
      notifyListeners();
      return false;
    }
    else if(result is Success) {
      _isVerificationOk = true;
      _verificationResultMessage = result.response;
      notifyListeners();
      return true;
    }
    else {
      _isVerificationOk = false;
      return false;
    }
  }

  clear() {
    _email = "";
    _email = "";
    _password = null;
    _verificationCode = "";
    _isIdOk = false;
    _isPwOk = false;
    _isPwCheckOk = false;
    _isUsernameOk = false;
    _isAnniversaryOk = false;
    _isCoupleCodeMatched = false;
    _isVerificationOk = false;
    notifyListeners();
  }
}