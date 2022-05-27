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
  late Failure _failure;
  int _postId = 0;
  String? _errorMessage;
  File? _postImage;
  late String _tempImageUrl;
  PostModel? _post;

  String get currentUserId => _currentUserId;
  File? get postImage => _postImage;
  PostModel? get post => _post;
  Failure get failure => _failure;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  int get postId => _postId;
  String get tempImageUrl => _tempImageUrl;
  String get dateTimeNow => (DateTime.now().hour > 12 ? "PM " +  (DateTime.now().hour - 12).toString() : "AM " +  DateTime.now().hour.toString()) + "시 " + DateTime.now().minute.toString() + "분";

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

  // set postId
  setPostId(int postId) {
    _postId = postId;
    // notifyListeners();
  }

  //get image from local
  pickImage(ImageSource imageSource) async {
    setLoading(true);
    var response = await _postInfoRepository.getImage(imageSource);
    if(response != null){
      setPostImage(response);
    }
    setLoading(false);
  }

  // set postImage
  setPostImage(File? postImage) {
    _postImage = postImage;
    notifyListeners();
  }

  setEmptyPost(){
    _post = PostModel(
        postId: 0,
        postUserId: "",
        postImageUrl: "",
        postEditTime: DateTime.now(),
        postIsPublic: true,
    );
    notifyListeners();
  }

  // set post
  setPost(PostModel post) {
    _post = post;
    print("성공");
    //PostDailyInfoWidgetViewModel().setPostDate(post.postEditTime);
    notifyListeners();
  }

  // Whether the process is in progress
  setLoading(bool loading){
    _loading = loading;
    notifyListeners();
  }

  // when error observed in process
  setFailure(Failure failure){
    _failure = failure;
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
    var response = await _postInfoRepository.getPost(_postId);
    print(response);

    // success -> add new data to Post
    if(response is Success) {
      print("성공");
      setPost(postFromJson(response.response));
    }

    // failure -> put errorCode to failure
    if(response is Failure) {
      print("실패");
      setFailure(response);
    }

    // loading...end
    setLoading(false);
  }
  
  // creat new post
  createPost(PostModel postModel) async {
    // loading...start
    setLoading(true);

    // temp
    ///S3 업로드 -> get 주소

    // request add new post
    // postId = ""
    var response = await _postInfoRepository.createPost(postModel);

    // success -> add new data to Post
    if(response is Success) {
      setPostImage(null);
      setPost(postFromJson(response.response));
    }

    // failure -> put errorCode to failure
    if(response is Failure) {
      setFailure(response);
    }

    // loading...end
    setLoading(false);
  }
  
  // edit post
  Future<void> editPost(PostModel postModel) async {
    // loading...start
    setLoading(true);

    print("postId${postModel.postId}");
    // request edit post
    var response = await _postInfoRepository.editPost(postModel);

    // success -> update new data to Post
    if(response is Success) {
      setPostImage(null);
      print("성공");
      await getPost(_postId);
      //setPost(postFromJson(response.response));
    }

    // failure -> put errorCode to failure
    if(response is Failure) {
      _errorMessage = response.errorResponse;
      notifyListeners();
      setFailure(response);
    }

    // loading...end
    setLoading(false);
  }
}