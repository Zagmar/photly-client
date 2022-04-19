import 'dart:convert';

List<UserInfoModel> userInfoModelFromJson(String str) => List<UserInfoModel>.from(json.decode(str).map((x) => UserInfoModel.fromJson(x)));

String userInfoModelToJson(List<UserInfoModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserInfoModel {
  UserInfoModel({
    required this.userId,
    required this.userName,
    required this.userEnrolledDate,
    required this.coupleCode,
  });

  String userId;
  String userName;
  DateTime userEnrolledDate;
  String coupleCode;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
    userId: json["userId"],
    userName: json["userName"],
    userEnrolledDate: DateTime.parse(json['userEnrolledDate'].toString()),
    coupleCode: json["coupleCode"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "userEnrolledDate": userEnrolledDate.toString(),
    "coupleCode": coupleCode,
  };
}