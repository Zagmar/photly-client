import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:couple_seflie_app/data/repository/user_info_repository.dart';
import 'package:flutter/material.dart';

import '../../data/datasource/remote_datasource.dart';
import '../../data/repository/auth_service.dart';

class UserViewModel with ChangeNotifier {
  String? _logoutFailMessage;
  late AuthService _authService;

  String? get logoutFailMessage => _logoutFailMessage;

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
}