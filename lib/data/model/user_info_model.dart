// To parse this JSON data, do
//
//     final userInfoModel = userInfoModelFromJson(jsonString);

import 'dart:convert';

List<UserInfoModel> userInfoModelFromJson(String str) => List<UserInfoModel>.from(json.decode(str).map((x) => UserInfoModel.fromJson(x)));

String userInfoModelToJson(List<UserInfoModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserInfoModel {
  UserInfoModel({
    required this.userId,
    required this.userName,
    required this.userEnrolledDate,
    this.coupleCode,
  });

  int userId;
  String userName;
  String userEnrolledDate;
  String? coupleCode;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
    userId: json["userId"],
    userName: json["userName"],
    userEnrolledDate: json["userEnrolledDate"],
    coupleCode: json["coupleCode"],
  );

  Map<String, dynamic> toJson() => {
    "id": userId,
    "name": userName,
    "username": userEnrolledDate,
    "email": coupleCode,
  };
}