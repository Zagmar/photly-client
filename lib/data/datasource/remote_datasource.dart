import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

/// Status Code
const OK = 200;
const INVALID_RESPONSE = 100;
const NO_INTERNET = 101;
const INVALID_FORMAT = 102;
const UNKNOWN_ERROR = 103;

/// API URL
const PHOTLY = "https://0tijhj3s8l.execute-api.ap-northeast-2.amazonaws.com/A1/photly";

// Success to get response
class Success {
  var response;
  Success({required this.response});
}

// Fail to get response
class Failure {
  int code;
  String errorResponse;
  Failure({required this.code, required this.errorResponse});
}

// API communication
class RemoteDataSource {
  // Timeout Time is set on 5 seconds
  final int timeout = 5;

  // Get data from API by inputData
  Future<Object> getFromUri(String uri, Map<String, dynamic>? inputData) async {
    try{
      print("호출");
      print(uri);
      //var url = Uri.parse(uri);
      final response = await Dio()
          .get(
          uri,
          queryParameters: inputData).timeout(const Duration(seconds: 600))
          .catchError((e) {
        print(e.message);
      });
      print(response);

      if(response.statusCode == OK) {
        print(response.data);
        print("테스트 성공");
        return Success(response: response.data);
      }
      print("테스트 실패");
      return Failure(code: INVALID_RESPONSE, errorResponse: "Invalid Response");
    } on HttpException{
      print("에러1");
      return Failure(code: NO_INTERNET, errorResponse: "No Internet");
    } on FormatException{
      print("에러2");
      return Failure(code: INVALID_FORMAT, errorResponse: "Invalid Format");
    }
    catch(e) {
      print("에러3");
      return Failure(code: UNKNOWN_ERROR, errorResponse: "Unknown Error");
    }
  }

  // Post inputData to database through API
  Future<Object> postToUri(String uri, Map<String, dynamic> inputData) async {
    try{
      var url = Uri.parse(uri);
      var response = await http.post(url, body: inputData).timeout(Duration(seconds: timeout));
      if(response.statusCode == OK) {
        return Success(response: response.body);
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

  // Edit data in database into inputData through API
  Future<Object> putToUri(String uri, Map<String, dynamic> inputData) async {
    try{
      var url = Uri.parse(uri);
      var response = await http.put(
          url,
          headers: {"Content-Type": "application/json"},
          body: inputData
      ).timeout(Duration(seconds: timeout));
      if(response.statusCode == OK) {
        return Success(response: response.body);
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

  // Delete pointed to by the input data in the database through API
  Future<Object> deleteFromUri(String uri, Map<String, dynamic> inputData) async {
    try{
      var url = Uri.parse(uri);
      var response = await http.delete(url,).timeout(Duration(seconds: timeout));
      if(response.statusCode == OK) {
        return Success(response: response.body);
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
}