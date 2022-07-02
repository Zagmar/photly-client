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
}