import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:couple_seflie_app/data/datasource/remote_datasource.dart';
import 'package:couple_seflie_app/main.dart';

import '../../amplifyconfiguration.dart';
import '../model/auth_credentials_model.dart';

// AuthFlowStatus는 로그인 페이지, 등록 페이지, 확인 페이지 또는 세션의 네 가지 인증 흐름을 포함할 수 있는 열거형
enum AuthFlowStatus { login, signUp, verification, session }

class AuthService {

  Future<Object> loginService(AuthCredentialsModel credentials) async {
    try {
      final result = await Amplify.Auth.signIn(username: credentials.email, password: credentials.password);

      if (result.isSignedIn) {
        //_authFlowStatus = AuthFlowStatus.session;
        return Success(response: "로그인에 성공하였습니다");
        return AuthFlowStatus.session;
      } else {
        print('로그인할 수 없는 사용자입니다.');
        return Failure(code: INVALID_RESPONSE, errorResponse: "일치하는 회원정보가 없습니다");
        return AuthFlowStatus.login;
      }
    } on UserNotConfirmedException catch (authError) {
      // verificationService;
      print('이메일을 확인하여 인증을 완료해주세요. - ${authError.message}');
      return Failure(code: UNKNOWN_ERROR, errorResponse: "이메일을 확인하여 인증을 완료해주세요");
    } on AuthException catch (authError) {
      print('로그인에 실패하였습니다. - ${authError.message}');
      return Failure(code: UNKNOWN_ERROR, errorResponse: "로그인에 실패하였습니다 - ${authError.message}");
      return AuthFlowStatus.login;
    }
  }

  Future<Object> registerService(RegisterCredential credentials) async {
    try {
      final userAttributes = {CognitoUserAttributeKey.nickname: credentials.username, CognitoUserAttributeKey.email: credentials.email};
      final result = await Amplify.Auth.signUp(username: credentials.email, password: credentials.password, options: CognitoSignUpOptions(userAttributes: userAttributes));

      // 4
      if (result.isSignUpComplete) {
        return Success(response: "회원가입이 완료되었습니다");
        return loginService(credentials);
      }
      else {
        // verificationService;
        //_authCredentialsModel = credentials;
        // _authFlowStatus = AuthFlowStatus.verification;
        return Success(response: "이메일을 확인하여 인증을 완료주세요");
        return AuthFlowStatus.verification;
      }

      // 7
    } on AuthException catch (authError) {
      print('Failed to sign up - ${authError.message}');
      return Failure(code: UNKNOWN_ERROR, errorResponse: "회원가입에 실패하였습니다 - ${authError.message}");
      return AuthFlowStatus.signUp;
    }
  }

  Future<Object> verifyService(String email, String verificationCode) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(username: email, confirmationCode: verificationCode);

      if (result.isSignUpComplete) {
        return Success(response: "인증이 완료되었습니다");
        //return loginService(_authCredentialsModel);
      } else {
        // 4
        // Follow more steps
        return Failure(code: INVALID_RESPONSE, errorResponse: "다시 시도해주세요");
        return AuthFlowStatus.verification;
      }
    } on AuthException catch (authError) {
      print('Could not verify code - ${authError.message}');
      return Failure(code: UNKNOWN_ERROR, errorResponse: "인증에 실패하였습니다 - ${authError.message}");
      return AuthFlowStatus.verification;
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

  // Auto Login
  Future<AuthFlowStatus> checkAuthStatusService() async {
    try {
      await Amplify.Auth.fetchAuthSession();
      // username = (await Amplify.Auth.getCurrentUser()).username;
      username = (await AmplifyAuthCognito().getCurrentUser()).username;
      print(username);
      return AuthFlowStatus.session;
    } catch (_) {
      username = "";
      return AuthFlowStatus.login;
    }
  }
}