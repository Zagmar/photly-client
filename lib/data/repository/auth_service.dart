import 'dart:async';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:couple_seflie_app/data/datasource/remote_datasource.dart';
import '../model/user_credentials_model.dart';

enum AuthFlowStatus { login, session }
enum LoginStatus { success, nonUser, nonVerification, nonUserInfo, unknownFail}
enum SignUpStatus { success, fail, nonVerification, existUser }
enum VerifyStatus { success, fail }

class AuthService {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  static const String USER = "$PHOTLY/user/info";


  Future<Object> loginService(UserCredentialsModel credentials) async {
    try {
      final amplifyResponse = await Amplify.Auth.signIn(username: credentials.email!, password: credentials.password!);
      if (amplifyResponse.isSignedIn) {
        final dbResponse = await getUserInfo();
        if(dbResponse is Success) {
          return LoginStatus.success;
        }
        else {
          return LoginStatus.nonUserInfo;
        }
      }
      else {
        return LoginStatus.unknownFail;
      }
    } on UserNotConfirmedException {
      return LoginStatus.nonVerification;
    } on AuthException catch (authError) {
      print(authError.message);
      return LoginStatus.nonUser;
    } catch (e){
      return LoginStatus.unknownFail;
    }
  }

  Future<Object> registerService(UserCredentialsModel credentials) async {
    try {
      final userAttributes = {CognitoUserAttributeKey.email: credentials.email!};
      final result = await Amplify.Auth.signUp(username: credentials.email!, password: credentials.password!, options: CognitoSignUpOptions(userAttributes: userAttributes));
      if (result.isSignUpComplete) {
        await loginService(credentials);
        return SignUpStatus.success;
      }
      else {
        await loginService(credentials);
        return SignUpStatus.success;
      }

    } on UsernameExistsException {
      return SignUpStatus.existUser;
    } on AuthException {
      return SignUpStatus.fail;
    }
  }

  Future<Object> verificationService(String userId, String verificationCode) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
          username: userId,
          confirmationCode: verificationCode
      );
      if (result.isSignUpComplete) {
        return VerifyStatus.success;
      }
      else {
        return VerifyStatus.success;
      }
    } on AuthException {
      return VerifyStatus.fail;
    }
  }

  Future<Object> logOutService() async {
    try {
      await Amplify.Auth.signOut();
      return Success(response: "success");
    } on AuthException catch (authError) {
      return Failure(code: INVALID_RESPONSE, errorResponse: 'Could not log out - ${authError.message}');
      return AuthFlowStatus.session;
    }
  }

  Future<AuthFlowStatus> checkAuthStatusService() async {
    try {
      await Amplify.Auth.fetchAuthSession();
      var response = await getUserInfo();
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

  Future<Object> getUserInfo() async {
    Map<String, dynamic> inputData = {
      'user_id' : await getCurrentUserId(),
    };
    var response = await _remoteDataSource.getFromUri(USER, inputData);
    return response;
  }

  Future<String> getCurrentUserId() async {
    String userId = (await Amplify.Auth.fetchUserAttributes()).firstWhere((element) => element.userAttributeKey.key == "email").value;
    return userId;
  }

  Future<Object> resetPassword(String userId) async {
    try {
      await Amplify.Auth.resetPassword(
        username: userId,
      );
      return Success(response: "이메일을 확인해주세요");
    } on UserNotFoundException catch(e) {
      return Failure(code: INVALID_RESPONSE, errorResponse: "존재하지 않는 유저입니다");
    } on AmplifyException catch (e) {
      return Failure(code: INVALID_RESPONSE, errorResponse: e.message);
    }
  }

  Future<Object> updatePassword(String userId, String password, String confirmCode) async {
    try {
      await Amplify.Auth.confirmResetPassword(
          username: userId,
          newPassword: password,
          confirmationCode: confirmCode
      );
      return Success(response: "Success");
    } on UserNotFoundException catch(e) {
      return Failure(code: INVALID_RESPONSE, errorResponse: "존재하지 않는 유저입니다 ${e.message}");
    } on PasswordResetRequiredException catch(e) {
      return Failure(code: INVALID_RESPONSE, errorResponse: e.message);
    } on AmplifyException catch (e) {
      return Failure(code: INVALID_RESPONSE, errorResponse: e.message);
    }
  }
}