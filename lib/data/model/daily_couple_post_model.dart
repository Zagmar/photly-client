import 'dart:convert';

List<DailyCouplePostModel> dailyCouplePostListFromJson(String str) => List<DailyCouplePostModel>.from(json.decode(str).map((x) => DailyCouplePostModel.fromJson(x)));
DailyCouplePostModel dailyCouplePostFromJson(String str) => DailyCouplePostModel.fromJson(json.decode(str));

String dailyCouplePostModelToJson(List<DailyCouplePostModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DailyCouplePostModel {
  DailyCouplePostModel({
    required this.postDate,
    required this.questionType,
    required this.questionText,
    this.questionImageUrl,
    this.userPostId,
    this.userPostImageUrl,
    this.partnerPostId,
    this.partnerPostImageUrl,
  });

  DateTime postDate;
  int questionType;
  String questionText;
  String? questionImageUrl;
  String? userPostId;
  String? userPostImageUrl;
  String? partnerPostId;
  String? partnerPostImageUrl;

  factory DailyCouplePostModel.fromJson(Map<String, dynamic> json) => DailyCouplePostModel(
    postDate: DateTime.parse(json['postDate'].toString()),
    questionType: json["questionId"],
    questionText: json["questionText"],
    questionImageUrl: json["questionImageUrl"],
    userPostId: json["userPostId"],
    userPostImageUrl: json["userPostImageUrl"],
    partnerPostId: json["partnerPostId"],
    partnerPostImageUrl: json["partnerPostImageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "postDate": postDate,
    "questionType": questionType,
    "questionText": questionText,
    "questionImageUrl": questionImageUrl,
    "userPostId": userPostId,
    "userPostImageUrl": userPostImageUrl,
    "partnerPostId": partnerPostId,
    "partnerPostImageUrl": partnerPostImageUrl,
  };
}