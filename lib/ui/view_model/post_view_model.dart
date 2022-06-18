import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_seflie_app/data/model/post_model.dart';
import 'package:couple_seflie_app/data/repository/auth_service.dart';
import 'package:couple_seflie_app/data/repository/firebase_cloud_messaging_service.dart';
import 'package:couple_seflie_app/data/repository/post_info_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/datasource/remote_datasource.dart';

class PostViewModel extends ChangeNotifier {
  late String _currentUserId;
  final PostInfoRepository _postInfoRepository = PostInfoRepository();
  final FirebaseCloudMessagingService _firebaseCloudMessagingService = FirebaseCloudMessagingService();
  bool _loading = false;
  bool _isPostReady = false;
  bool _isPostOk = false;
  bool _isNewPost = false;
  bool _isNewImage = false;
  int _postId = 0;
  String? _postFailMessage;
  late String _downloadResultMessage;
  String? _postErrorMessage;
  File? _postImage;
  late String _tempImageUrl;
  PostModel? _post;
  int _nWeather = 0;

  String get currentUserId => _currentUserId;
  File? get postImage => _postImage;
  PostModel? get post => _post;
  bool get loading => _loading;
  bool get isNewPost => _isNewPost;
  bool get isPostReady => _isPostReady;
  bool get isPostOk => _isPostOk;
  bool get isNewImage => _isNewImage;
  String? get postErrorMessage => _postErrorMessage;
  String? get postFailMessage => _postFailMessage;
  String get downloadResultMessage => _downloadResultMessage;
  int get postId => _postId;
  int get nWeather => _nWeather;
  String get tempImageUrl => _tempImageUrl;
  String get dateTimeNow => (DateTime.now().hour > 12 ? "PM " +  (DateTime.now().hour - 12).toString() : "AM " +  DateTime.now().hour.toString()) + "시 " + DateTime.now().minute.toString() + "분";

  checkIsPostOk(){
    if(postId == 0){
      _isNewPost = true;
      _isNewImage = true;
      if(_postImage != null) {
        _isPostReady = true;
        _postErrorMessage = null;
      }
      else {
        _isPostReady = false;
        _postErrorMessage = "사진을 등록해주세요";
      }
    }
    else{
      _isNewPost = false;
      _isPostReady = true;
      if(_postImage == null){
        _isNewImage = false;
        _postErrorMessage = null;
      }
      else{
        _isNewImage = true;
        _postErrorMessage = null;
      }
    }
    notifyListeners();
  }
  // set temp image
  setTempImageUrl(String imageUrl){
    _tempImageUrl = imageUrl;
  }

  setPostText(String postText){
    _post!.postText = postText;
    notifyListeners();
  }

  Future<void> setLocation(String location) async{
    _post!.postLocation = location;
    notifyListeners();
  }

  setPostWeather(int nWeather) {
    _post!.postWeather = nWeather;
    notifyListeners();
  }

  //get image from local
  pickImage(ImageSource imageSource) async {
    var response = await _postInfoRepository.readImage(imageSource);
    if(response != null){
      _postImage = response;
      notifyListeners();
    }
  }

  setEmptyPost() async {
    _post = PostModel(
        postId: 0,
        postUserId: await AuthService().getCurrentUserId(),
        postImageUrl: "",
        postEditTime: DateTime.now(),
        postIsPublic: false,
    );
    notifyListeners();
  }
  
  // get post via postId
  Future<void> getPost(int postId) async {
    // loading...start
    _currentUserId = await AuthService().getCurrentUserId();
    print("이거");

    _postId = postId;
    print(_postId);

    // request add new post
    var response = await _postInfoRepository.readPost(_postId);
    print(response);

    // success -> add new data to Post
    if(response is Success) {
      print("성공");
      _post = postFromJson(response.response);
      //notifyListeners();
    }

    // failure -> put errorCode to failure
    if(response is Failure) {
      _postFailMessage = response.errorResponse;
      //notifyListeners();
    }
  }
  
  // creat new post
  createPost() async {
    // loading...start
    _loading = true;
    notifyListeners();

    var response = await _postInfoRepository.createPost(_post!);

    // success -> add new data to Post
    if(response is Success) {
      print("응답 확인");
      print(response.response);
      var responseImg = await _postInfoRepository.createS3(_postImage!, response.response["s3Url"]);
      if(responseImg is Success) {
        _postImage = null;
        await getPost(response.response["postId"]);
        await _firebaseCloudMessagingService.pushUploadedNotification();
        _postFailMessage = null;
        _isPostOk = true;
      }
      if(responseImg is Failure) {
        _postFailMessage = responseImg.errorResponse;
        _isPostOk = false;
      }
    }

    // failure -> put errorCode to failure
    if(response is Failure) {
      _postFailMessage = response.errorResponse;
      _isPostOk = false;
    }

    // loading...end
    _loading = false;
  }
  
  // edit post
  Future<void> editPost() async {
    // loading...start
    _loading = true;
    notifyListeners();

    print("여기는 되나");
    print("postId ${_post!.postId}");
    // request edit post

    var response = await _postInfoRepository.updatePost(_post!);

    // success -> update new data to Post
    if(response is Success) {
      if(postImage != null) {
        var responseImg = await _postInfoRepository.createS3(_postImage!, response.response["s3Url"]);
        if(responseImg is Success) {
          await CachedNetworkImage.evictFromCache(_post!.postImageUrl);
          _postImage = null;
          await getPost(_post!.postId);
          var result = await _firebaseCloudMessagingService.pushUploadedNotification();
          print("푸시 알림");
          print(result);
          _postFailMessage = null;
          _isPostOk = true;
        }
        if(responseImg is Failure) {
          _postFailMessage = responseImg.errorResponse;
          _isPostOk = false;
        }
      }
      else{
        var result = await _firebaseCloudMessagingService.pushUploadedNotification();
        print("푸시 알림");
        print(result);
        _postFailMessage = null;
        _isPostOk = true;
      }
    }

    // failure -> put errorCode to failure
    if(response is Failure) {
      _postFailMessage = response.errorResponse;
      _isPostOk = false;
    }

    // loading...end
    _loading = false;

  }

  Future<void> downloadImage() async {
    var responese = await _postInfoRepository.downloadImage(_post!.postImageUrl);
    if(responese is Success) {
      _downloadResultMessage = "사진이 성공적으로 다운로드되었습니다.";
    }
    if(responese is Failure) {
      print("다운로드실패${responese.errorResponse}");
      _downloadResultMessage = "사진 다운로드에 실패하였습니다.";
    }
  }

  clearLocalImage(){
    _postImage = null;
  }
}