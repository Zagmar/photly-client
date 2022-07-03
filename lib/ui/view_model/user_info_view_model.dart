import 'package:couple_seflie_app/data/repository/post_info_repository.dart';
import 'package:couple_seflie_app/data/repository/user_info_repository.dart';
import 'package:flutter/material.dart';
import '../../data/datasource/remote_datasource.dart';
import '../../data/model/user_credentials_model.dart';
import '../../data/repository/auth_service.dart';
import '../../data/repository/firebase_cloud_messaging_service.dart';

class UserInfoViewModel extends ChangeNotifier {
  final PostInfoRepository _postInfoRepository = PostInfoRepository();
  final UserInfoRepository _userInfoRepository = UserInfoRepository();
  final AuthService _authService = AuthService();
  final FirebaseCloudMessagingService _firebaseCloudMessagingService = FirebaseCloudMessagingService();

  UserCredentialsModel _credential = UserCredentialsModel();

  String? _resultMessage;
  String? _inputErrorMessage;
  String? _resultState;
  bool _resultSuccess = false;
  bool _inputOk = false;
  String? _input;

  bool get resultSuccess => _resultSuccess;
  String? get resultMessage => _resultMessage;
  String? get resultState => _resultState;
  String? get inputErrorMessage => _inputErrorMessage;
  bool get inputOk => _inputOk;

  String? get email => _credential.email;
  String? get userCode => _credential.coupleCode;

  Future<void> checkInputOk() async {
    notifyListeners();
  }

  checkEmail(String val){
    if(val.isEmpty) {
      _inputErrorMessage = '이메일은 필수사항입니다.';
      _inputOk = false;
    }
    else if(!RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(val)){
      _inputErrorMessage = '잘못된 이메일 형식입니다.';
      _inputOk = false;
    }
    else{
      _credential.email = val;
      _inputErrorMessage = null;
      _inputOk = true;
    }
  }

  checkResetPwConfirmedCode(String input) {
    if(input.isEmpty) {
      _inputErrorMessage = '초기화 확인 코드를 입력해주세요';
      _inputOk = false;
    }
    else{
      _input = input;
      _inputErrorMessage = null;
      _inputOk = true;
    }
  }

  checkPassword(String val){
    if(val.isEmpty) {
      _inputErrorMessage = '비밀번호는 필수사항입니다.';
      _inputOk = false;
    }
    else if(!RegExp(r'^([A-Za-z0-9]{8,})$').hasMatch(val)) {
      _inputErrorMessage = '비밀번호는 숫자와 문자가 1개 이상 포함된 8자 이상입니다';
      _inputOk = false;
    }
    else{
      _credential.password = val;
      _inputErrorMessage = null;
      _inputOk = true;
    }
  }

  checkPasswordCheck(String val){
    if(val.isEmpty) {
      _inputErrorMessage = '비밀번호 확인은 필수사항입니다';
      _inputOk = false;
    }
    else if(val != _credential.password){
      _inputErrorMessage = '비밀번호를 다시 확인해주세요';
      _inputOk = false;
    }
    else{
      _inputErrorMessage = null;
      _inputOk = true;
    }
  }

  checkVerificationCode(String input){
    if(input.isEmpty) {
      _inputErrorMessage = '인증코드를 입력해주세요';
      _inputOk = false;
    }
    else if(!RegExp(r'^([0-9]{6,6})$').hasMatch(input)) {
      _inputErrorMessage = '인증코드는 6자리 숫자입니다';
      _inputOk = false;
    }
    else{
      _input = input;
      _inputErrorMessage = null;
      _inputOk = true;
    }
  }

  checkUsername(String val){
    if(val.isEmpty) {
      _inputErrorMessage = '닉네임은 필수사항입니다';
      _inputOk = false;
    }
    else{
      _credential.userName = val;
      _inputErrorMessage = null;
      _inputOk = true;
    }
  }

  Future<void> checkCoupleCode(String str) async {
    if(str.isEmpty) {
      _inputOk = false;
      _inputErrorMessage = "연결할 코드를 입력해주세요";
    }
    else if(str.length != 8) {
      _inputOk = false;
      _inputErrorMessage = "커플 코드는 8자리입니다";
    }
    else{
      _input = str;
      _inputOk = true;
      _inputErrorMessage = null;
    }
  }

  Future<void> setAnniversary(DateTime? val) async {
    _credential.coupleAnniversary = val;
    _inputOk = true;
  }


  Future<void> doRegistration() async {
    final response = await _authService.registerService(_credential);

    if(response == SignUpStatus.success){
      _resultSuccess = true;
      _resultMessage = null;

    }
    else if(response == SignUpStatus.existUser) {
      _resultSuccess = false;
      _resultMessage = "이미 가입된 사용자입니다";
    }
    else {
      _resultSuccess = false;
      _resultMessage = "재시도 후 지속적으로 오류가 발생 시 문의해주세요";
    }
    notifyListeners();
  }

  Future<void> doVerification() async {
    final result = await _authService.verificationService(_credential.email!, _input!);

    if(result == VerifyStatus.success){
      _resultMessage = null;
      _resultSuccess = true;
      await doLogin();
    }
    else {
      _resultMessage = "인증에 실패했습니다";
      _resultSuccess = false;
    }
    notifyListeners();
  }

  Future<void> doLogin() async {
    await _authService.logOutService();
    final result = await _authService.loginService(_credential);

    if(result == LoginStatus.success){
      await _firebaseCloudMessagingService.fcmSetting();
      _resultMessage = null;
      _resultState = null;
    }
    else if(result == LoginStatus.nonVerification) {
      _resultMessage = "이메일 인증을 완료해주세요";
      _resultState = "nonVerification";
    }
    else if(result == LoginStatus.nonUserInfo) {
      _resultMessage = "사용자 정보 입력을 완료해주세요";
      _resultState = "nonUserInfo";
    }
    else if(result == LoginStatus.nonUser){
      _resultMessage = "로그인 정보가 일치하지 않습니다";
      _resultState = "nonUser";
    }
    else if(result == LoginStatus.unknownFail){
      _resultMessage = "재시도 후 지속적으로 오류가 발생 시 문의해주세요";
      _resultState = "fail";
    }
    notifyListeners();
  }

  Future<void> doClearPosts() async {
    final result = await _postInfoRepository.deleteUserPostData();

    if(result is Success){
      _resultMessage = null;
      _resultSuccess = true;
    }

    if(result is Failure){
      _resultMessage = "재시도 후 지속적인 오류가 발생 시 문의해주세요";
      _resultSuccess = false;
    }

    notifyListeners();
  }

  Future<void> doClearPartner() async {
    final result = await _userInfoRepository.clearPartner();

    if(result is Success){
      _resultMessage = null;
      _resultSuccess = true;
    }
    if(result is Failure){
      _resultMessage = "재시도 후 지속적인 오류가 발생 시 문의해주세요";
      _resultSuccess = false;
    }
    notifyListeners();
  }

  Future<void> doLogout() async {
    final result = await _authService.logOutService();

    if(result is Failure){
      _resultMessage = "재시도 후 지속적인 오류가 발생 시 문의해주세요";
      _resultSuccess = false;
    }
    if(result is Success) {
      _resultMessage = null;
      _resultSuccess = true;
    }
    notifyListeners();
  }

  Future<void> clearUser() async {
    final result = await _userInfoRepository.clearUser();
    if(result is Success){
      _resultMessage = null;
      _resultSuccess = true;
    }
    if(result is Failure) {
      _resultMessage = "재시도 후 지속적인 오류가 발생 시 문의해주세요";
      _resultSuccess = false;
    }
    notifyListeners();

  }

  Future<void> uploadUserInfoToDB() async {
    if(_credential.coupleAnniversary == null) {
      await setAnniversary(DateTime.now());
    }
    var response = await _userInfoRepository.createUserInfo(_credential.userName!, _credential.coupleAnniversary!);
    if(response is Success) {
      _resultSuccess = true;
      _resultMessage = null;
    }
    else {
      _resultSuccess = false;
      _resultMessage = "재시도 후 지속적인 오류가 발생 시 문의해주세요";
    }
    notifyListeners();
  }

  Future<void> updateUsername() async {
    var response = await _userInfoRepository.updateUsername(_credential.userName!);
    if(response is Success) {
      _resultSuccess = true;
      _resultMessage = null;
    }
    else {
      _resultSuccess = false;
      _resultMessage = "재시도 후 지속적인 오류가 발생 시 문의해주세요";
    }
    notifyListeners();
  }

  Future<void> updateAnniversary() async {
    if(_credential.coupleAnniversary == null) {
      await setAnniversary(DateTime.now());
    }
    var response = await _userInfoRepository.updateAnniversary(_credential.coupleAnniversary!);
    if(response is Success) {
      _resultSuccess = true;
      _resultMessage = null;
    }
    else {
      _resultSuccess = false;
      _resultMessage = "재시도 후 지속적인 오류가 발생 시 문의해주세요";
    }
    notifyListeners();
  }


  setUserCoupleCode() async {
    var response = await _userInfoRepository.getUserInfo();
    if(response is Failure){
      _credential.coupleCode = null;
    }
    if(response is Success){
      _credential.coupleCode = response.response["coupleCode"];
    }
    notifyListeners();
  }

  Future<void> matchCoupleCode() async {
    var response = await _userInfoRepository.registerPartner(_input!);

    if(response is Failure){
      _resultSuccess = false;
      _resultMessage = "올바른 코드인지 다시 확인 후 시도해주세요";
    }

    if((response is Success)){
      _resultSuccess = true;
      _resultMessage = null;
    }
    notifyListeners();
  }

  Future<void> resetPassword() async {
    var response = await _authService.resetPassword();

    if(response is Failure){
      _resultSuccess = false;
      _resultMessage = response.errorResponse;
    }

    if((response is Success)){
      _resultSuccess = true;
      _resultMessage = response.response;
    }
    notifyListeners();
  }

  Future<void> confirmResetPassword() async {
    var response = await _authService.updatePassword(_credential.password!, _input!);

    if(response is Failure){
      _resultSuccess = false;
      _resultMessage = response.errorResponse;
    }

    if((response is Success)){
      _resultSuccess = true;
      _resultMessage = null;
    }
    notifyListeners();
  }

  Future<void> clearAll() async {
    _credential = UserCredentialsModel();
    _inputOk = false;
    _inputErrorMessage = null;
    _input = null;
    _resultSuccess = false;
    _resultMessage = null;
    _resultState = null;
  }

  Future<void> clearWithoutCredential() async {
    _inputOk = false;
    _inputErrorMessage = null;
    _input = null;
    _resultSuccess = false;
    _resultMessage = null;
    _resultState = null;
  }
}