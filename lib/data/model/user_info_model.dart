import 'dart:convert';

class UserInfoModel {
  UserInfoModel({
    required this.userId,
    required this.userName,
    required this.userEnrolledDate,
    required this.coupleAnniversary,
    required this.coupleCode,
  });

  String userId;
  String userName;
  DateTime userEnrolledDate;
  DateTime coupleAnniversary;
  String coupleCode;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
    userId: json["userId"],
    userName: json["userName"],
    userEnrolledDate: DateTime.parse(json['userEnrolledDate'].toString()),
    coupleAnniversary: DateTime.parse(json['coupleAnniversary'].toString()),
    coupleCode: json["coupleCode"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "userEnrolledDate": userEnrolledDate.toString(),
    "coupleAnniversary": coupleAnniversary.toString(),
    "coupleCode": coupleCode,
  };
}