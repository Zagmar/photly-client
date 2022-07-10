import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_seflie_app/data/model/post_model.dart';
import 'package:couple_seflie_app/data/repository/auth_service.dart';
import 'package:couple_seflie_app/data/repository/firebase_cloud_messaging_service.dart';
import 'package:couple_seflie_app/data/repository/post_info_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/datasource/remote_datasource.dart';
import '../../data/repository/data_repository.dart';

class PostViewModel extends ChangeNotifier {
  final PostInfoRepository _postInfoRepository = PostInfoRepository();
  final FirebaseCloudMessagingService _firebaseCloudMessagingService = FirebaseCloudMessagingService();

  String? _resultMessage;
  String? _inputErrorMessage;
  bool _resultSuccess = false;
  bool _inputOk = false;
  String? _input;
  bool _loading = false;
  bool _isNewPost = false;
  bool _isEditable = false;
  File? _postImage;
  PostModel? _post;

  String? get resultMessage => _resultMessage;
  String? get inputErrorMessage => _inputErrorMessage;
  bool get resultSuccess => _resultSuccess;
  bool get inputOk => _inputOk;
  String? get input => _input;
  bool get loading => _loading;
  File? get postImage => _postImage;
  PostModel? get post => _post;
  bool get isEditable => _isEditable;
  String get dateTimeNow => dateTimeToString(DateTime.now());

  String dateTimeToString(DateTime dateTime) {
    return (dateTime.hour > 12 ? "PM " +  (dateTime.hour - 12).toString() : "AM " +  dateTime.hour.toString()) + "시 " + dateTime.minute.toString() + "분";
  }

  Future<void> checkIsPostOk() async{
    if(_post!.postId == 0){
      _isNewPost = true;
      if(_postImage != null) {
        _inputOk = true;
        _inputErrorMessage = null;
      }
      else {
        _inputOk = false;
        _inputErrorMessage = "사진을 등록해주세요";
      }
    }
    else{
      _isNewPost = false;
      _inputOk = true;
      if(_postImage == null){
        _inputErrorMessage = null;
      }
      else{
        _inputErrorMessage = null;
      }
    }
    notifyListeners();
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

  pickImage(ImageSource imageSource) async {
    var response = await _postInfoRepository.readImage(imageSource);
    if(response != null){
      _postImage = response;
      notifyListeners();
    }
  }

  setEmptyPost() async {
    await clearAll();
    _post = PostModel(
        postId: 0,
        postUserId: await AuthService().getCurrentUserId(),
        postImageUrl: "",
        postEditTime: DateTime.now(),
        postIsPublic: false,
        postText: null,
        postEmotion: null,
        postLocation: null,
        postWeather: null
    );
    notifyListeners();
  }
  
  Future<void> getPost(int postId) async {
    var response = await _postInfoRepository.readPost(postId);
    if(response is Success) {
      _resultSuccess = true;
      _resultMessage = null;
      _post = PostModel.fromJson(response.response);
      if(DateTime(_post!.postEditTime.year,_post!.postEditTime.month, _post!.postEditTime.day) == DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day) && _post!.postUserId != await AuthService().getCurrentUserId()){
        DataRepository().sendReadPoint();
      }
      _isEditable = _post!.postUserId == await AuthService().getCurrentUserId() && _post!.postEditTime.year == DateTime.now().year && _post!.postEditTime.month == DateTime.now().month && _post!.postEditTime.day == DateTime.now().day;
    }
    if(response is Failure) {
      _resultMessage = response.errorResponse;
    }
  }

  Future<void> postPost() async {
    _loading = true;
    notifyListeners();

    var response = _isNewPost ?
    await _postInfoRepository.createPost(_post!)
        :
    await _postInfoRepository.updatePost(_post!);

    if(response is Success) {
      if(_isNewPost || _postImage != null){
        var responseImg = await _postInfoRepository.createS3(_postImage!, response.response["s3Url"]);
        if(responseImg is Success) {
          if(!_isNewPost) {
            await CachedNetworkImage.evictFromCache(_post!.postImageUrl);
          }
          _postImage = null;
          await getPost(response.response["postId"]??_post!.postId);
          await _firebaseCloudMessagingService.pushUploadedNotification();
          _resultMessage = null;
          _resultSuccess = true;
        }
        if(responseImg is Failure) {
          _resultMessage = responseImg.errorResponse;
          _resultSuccess = false;
        }
      }
      else{
        await _firebaseCloudMessagingService.pushUploadedNotification();
        _resultMessage = null;
        _resultSuccess = true;
      }
    }

    if(response is Failure) {
      _resultMessage = response.errorResponse;
      _resultSuccess = false;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> downloadImage() async {
    var response = await _postInfoRepository.downloadImage(_post!.postImageUrl);
    if(response is Success) {
      _resultSuccess = true;
      _resultMessage = "사진이 성공적으로 다운로드되었습니다.";
    }
    if(response is Failure) {
      _resultSuccess = false;
      _resultMessage = "사진 다운로드에 실패하였습니다.";
    }
  }

  Future<void> clearAll() async{
    _post = null;
    await clearCheck();
  }

  Future<void> clearCheck() async{
    _resultMessage = null;
    _inputErrorMessage = null;
    _resultSuccess = false;
    _inputOk = false;
    _input = null;
    _isNewPost = false;
    _loading = false;
    _postImage = null;
  }
}