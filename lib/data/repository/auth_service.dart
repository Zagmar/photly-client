import 'dart:async';
import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:couple_seflie_app/data/datasource/remote_datasource.dart';
import 'package:couple_seflie_app/data/repository/user_info_repository.dart';
import 'package:couple_seflie_app/main.dart';
import '../model/auth_credentials_model.dart';

// AuthFlowStatus는 로그인 페이지, 등록 페이지, 확인 페이지 또는 세션의 네 가지 인증 흐름을 포함할 수 있는 열거형
enum AuthFlowStatus { login, session }
enum LoginStatus { success, nonUser, nonVerification, nonUserInfo, unknownFail}
enum SignUpStatus { success, fail, nonVerification, existUser }
enum VerifyStatus { success, fail }

class AuthService {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  static const String USER = "$PHOTLY/user/info";


  Future<Object> loginService(UserCredentialsModel credentials) async {
    try {
      final amplifyResponse = await Amplify.Auth.signIn(username: credentials.email, password: credentials.password);

      if (amplifyResponse.isSignedIn) {
        // Success to login on Amplify
        final dbResponse = await getUserInfo(credentials.email);
        if(dbResponse is Success) {
          // Success to login Completely
          return LoginStatus.success;
        }
        else {
          // Nonexistent user information in DB
          return LoginStatus.nonUserInfo;
        }
        return Success(response: "로그인에 성공하였습니다");
      }
      else {
        // Fail to login on Amplify
        return LoginStatus.unknownFail;
        return Failure(code: INVALID_RESPONSE, errorResponse: "일치하는 회원정보가 없습니다");
      }
    } on UserNotConfirmedException {
      // Non-verification user
      return LoginStatus.nonVerification;
      return Failure(code: UNKNOWN_ERROR, errorResponse: "이메일을 확인하여 인증을 완료해주세요");
    } on AuthException catch (authError) {
      print(authError.message);
      // Fail to login
      return LoginStatus.nonUser;
      return Failure(code: UNKNOWN_ERROR, errorResponse: "로그인에 실패하였습니다 - ${authError.message}");
    } catch (e){
      // Fail to login on Amplify
      print("실패");
      print(e);
      return LoginStatus.unknownFail;
      return Failure(code: INVALID_RESPONSE, errorResponse: "일치하는 회원정보가 없습니다");
    }
  }

  Future<Object> registerService(UserCredentialsModel credentials) async {
    try {
      final userAttributes = {CognitoUserAttributeKey.email: credentials.email};

      final result = await Amplify.Auth.signUp(username: credentials.email, password: credentials.password, options: CognitoSignUpOptions(userAttributes: userAttributes));
      // 4
      if (result.isSignUpComplete) {
        // 로그인
        await loginService(credentials);
        return SignUpStatus.success;
        return Success(response: "회원가입이 완료되었습니다");
        return loginService(credentials);
      }
      else {
        await loginService(credentials);
        // verificationService;
        //_authCredentialsModel = credentials;
        // _authFlowStatus = AuthFlowStatus.verification;
        return SignUpStatus.success;
        return Success(response: "이메일을 확인하여 인증을 완료주세요");
      }

      // 7
    } on UsernameExistsException {
      // Non-verification user
      return SignUpStatus.existUser;
      return Failure(code: UNKNOWN_ERROR, errorResponse: "이메일을 확인하여 인증을 완료해주세요");
    } on AuthException catch (authError) {
      return SignUpStatus.fail;
      return Failure(code: UNKNOWN_ERROR, errorResponse: "회원가입에 실패하였습니다 - ${authError.message}");
    }
  }

  Future<Object> verificationService(String userId, String verificationCode) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
          username: userId, confirmationCode: verificationCode);

      if (result.isSignUpComplete) {
        print("성공");
        return VerifyStatus.success;
        return Success(response: "회원가입이 완료되었습니다");
      }
      else {
        print("실패");
        print(result);
        // verificationService;
        //_authCredentialsModel = credentials;
        // _authFlowStatus = AuthFlowStatus.verification;
        return VerifyStatus.success;
        return Success(response: "이메일을 확인하여 인증을 완료주세요");
      }

      // 7
    } on AuthException catch (authError) {
      print("실패");
      print(authError.message);
      return VerifyStatus.fail;
      return Failure(code: UNKNOWN_ERROR, errorResponse: "회원가입에 실패하였습니다 - ${authError.message}");
    }
  }

  // Logout
  Future<Object> logOutService() async {
    try {
      // Call signOut without any option, execute logout in only this device
      await Amplify.Auth.signOut();
      // After logout, show login screen
      //showLogin();
      return Success(response: "success");
      return AuthFlowStatus.login;
    } on AuthException catch (authError) {
      print('Could not log out - ${authError.message}');
      return Failure(code: INVALID_RESPONSE, errorResponse: 'Could not log out - ${authError.message}');
      return AuthFlowStatus.session;
    }
  }

  // Clear
  Future<Object> ClearUserService() async {
    try {
      // Call signOut without any option, execute logout in only this device
      if (Platform.isIOS) {
        await Amplify.Auth.deleteUser();
      }
      // After logout, show login screen
      //showLogin();
      return Success(response: "success");
      return AuthFlowStatus.login;
    } on AuthException catch (authError) {
      print('Could not clear user - ${authError.message}');
      return Failure(code: INVALID_RESPONSE, errorResponse: 'Could not clear user - ${authError.message}');
      return AuthFlowStatus.session;
    }
  }

  // Auto Login
  Future<AuthFlowStatus> checkAuthStatusService() async {
    try {
      await Amplify.Auth.fetchAuthSession();
      // username = (await Amplify.Auth.getCurrentUser()).username;
      String userId = await AuthService().getCurrentUserId();
      print("아이디: " + userId);
      var response = await getUserInfo(userId);
      if(response is Success) {
        return AuthFlowStatus.session;
      }
      else{
        await logOutService();
        return AuthFlowStatus.login;
      }
    } catch (_) {
      return AuthFlowStatus.login;
    }
  }

  Future<Object> getUserInfo(String userId) async {
    // convert inputData to use for API
    Map<String, dynamic> inputData = {
      'user_id' : userId,
    };

    print(inputData);
    // call API
    var response = await _remoteDataSource.getFromUri(USER, inputData);
    return response;
  }

  Future<String> getCurrentUserId() async {
    String userId = (await Amplify.Auth.fetchUserAttributes()).firstWhere((element) => element.userAttributeKey.key == "email").value;
    return userId;
  }
}