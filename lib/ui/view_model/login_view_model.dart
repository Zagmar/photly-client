import 'package:couple_seflie_app/data/datasource/remote_datasource.dart';
import 'package:couple_seflie_app/data/repository/auth_service.dart';
import 'package:flutter/material.dart';

import '../../data/model/auth_credentials_model.dart';

class LoginViewModel with ChangeNotifier {
  String _email = "";
  String _password = "";
  bool _isIdOk = false;
  bool _isPwOk = false;
  String? _idErrorMessage = '이메일은 필수사항입니다.';
  String? _pwErrorMessage = '비밀번호는 필수사항입니다.';
  String? _loginFailMessage;
  late AuthService _authService;

  String? get idErrorMessage => _idErrorMessage;
  String? get pwErrorMessage => _pwErrorMessage;
  String? get loginFailMessage => _loginFailMessage;
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
    else{
      _pwErrorMessage = null;
      _isPwOk = true;
    }
    notifyListeners();
  }

  Future<bool> doLogin() async {
    _authService = AuthService();
    final credentials = LoginCredential(email: _email, password: _password);
    final result = await _authService.loginService(credentials);

    if(result is Failure){
      _loginFailMessage = result.errorResponse;
      notifyListeners();
      return false;
    }
    else {
      // result = Success
      _loginFailMessage = null;
      notifyListeners();
      return true;
    }
  }

  clear() {
    _email = "";
    _password = "";
    notifyListeners();
  }
}