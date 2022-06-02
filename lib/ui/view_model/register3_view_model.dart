import 'package:flutter/material.dart';

import '../../data/datasource/remote_datasource.dart';
import '../../data/repository/user_info_repository.dart';

class Register3ViewModel with ChangeNotifier {
  final _userInfoRepository = UserInfoRepository();

  String _userCode = ""; // temp
  String? _coupleCode; // temp
  bool _isCoupleCodeMatched = false;
  bool _isUserCoupleCodeOk = false;
  bool _isCoupleCoupleCodeOk = false;

  String? _coupleCodeErrorMessage;
  String? _coupleCodeMatchFailMessage;

  String? get coupleCodeErrorMessage => _coupleCodeErrorMessage;
  String? get coupleCodeMatchFailMessage => _coupleCodeMatchFailMessage;
  bool get isCoupleCodeMatched => _isCoupleCodeMatched;
  bool get isUserCoupleCodeOk => _isUserCoupleCodeOk;
  bool get isCoupleCoupleCodeOk => _isCoupleCoupleCodeOk;
  String get userCode => _userCode;

  setUserCoupleCode() async {
    var response = await _userInfoRepository.getUserInfo();
    if(response is Failure){
      _userCode = "로드를 실패했습니다";
      _isUserCoupleCodeOk = false;
    }
    if(response is Success){
      _userCode = response.response["coupleCode"];
      _isUserCoupleCodeOk = true;
    }
    notifyListeners();
  }

  Future<void> matchCoupleCode() async {
    var response = await _userInfoRepository.registerPartner(_coupleCode!);

    if(response is Failure){
      _isCoupleCodeMatched = false;
      _coupleCodeMatchFailMessage = "연결에 실패하였습니다. 다시 한 번 확인해주세요.";
    }

    if((response is Success)){
      _isCoupleCodeMatched = true;
      _coupleCodeMatchFailMessage = null;
    }
  }

  Future<void> checkCode(String str) async {
    if(str.isEmpty) {
      _isCoupleCoupleCodeOk = false;
      _coupleCodeErrorMessage = "연결할 코드를 입력해주세요";
    }
    else if(str.length != 8){
      _isCoupleCoupleCodeOk = false;
      _coupleCodeErrorMessage = "커플 코드는 8자리입니다";
    }
    else{
      _coupleCode = str;
      _isCoupleCoupleCodeOk = true;
      _coupleCodeErrorMessage = null;
    }
  }

  clear() {
    _isCoupleCodeMatched = false;
    _userCode = ""; // temp
    _coupleCode = null; // temp
    _isUserCoupleCodeOk = false;
    _isCoupleCoupleCodeOk = false;
    _coupleCodeErrorMessage = null;
    _coupleCodeMatchFailMessage = null;
    notifyListeners();
  }
}