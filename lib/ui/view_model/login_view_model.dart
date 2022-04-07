import 'package:couple_seflie_app/data/model/user_info_model.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  UserInfoModel? _userInfoModel;
  //LoginError? _loginError;

  bool get isLoading => _isLoading;
  UserInfoModel? get userInfoModel => _userInfoModel;
  //LoginError? get loginError => _loginError;

  setIsLoading(bool isLoading) async {
    _isLoading = isLoading;
    notifyListeners();
  }

  setUserInfoModel(UserInfoModel userInfoModel) async {
    _userInfoModel = userInfoModel;
  }

  /*
  setLoginError(LoginError loginError) async {
    _loginError = loginError;
  }
  */
}