import 'dart:convert';

List<PostModel> postListFromJson(String str) => List<PostModel>.from(json.decode(str).map((x) => PostModel.fromJson(x)));
PostModel postFromJson(var str) => PostModel.fromJson(str);

String postInfoModelToJson(List<PostModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostModel {
  PostModel({
    required this.postId,
    required this.postUserId,
    required this.postImageUrl,
    required this.postEditTime,
    required this.postIsPublic,
    this.postText,
    this.postEmotion,
    this.postWeather,
    this.postLocation,
  });

  int postId;
  String postUserId;
  String postImageUrl;
  DateTime postEditTime;
  bool postIsPublic;
  String? postText;
  int? postEmotion;
  int? postWeather;
  String? postLocation;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    postId: json["postId"],
    postUserId: json["postUserId"],
    postImageUrl: json["postImageUrl"],
    postIsPublic: json["postIsPublic"] == 1,
    postEditTime: DateTime.parse(json['postEditTime']),
    postText: json["postText"],
    postEmotion: json["postEmotion"],
    postWeather: json["postWeather"],
    postLocation: json["postLocation"],
  );

  Map<String, dynamic> toJson() => {
    "postId": postId,
    "postUserId": postUserId,
    "postImageUrl": postImageUrl,
    "postIsPublic": postIsPublic,
    "postEditTime": postEditTime.toString(),
    "postText": postText,
    "postEmotion": postEmotion,
    "postWeather": postWeather,
    "postLocation": postLocation,
  };
}