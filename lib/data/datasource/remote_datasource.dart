import 'dart:io';
import 'package:http/http.dart' as http;

/// Status Code
const OK = 200;
const INVALID_RESPONSE = 100;
const NO_INTERNET = 101;
const INVALID_FORMAT = 102;
const UNKNOWN_ERROR = 103;

/// API URL
const PHOTLY = "https://rpqkktcxv9.execute-api.ap-northeast-2.amazonaws.com/A1/photly";

class Success {
  String response;
  Success({required this.response});
}

class Failure {
  int code;
  String errorResponse;
  Failure({required this.code, required this.errorResponse});
}

class RemoteDataSource {
  final int timeout = 5;
  Future<Object> getFromUri(String uri, Map<String, String>? inputData) async {
    try{
      var url = Uri.parse(uri);
      var response = inputData != null ?
      await http.get(url, headers: inputData).timeout(Duration(seconds: timeout))
          :
      await http.get(url).timeout(Duration(seconds: timeout))
      ;

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

  Future<Object> postToUri(String uri, Map<String, String> inputData) async {
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

  Future<Object> putToUri(String uri, Map<String, String> inputData) async {
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

  Future<Object> deleteFromUri(String uri, Map<String, String> inputData) async {
    try{
      var url = Uri.parse(uri);
      var response = await http.delete(url, headers: inputData).timeout(Duration(seconds: timeout));
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