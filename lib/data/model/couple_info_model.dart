import 'dart:convert';

List<CoupleInfoModel> coupleInfoModelFromJson(String str) => List<CoupleInfoModel>.from(json.decode(str).map((x) => CoupleInfoModel.fromJson(x)));

String coupleInfoModelToJson(List<CoupleInfoModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CoupleInfoModel {
  CoupleInfoModel({
    required this.coupleCode,
    required this.coupleAnniversary,
    required this.coupleUserId,
    required this.coupleStartDate,
    this.coupleEndDate,
  });

  DateTime coupleCode;
  String coupleAnniversary;
  List<String> coupleUserId;
  DateTime? coupleStartDate;
  DateTime? coupleEndDate;

  factory CoupleInfoModel.fromJson(Map<String, dynamic> json) => CoupleInfoModel(
    coupleCode: DateTime.parse(json['dateInfo'].toString()),
    coupleAnniversary: json["userId"],
    coupleUserId: List<String>.from(json["coupleUserId"]),
    coupleStartDate: json["coupleStartDate"],
    coupleEndDate: json["coupleEndDate"],
  );

  Map<String, dynamic> toJson() => {
    "dateInfo": coupleCode,
    "userId": coupleAnniversary,
    "coupleUserId": coupleUserId,
    "coupleStartDate": coupleStartDate,
    "coupleEndDate": coupleEndDate,
  };
}