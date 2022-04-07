import 'dart:io';

import 'package:couple_seflie_app/data/model/user_info_model.dart';
import 'package:couple_seflie_app/data/repository/api_status.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class UserInfoRepository{
  static Future<Object> getUser() async {
    try{
      var url = Uri.parse(USER_LIST);
      var response = await http.get(url);
      if(response.statusCode == 100) {
        return Success(code: response.statusCode, response: userInfoModelFromJson(response.body));
      }
      return Failure(code: USER_INVALID_RESPONSE, errorResponse: "Invalid Response");
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