import 'package:couple_seflie_app/data/model/auth_credentials_model.dart';
import 'package:flutter/material.dart';

import '../../data/datasource/remote_datasource.dart';
import '../../data/repository/auth_service.dart';

class Register3ViewModel with ChangeNotifier {
  String _userCode = "sdfsdf"; // temp
  bool _isCoupleCodeMatched = false;

  String? _coupleCodeErrorMessage;

  String? get coupleCodeErrorMessage => _coupleCodeErrorMessage;
  bool get isCoupleCodeMatched => _isCoupleCodeMatched;
  String get userCode => _userCode;


  checkCode(String str) async {
    if(str == "") {
      _coupleCodeErrorMessage = "등록할 상대방의 코드를 입력해주세요";
    }
    else {
      str;
      var response = Failure(code: 1, errorResponse: "errorResponse") ;
      // temp
      // code 찾기 - 같은 code 찾기, 파트너 없는지 확인
      //temp
      if(response is Failure){
        _isCoupleCodeMatched = false;
        _coupleCodeErrorMessage = "잘못된 코드입니다";
      }
      else{
        _isCoupleCodeMatched = true;
        _coupleCodeErrorMessage = null;
      }
    }
    notifyListeners();
  }

  clear() {
    _isCoupleCodeMatched = false;
    notifyListeners();
  }
}