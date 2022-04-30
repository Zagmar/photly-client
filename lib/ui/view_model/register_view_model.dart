import 'package:flutter/material.dart';

class RegisterViewModel with ChangeNotifier {
  String _email = "";
  late String _password;
  late String _passwordCheck;
  String _username = "";
  late DateTime _anniversary;
  String _userCode = "sdfsdf"; // temp
  late String _inputCode;
  bool _isIdOk = false;
  bool _isPwOk = false;
  bool _isPwCheckOk = false;
  bool _isUsernameOk = false;
  bool _isAnniversaryOk = false;
  bool _isCodeMatched = false;
  String? _idErrorMessage = '아이디는 필수사항입니다';
  String? _pwErrorMessage = '비밀번호는 필수사항입니다';
  String? _pwCheckErrorMessage = '비밀번호 확인은 필수사항입니다';
  String? _usernameErrorMessage = '닉네임은 필수사항입니다';
  String? _codeErrorMessage;

  String? get idErrorMessage => _idErrorMessage;
  String? get pwErrorMessage => _pwErrorMessage;
  String? get pwCheckErrorMessage => _pwCheckErrorMessage;
  String? get usernameErrorMessage => _usernameErrorMessage;
  String? get codeErrorMessage => _codeErrorMessage;
  bool get isRegisterOk => _isIdOk && _isPwOk && _isPwCheckOk;
  bool get isUsernameOk => _isUsernameOk;
  bool get isAnniversaryOk => _isAnniversaryOk;
  bool get isCodeMatched => _isCodeMatched;
  String get email => _email;
  String get username => _username;
  String get userCode => _userCode;

  bool doRegistration() {
    // temp
    // 회원가입 진행 - amplifier
    return true;
  }

  checkCode(String inputCode){
    _inputCode = inputCode;
    // temp
    // code 찾기 - 같은 code 찾기, 파트너 없는지 확인
    _isCodeMatched = true;
    //temp
    if(!_isCodeMatched){
      _codeErrorMessage = "잘못된 코드입니다";
    }
    else{
      _codeErrorMessage = null;
    }
    notifyListeners();
  }

  setAnniversary(DateTime val) {
    _anniversary = val;
    _isAnniversaryOk = true;
    notifyListeners();
  }

  checkUsername(String val){
    _username = val;
    if(val.isEmpty) {
      _usernameErrorMessage = '닉네임은 필수사항입니다';
      _isUsernameOk = false;
    }
    else{
      _usernameErrorMessage = null;
      _isUsernameOk = true;
    }
    notifyListeners();
  }

  checkEmail(String val){
    _email = val;
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
      _idErrorMessage = null;
      _isIdOk = true;
    }
    notifyListeners();
  }

  checkPassword(String val){
    _password = val;
    if(val.isEmpty) {
      _pwErrorMessage = '비밀번호는 필수사항입니다';
      _isPwOk = false;
    }
    else if(val.length < 8){
      _pwErrorMessage = '8자 이상 입력해주세요';
      _isPwOk = false;
    }
    else{
      _pwErrorMessage = null;
      _isPwOk = true;
    }
    notifyListeners();
  }

  checkPasswordCheck(String val){
    _passwordCheck = val;
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
}