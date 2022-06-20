import 'package:couple_seflie_app/data/repository/post_info_repository.dart';
import 'package:couple_seflie_app/data/repository/user_info_repository.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/datasource/remote_datasource.dart';
import '../../data/model/auth_credentials_model.dart';
import '../../data/repository/auth_service.dart';
import '../../data/repository/firebase_cloud_messaging_service.dart';

class UserInfoViewModel extends ChangeNotifier {
  final PostInfoRepository _postInfoRepository = PostInfoRepository();
  final UserInfoRepository _userInfoRepository = UserInfoRepository();
  final AuthService _authService = AuthService();
  final FirebaseCloudMessagingService _firebaseCloudMessagingService = FirebaseCloudMessagingService();

  UserCredentialsModel? _credential;
  String? _email;
  String? _password;
  String? _verificationCode;
  String? _resetPwConfirmedCode;
  bool _isIdOk = false;
  bool _isPwOk = false;
  bool _isPwCheckOk = false;
  bool _isVerificationCodeOk = false;
  bool _isRegistered = false;
  bool _isVerified = false;
  bool _isLogout = false;
  bool _isPostsClear = false;
  bool _isPartnerClear = false;
  bool _isUserClear = false;
  bool _isPWReset = false;
  String? _loginFailure;
  String? _idErrorMessage = '이메일은 필수사항입니다.';
  String? _pwErrorMessage = '비밀번호는 필수사항입니다.';
  String? _pwCheckErrorMessage = '비밀번호 확인은 필수사항입니다';
  String? _verificationCodeErrorMessage = '인증코드 입력은 필수사항입니다';
  String? _pwResetErrorMessage = "초기화 확인 코드를 입력해주세요";
  String? _loginFailMessage;
  String? _logoutFailMessage;
  String? _registrationFailMessage;
  String? _verificationFailMessage;
  String? _clearPostsFailMessage;
  String? _clearPartnerFailMessage;
  String? _clearUserFailMessage;

  String _username = "";
  DateTime? _anniversary;
  bool _isUsernameOk = false;
  bool _isAnniversaryOk = false;
  bool _isUploaded = false;
  String? _usernameErrorMessage = '닉네임은 필수사항입니다';
  String? _anniversaryErrorMessage = '날짜를 선택해주세요';
  String? _uploadFailMessage = "다시 시도해주세요";

  String _userCode = ""; // temp
  String? _coupleCode; // temp
  bool _isCoupleCodeMatched = false;
  bool _isUserCoupleCodeOk = false;
  bool _isCoupleCoupleCodeOk = false;
  String? _coupleCodeErrorMessage;
  String? _coupleCodeMatchFailMessage;
  String? _resetPasswordResultMessage;

  String? get email => _email;
  String? get coupleCodeErrorMessage => _coupleCodeErrorMessage;
  String? get coupleCodeMatchFailMessage => _coupleCodeMatchFailMessage;
  bool get isCoupleCodeMatched => _isCoupleCodeMatched;
  bool get isUserCoupleCodeOk => _isUserCoupleCodeOk;
  bool get isCoupleCoupleCodeOk => _isCoupleCoupleCodeOk;
  String get userCode => _userCode;
  bool get isIdOk => _isIdOk;
  bool get isConfirmResetPassword => _isPwCheckOk && _isPwOk && _isPWReset;

  String? get idErrorMessage => _idErrorMessage;
  String? get pwErrorMessage => _pwErrorMessage;
  String? get pwCheckErrorMessage => _pwCheckErrorMessage;
  String? get verificationCodeErrorMessage => _verificationCodeErrorMessage;
  String? get loginFailMessage => _loginFailMessage;
  String? get logoutFailMessage => _logoutFailMessage;
  String? get registrationFailMessage => _registrationFailMessage;
  String? get verificationFailMessage => _verificationFailMessage;
  String? get clearPostsFailMessage => _clearPostsFailMessage;
  String? get clearPartnerFailMessage => _clearPartnerFailMessage;
  String? get clearUserFailMessage => _clearUserFailMessage;
  bool get isLoginOk => _isIdOk && _isPwOk;
  bool get isRegisterOk => _isIdOk && _isPwOk && _isPwCheckOk;
  bool get isVerificationCodeOk => _isVerificationCodeOk;
  bool get isLogout => _isLogout;
  String? get loginFailure => _loginFailure;
  bool get isVerified => _isVerified;
  bool get isRegistered => _isRegistered;
  bool get isPostsClear => _isPostsClear;
  bool get isPartnerClear => _isPartnerClear;
  bool get isUserClear => _isUserClear;

  String? get usernameErrorMessage => _usernameErrorMessage;
  String? get anniversaryErrorMessage => _anniversaryErrorMessage;
  bool get isUsernameOk => _isUsernameOk;
  bool get isAnniversaryOk => _isAnniversaryOk;
  String get username => _username;
  DateTime? get anniversary => _anniversary;
  bool get isUploaded => _isUploaded;
  String? get uploadFailMessage => _uploadFailMessage;
  bool get isPWReset => _isPWReset;
  String? get resetPasswordResultMessage => _resetPasswordResultMessage;
  String? get pwResetErrorMessage => _pwResetErrorMessage;

  // Check Input Form of Email
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

  checkResetPwConfirmedCode(String val) {
    if(val.isEmpty) {
      _pwResetErrorMessage = '초기화 확인 코드를 입력해주세요';
      _isPWReset = false;
    }
    else{
      _resetPwConfirmedCode = val;
      _pwResetErrorMessage = null;
      _isPWReset = true;
    }
    notifyListeners();
  }

  // Check Input Form of Password
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

  // Check Input Form of Password Check
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

  // Check Input Form of Verification Code
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

  // Check Input Form of Username
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

  // Check Input Form of Couple Code
  Future<void> checkCoupleCode(String str) async {
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

  // Set Anniversary to Input Date
  setAnniversary(DateTime val) {
    _anniversary = val;
    _isAnniversaryOk = true;
    notifyListeners();
  }


  Future<void> doRegistration() async {
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
    final result = await _authService.verificationService(_email!, _verificationCode!);
    print(result);

    if(result == VerifyStatus.success){
      _verificationFailMessage = null;
      _isVerified = true;
      //await _authService.loginService(_credential!);
      await doLogin();
      print("뷰모델" + _credential!.email.toString() + _credential!.password.toString());
      notifyListeners();
    }
    else {
      _verificationFailMessage = "인증에 실패했습니다";
      _isVerified = false;
      notifyListeners();
    }
  }

  Future<void> doLogin() async {
    await _authService.logOutService();
    _credential = UserCredentialsModel(email: _email!, password: _password!);
    final result = await _authService.loginService(_credential!);

    if(result == LoginStatus.success){
      await _firebaseCloudMessagingService.fcmSetting();
      _loginFailMessage = null;
      _loginFailure = null;
      notifyListeners();
    }
    else if(result == LoginStatus.nonVerification) {
      _loginFailMessage = "이메일 인증을 완료해주세요";
      _loginFailure = "nonVerification";
      print(_loginFailure);
      notifyListeners();
    }
    else if(result == LoginStatus.nonUserInfo) {
      _loginFailMessage = "사용자 정보 입력을 완료해주세요";
      _loginFailure = "nonUserInfo";
      print(_loginFailure);
      notifyListeners();
    }
    else if(result == LoginStatus.nonUser){
      _loginFailMessage = "일치하는 사용자 정보가 없습니다";
      _loginFailure = "nonUser";
      print(_loginFailure);
      notifyListeners();
    }
    else if(result == LoginStatus.unknownFail){
      _loginFailMessage = "재시도 후 지속적으로 오류가 발생 시 문의해주세요";
      _loginFailure = "fail";
      notifyListeners();
    }
  }

  // Clear all posts of user
  Future<void> doClearPosts() async {
    final result = await _postInfoRepository.deleteUserPostData();

    if(result is Success){
      _clearPostsFailMessage = null;
      _isPostsClear = true;
      notifyListeners();
    }

    if(result is Failure){
      _clearPostsFailMessage = result.errorResponse;
      _isPostsClear = false;
      notifyListeners();
    }
  }

  // Clear all posts of user
  Future<void> doClearPartner() async {
    final result = await _userInfoRepository.clearPartner();

    if(result is Success){
      _clearPartnerFailMessage = null;
      _isPartnerClear = true;
      notifyListeners();
    }

    if(result is Failure){
      _clearPartnerFailMessage = result.errorResponse;
      _isPartnerClear = false;
      notifyListeners();
    }
  }

  Future<void> doLogout() async {
    final result = await _authService.logOutService();

    if(result is Failure){
      _logoutFailMessage = result.errorResponse;
      _isLogout = false;
      notifyListeners();
    }
    else {
      _logoutFailMessage = null;
      _isLogout = true;
      notifyListeners();
    }
  }

  Future<void> clearUser() async {
    final result = await _userInfoRepository.clearUser();
    print("여기1");
    if(result is Success){
      print("여기2");

      _clearUserFailMessage = null;
      _isUserClear = true;

      /*
      final resultAuth = await _authService.ClearUserService();
      print("여기3");
      if(resultAuth is Failure){
        _clearUserFailMessage = resultAuth.errorResponse;
        _isUserClear = false;
        notifyListeners();
      }
      if(resultAuth is Success) {
        _clearUserFailMessage = null;
        _isUserClear = true;
        notifyListeners();
      }

       */
    }
    if(result is Failure) {
      print("여기4");
      _clearUserFailMessage = result.errorResponse;
      _isUserClear = false;
      notifyListeners();
    }
  }

  Future<void> clear() async {
    _email = null;
    _password = null;
    _isIdOk = false;
    _isPwOk = false;
    _isPwCheckOk = false;
    _isRegistered = false;
    _username = "";
    _anniversary = null;
    _isUsernameOk = false;
    _isAnniversaryOk = false;
    _isPWReset = false;

    _isCoupleCodeMatched = false;
    _userCode = ""; // temp
    _coupleCode = null; // temp
    _isUserCoupleCodeOk = false;
    _isCoupleCoupleCodeOk = false;
    _coupleCodeErrorMessage = null;
    _coupleCodeMatchFailMessage = null;
    notifyListeners();
  }

  Future<void> uploadUserInfoToDB() async {
    print("_userId");
    var response = await _userInfoRepository.createUserInfo(_username, _anniversary!);
    if(response is Success) {
      _isUploaded = true;
      _uploadFailMessage = null;
    }
    else {
      _isUploaded = false;
      _uploadFailMessage = "요청을 실패하였습니다.";
    }
    notifyListeners();
  }

  Future<void> updateUsername() async {
    var response = await _userInfoRepository.updateUsername(_username);
    if(response is Success) {
      _isUploaded = true;
      _uploadFailMessage = null;
    }
    else {
      _isUploaded = false;
      _uploadFailMessage = "요청을 실패하였습니다.";
    }
    notifyListeners();
  }

  Future<void> updateAnniversary() async {
    var response = await _userInfoRepository.updateAnniversary(_anniversary!);
    if(response is Success) {
      _isUploaded = true;
      _uploadFailMessage = null;
    }
    else {
      _isUploaded = false;
      _uploadFailMessage = "요청을 실패하였습니다.";
    }
    notifyListeners();
  }


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

  Future<void> resetPassword() async {
    var response = await _authService.resetPassword(_email!);

    if(response is Failure){
      _isPWReset = false;
      _resetPasswordResultMessage = response.errorResponse;
    }

    if((response is Success)){
      _isPWReset = true;
      _resetPasswordResultMessage = response.response;
    }
    notifyListeners();
  }

  Future<void> confirmResetPassword() async {
    var response = await _authService.updatePassword(_email!, _password!, _resetPwConfirmedCode!);

    if(response is Failure){
      _isPWReset = false;
      _resetPasswordResultMessage = response.errorResponse;
    }

    if((response is Success)){
      _isPWReset = true;
      _resetPasswordResultMessage = null;
    }
    notifyListeners();
  }
}