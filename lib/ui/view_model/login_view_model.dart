import 'package:flutter/material.dart';

class LoginViewModel with ChangeNotifier {
  late String _email;
  late String _password;
  late bool _isIdOk;
  late bool _isPwOk;
  String? _idErrorMessage;
  String? _pwErrorMessage;

  String? get idErrorMessage => _idErrorMessage;
  String? get pwErrorMessage => _pwErrorMessage;
  bool get isLoginOk => _isIdOk && _isPwOk;


  checkEmail(String val){
    _email = val;
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
      _idErrorMessage = null;
      _isIdOk = true;
    }
    notifyListeners();
  }

  checkPassword(String val){
    _password = val;
    if(val.isEmpty) {
      _pwErrorMessage = '비밀번호는 필수사항입니다.';
      _isPwOk = false;
    }
    else if(val.length < 8){
      _pwErrorMessage = '8자 이상 입력해주세요!';
      _isPwOk = false;
    }
    else{
      _pwErrorMessage = null;
      _isPwOk = true;
    }
    notifyListeners();
  }

  bool doLogin(){
    // temp
    // 성공 실패
    return true;
  }
}