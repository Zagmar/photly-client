import 'dart:io';
import 'package:http/http.dart' as http;

import '../model/user_info_model.dart';


/// Status Code
const INVALID_RESPONSE = 100;
const NO_INTERNET = 101;
const INVALID_FORMAT = 102;
const UNKNOWN_ERROR = 103;

class Success {
  int code;
  Object response;
  Success({required this.code, required this.response});
}

class Failure {
  int code;
  Object errorResponse;
  Failure({required this.code, required this.errorResponse});
}

class RemoteDataSource {
  Future<Object> getFromUri(String uri) async {
    try{
      var url = Uri.parse(uri);
      var response = await http.get(url);
      if(response.statusCode == 100) {
        return Success(code: response.statusCode, response: userInfoModelFromJson(response.body));
      }
      return Failure(code: INVALID_RESPONSE, errorResponse: "Invalid Response");
    } on HttpException{
      return Failure(code: NO_INTERNET, errorResponse: "No Internet");
    } on FormatException{
      return Failure(code: INVALID_FORMAT, errorResponse: "Invalid Format");
    }
    catch(e) {
      return Failure(code: UNKNOWN_ERROR, errorResponse: "Unknown Error");
    }
  }

  Future<Object> postToUri(String uri) async {
    try{
      var url = Uri.parse(uri);
      var response = await http.post(url);
      if(response.statusCode == 100) {
        return Success(code: response.statusCode, response: userInfoModelFromJson(response.body));
      }
      return Failure(code: INVALID_RESPONSE, errorResponse: "Invalid Response");
    } on HttpException{
      return Failure(code: NO_INTERNET, errorResponse: "No Internet");
    } on FormatException{
      return Failure(code: INVALID_FORMAT, errorResponse: "Invalid Format");
    }
    catch(e) {
      return Failure(code: UNKNOWN_ERROR, errorResponse: "Unknown Error");
    }
  }

  Future<Object> putToUri(String uri) async {
    try{
      var url = Uri.parse(uri);
      var response = await http.put(url);
      if(response.statusCode == 100) {
        return Success(code: response.statusCode, response: userInfoModelFromJson(response.body));
      }
      return Failure(code: INVALID_RESPONSE, errorResponse: "Invalid Response");
    } on HttpException{
      return Failure(code: NO_INTERNET, errorResponse: "No Internet");
    } on FormatException{
      return Failure(code: INVALID_FORMAT, errorResponse: "Invalid Format");
    }
    catch(e) {
      return Failure(code: UNKNOWN_ERROR, errorResponse: "Unknown Error");
    }
  }

  Future<Object> deleteFromUri(String uri) async {
    try{
      var url = Uri.parse(uri);
      var response = await http.delete(url);
      if(response.statusCode == 100) {
        return Success(code: response.statusCode, response: userInfoModelFromJson(response.body));
      }
      return Failure(code: INVALID_RESPONSE, errorResponse: "Invalid Response");
    } on HttpException{
      return Failure(code: NO_INTERNET, errorResponse: "No Internet");
    } on FormatException{
      return Failure(code: INVALID_FORMAT, errorResponse: "Invalid Format");
    }
    catch(e) {
      return Failure(code: UNKNOWN_ERROR, errorResponse: "Unknown Error");
    }
  }



  /// UserInfo 불러오기
  Object getUserInfo() async {
    const String USER_LIST = "https://jsonplaceholder.typicode.com/users";
    return await getFromUri(USER_LIST);
  }
}