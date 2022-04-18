import 'dart:convert';

List<QuestionModel> questionModelFromJson(String str) => List<QuestionModel>.from(json.decode(str).map((x) => QuestionModel.fromJson(x)));

String questionModelToJson(List<QuestionModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QuestionModel {
  QuestionModel({
    required this.questionId,
    required this.questionType,
    required this.questionText,
    this.questionImageUrl,
  });

  int questionId;
  int questionType;
  String questionText;
  String? questionImageUrl;

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
    questionId: json["questionId"],
    questionType: json["questionType"],
    questionText: json["questionText"],
    questionImageUrl: json["questionImageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "questionId": questionId,
    "questionType": questionType,
    "questionText": questionText,
    "questionImageUrl": questionImageUrl,
  };
}