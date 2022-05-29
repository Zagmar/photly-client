import 'dart:io';

import 'package:couple_seflie_app/data/model/post_model.dart';
import 'package:couple_seflie_app/data/repository/auth_service.dart';
import 'package:couple_seflie_app/data/repository/post_info_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/datasource/remote_datasource.dart';

class PostViewModel extends ChangeNotifier {
  late String _currentUserId;
  final _postInfoRepository = PostInfoRepository();
  bool _loading = false;
  bool _isPostReady = false;
  bool _isPostOk = false;
  bool _isNewPost = false;
  bool _isNewImage = false;
  int _postId = 0;
  String? _postFailMessage;
  String? _postErrorMessage;
  File? _postImage;
  late String _tempImageUrl;
  PostModel? _post;

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
  int get postId => _postId;
  String get tempImageUrl => _tempImageUrl;
  String get dateTimeNow => (DateTime.now().hour > 12 ? "PM " +  (DateTime.now().hour - 12).toString() : "AM " +  DateTime.now().hour.toString()) + "시 " + DateTime.now().minute.toString() + "분";

  checkIsPostOk(){
    if(postId == 0){
      _isNewPost = true;
      _isNewImage = true;
      if(_postImage == null) {
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

  setPostLocation(String location) {
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

  // Whether the process is in progress
  setLoading(bool loading){
    _loading = loading;
    notifyListeners();
  }
  
  // get post via postId
  Future<void> getPost(int postId) async {
    // loading...start
    setLoading(true);
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
      notifyListeners();
    }

    // failure -> put errorCode to failure
    if(response is Failure) {
      _postFailMessage = response.errorResponse;
      notifyListeners();
    }

    // loading...end
    setLoading(false);
  }

  Future<void> createS3(File image, String url) async {
    // temp
    // S3 업로드 기능
  }
  
  // creat new post
  createPost() async {
    // loading...start
    setLoading(true);

    var response = await _postInfoRepository.createPost(_post!);

    // success -> add new data to Post
    if(response is Success) {
      await createS3(_postImage!, response.response["postImageUrl"]);
      _postImage = null;
      await getPost(response.response["postId"]);
      _isPostOk = true;
    }

    // failure -> put errorCode to failure
    if(response is Failure) {
      _postFailMessage = response.errorResponse;
      _isPostOk = false;
    }

    // loading...end
    setLoading(false);
  }
  
  // edit post
  Future<void> editPost() async {
    // loading...start
    setLoading(true);

    print("postId ${_post!.postId}");
    // request edit post

    var response = await _postInfoRepository.updatePost(_post!);

    if(postImage != null) {
      await createS3(_postImage!, _post!.postImageUrl);
    }

    // success -> update new data to Post
    if(response is Success) {
      _postImage = null;
      await getPost(_postId);
      _isPostOk = true;
    }

    // failure -> put errorCode to failure
    if(response is Failure) {
      _postFailMessage = response.errorResponse;
      _isPostOk = false;
    }

    // loading...end
    setLoading(false);
  }
}