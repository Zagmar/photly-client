const List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

class DailyCouplePostModel {
  DailyCouplePostModel({
    this.dailyPostDate,
    this.year,
    this.month,
    this.day,
    this.questionType,
    this.questionText1,
    this.questionText2,
    this.questionImageUrl,
    this.userPostId,
    this.userPostImageUrl,
    this.partnerPostId,
    this.partnerPostImageUrl,
    this.isToday,
    this.isUserDone,
    this.isPartnerDone
  });

  DateTime? dailyPostDate;
  String? year;
  String? month;
  String? day;
  int? questionType;
  String? questionText1;
  String? questionText2;
  String? questionImageUrl;
  int? userPostId;
  String? userPostImageUrl;
  int? partnerPostId;
  String? partnerPostImageUrl;
  bool? isToday;
  bool? isUserDone;
  bool? isPartnerDone;

  factory DailyCouplePostModel.fromJson(Map<String, dynamic> json) => DailyCouplePostModel(
    dailyPostDate: DateTime.parse(json['dailyPostDate']),
    year: DateTime.parse(json['dailyPostDate']).year.toString(),
    month: months[DateTime.parse(json['dailyPostDate']).month - 1],
    day: DateTime.parse(json['dailyPostDate']).day.toString(),
    questionType: json["questionType"],
    questionText1: json["questionText"].split("/").first,
    questionText2: json["questionText"].split("/").last,
    questionImageUrl: json["questionImageUrl"],
    userPostId: json["userPostId"],
    userPostImageUrl: json["userPostImageUrl"],
    partnerPostId: json["partnerPostId"],
    partnerPostImageUrl: json["partnerPostImageUrl"],
  );
}