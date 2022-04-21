import 'dart:convert';

List<DailyCouplePostModel> dailyCouplePostListFromJson(String str) => List<DailyCouplePostModel>.from(json.decode(str).map((x) => DailyCouplePostModel.fromJson(x)));

String dailyCouplePostModelToJson(List<DailyCouplePostModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DailyCouplePostModel {
  DailyCouplePostModel({
    required this.dailyPostDate,
    required this.questionType,
    required this.questionText,
    this.questionImageUrl,
    this.userPostId,
    this.userPostImageUrl,
    this.partnerPostId,
    this.partnerPostImageUrl,
  });

  String dailyPostDate;
  int questionType;
  String questionText;
  String? questionImageUrl;
  String? userPostId;
  String? userPostImageUrl;
  String? partnerPostId;
  String? partnerPostImageUrl;

  factory DailyCouplePostModel.fromJson(Map<String, dynamic> json) => DailyCouplePostModel(
    dailyPostDate: json['dailyPostDate'],
    questionType: json["questionId"],
    questionText: json["questionText"],
    questionImageUrl: json["questionImageUrl"],
    userPostId: json["userPostId"],
    userPostImageUrl: json["userPostImageUrl"],
    partnerPostId: json["partnerPostId"],
    partnerPostImageUrl: json["partnerPostImageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "dailyPostDate": dailyPostDate,
    "questionType": questionType,
    "questionText": questionText,
    "questionImageUrl": questionImageUrl,
    "userPostId": userPostId,
    "userPostImageUrl": userPostImageUrl,
    "partnerPostId": partnerPostId,
    "partnerPostImageUrl": partnerPostImageUrl,
  };
}