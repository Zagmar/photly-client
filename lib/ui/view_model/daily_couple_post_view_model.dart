import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_seflie_app/data/model/daily_couple_post_model.dart';
import 'package:couple_seflie_app/data/repository/auth_service.dart';
import 'package:couple_seflie_app/data/repository/daily_couple_post_repository.dart';
import 'package:flutter/material.dart';

import '../../data/datasource/remote_datasource.dart';
import '../../data/repository/firebase_cloud_messaging_service.dart';
import '../../data/repository/user_info_repository.dart';

class DailyCouplePostViewModel extends ChangeNotifier {
  final DailyCouplePostRepository _dailyCouplePostRepository = DailyCouplePostRepository();
  final UserInfoRepository _userInfoRepository = UserInfoRepository();
  final FirebaseCloudMessagingService _firebaseCloudMessagingService = FirebaseCloudMessagingService();

  bool _isLoadDone = false;

  // List of name of months in English
  List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  List<DailyCouplePostModel> _dailyCouplePosts = []; // Data list for page view
  String? _userId;

  final int _nDailyCouplePosts = 3; // Number of request data via API
  String? _errorMessage; // Error message when fail to load data through repository
  int? _index;

  String? _year;
  String? _month;
  String? _day;
  int? _questionType;
  String? _questionText1;
  String? _questionText2;
  String? _questionImageUrl;

  DateTime? _lastPushTime;
  String _pushResultMessage = "";

  bool _isCouple = false;

  List<DailyCouplePostModel> get dailyCouplePosts => _dailyCouplePosts;
  int? get index => _index;
  bool get isLoadDone => _isLoadDone;

  String get year => _year!;
  String get month => _month!;
  String get day => _day!;
  int get questionType => _questionType!;
  String get questionText1 => _questionText1!;
  String get questionText2 => _questionText2!;
  String? get questionImageUrl => _questionImageUrl;
  bool get isCouple => _isCouple;
  String get pushResultMessage => _pushResultMessage;

  /// Load data for initialize mainScreen
  Future<void> initDailyCouplePosts() async {
    await _checkIsCouple();
    if(_dailyCouplePosts.isEmpty){
      await _firebaseCloudMessagingService.fcmSetting();
      _userId = await AuthService().getCurrentUserId();
      await _loadDailyCouplePosts();
      await _setDailyInfo(0);
      _isLoadDone = true;
      notifyListeners();
    }
  }

  /// Push partner to upload
  Future<void> pushPartner() async {
    if(_lastPushTime == null || DateTime.now().isAfter(_lastPushTime!.add(Duration(minutes: 1)))){
      var response = await _firebaseCloudMessagingService.pushPartnerToUpload();
      if(response is Success){
        _lastPushTime = DateTime.now();
        _pushResultMessage = "상대방을 푸시하였습니다";
        notifyListeners();
      }
      if(response is Failure){
        _pushResultMessage = "푸시하기 중 오류가 발생했습니다. 다시 시도해주세요";
        notifyListeners();
      }
    }
    else {
      _pushResultMessage = "푸시하기 후에는 1분이 지나야 다시 푸시가 가능합니다";
      notifyListeners();
    }
  }

  /// Refresh today's couple post
  Future<void> refreshTodayCouplePost() async {
    await _checkIsCouple();
    // call API
    var response =  await _dailyCouplePostRepository.getDailyCouplePosts(_userId!, DateTime.now(), 1);

    // success -> update data to DailyCouplePosts
    if(response is Success) {
      _dailyCouplePosts.first = DailyCouplePostModel.fromJson((response.response as List).first);
      await _setPage(_dailyCouplePosts.first);

      // Not exist today's couple post
      if(_dailyCouplePosts.first.dailyPostDate.year != DateTime.now().year || _dailyCouplePosts.first.dailyPostDate.month != DateTime.now().month || _dailyCouplePosts.first.dailyPostDate.day != DateTime.now().day) {
        await _createTodayCouplePost();
        await _setPage(_dailyCouplePosts.first);
      }
    }

    // failure -> put errorCode to failure
    else if(response is Failure) {
      _errorMessage = response.errorResponse;
    }

    notifyListeners();
  }

  /// Load more couple posts in page view
  Future<void> loadMoreCouplePosts() async{
    await _loadDailyCouplePosts();
    notifyListeners();
  }

  /// Set present couple post in page view
  Future<void> setDailyInfo(index) async {
    await _setDailyInfo(index);
    notifyListeners();
  }

  /// Clear data in dailyCouplePostViewModel provider
  Future<void> clear() async {
    _dailyCouplePosts = []; // Data list for page view
    _userId = null;
    _errorMessage = null; // Error message when fail to load data through repository
    _index = null;
    _isLoadDone = false;

    _year = null;
    _month = null;
    _day = null;
    _questionType = null;
    _questionText1 = null;
    _questionText2 = null;
    _questionImageUrl = null;

    _isCouple = false;
  }

  // Check whether user has partner
  Future<void> _checkIsCouple() async {
    var response = await _userInfoRepository.getPartner();
    if(response is Failure) {
      _isCouple = false;
    }
    if(response is Success) {
      if(response.response["has_partner"] == 0){
        _isCouple = false;
      }
      else{
        _isCouple = true;
      }
    }
  }

  // Create today's couple post
  Future<void> _createTodayCouplePost() async {
    // request (_nDailyCouplePosts) days' posts before last loaded day
    var response = await _dailyCouplePostRepository.createDailyCouplePost(_userId!);

    // failure -> put errorCode to failure
    if(response is Failure) {
      _errorMessage = response.errorResponse;
    }

    // success -> add new data to DailyCouplePosts & load
    if(response is Success) {
      DailyCouplePostModel newDailyCouplePostModel = DailyCouplePostModel.fromJson(response.response);
      _dailyCouplePosts = [newDailyCouplePostModel] + _dailyCouplePosts;
    }
  }

  // Load couple posts
  Future<void> _loadDailyCouplePosts() async {
    // Request (_nDailyCouplePosts) days' posts before last loaded day
    var response = await _dailyCouplePostRepository.getDailyCouplePosts(_userId!, _dailyCouplePosts.isEmpty?DateTime.now():_dailyCouplePosts.last.dailyPostDate.subtract(Duration(days: 1)), _nDailyCouplePosts);

    // Failure -> Put errorCode to failure
    if(response is Failure) {
      //await createTodayCouplePost();
      _errorMessage = response.errorResponse;
    }

    // Success -> Put data to DailyCouplePosts
    if(response is Success) {
      List<DailyCouplePostModel> newDailyCouplePostList = [];

      // Exist couple posts
      if((response.response as List).isNotEmpty){
        List list = response.response as List;
        for (var element in list) {
          newDailyCouplePostList.add(DailyCouplePostModel.fromJson(element));
        }
        _dailyCouplePosts += newDailyCouplePostList;
      }
      // Not exist couple posts
      else{
        // Create first couple post
        await _createTodayCouplePost();
      }

      // Not exist today's couple post
      if(_dailyCouplePosts.first.dailyPostDate.year != DateTime.now().year || _dailyCouplePosts.first.dailyPostDate.month != DateTime.now().month || _dailyCouplePosts.first.dailyPostDate.day != DateTime.now().day) {
        await _createTodayCouplePost();
      }
      await _setPages(_dailyCouplePosts);
    }
  }

  // Set daily info of couple post at index
  Future<void> _setDailyInfo(index) async {
    // Set Index
    _index = index;

    // Set DateTime
    DateTime dateTime = _dailyCouplePosts[index].dailyPostDate;
    _year = dateTime.year.toString();
    _month = months[dateTime.month - 1];
    _day = dateTime.day.toString();

    // Set question data
    _questionType = _dailyCouplePosts[index].questionType;
    _questionText1 = _dailyCouplePosts[index].questionText.split("/").first;
    _questionText2 = _dailyCouplePosts[index].questionText.split("/").last;
    _questionImageUrl = _dailyCouplePosts[index].questionImageUrl;
  }

  // Set info of single couple post
  Future<void> _setPage(DailyCouplePostModel _dailyCouplePostModel) async {
    // Set date data
    if(DateTime.now().year == _dailyCouplePostModel.dailyPostDate.year && DateTime.now().month == _dailyCouplePostModel.dailyPostDate.month && DateTime.now().day == _dailyCouplePostModel.dailyPostDate.day){
      _dailyCouplePostModel.isToday = true;
      if(_dailyCouplePostModel.userPostImageUrl != null){
        await CachedNetworkImage.evictFromCache(_dailyCouplePostModel.userPostImageUrl!);
      }
      if(_dailyCouplePostModel.partnerPostImageUrl != null){
        await CachedNetworkImage.evictFromCache(_dailyCouplePostModel.partnerPostImageUrl!);
      }
    }
    else{
      _dailyCouplePostModel.isToday = false;
    }

    // CheckIsUserDone
    if(_dailyCouplePostModel.userPostId != null){
      _dailyCouplePostModel.isUserDone = true;
    }
    else{
      _dailyCouplePostModel.isUserDone = false;
    }

    // CheckIsPartnerDone
    if(_dailyCouplePostModel.partnerPostId != null){
      _dailyCouplePostModel.isPartnerDone = true;
    }
    else{
      _dailyCouplePostModel.isPartnerDone = false;
    }
  }

  // Set info of list of couple post
  Future<void> _setPages(List<DailyCouplePostModel> newDailyCouplePosts) async {
    for (DailyCouplePostModel _dailyCouplePostModel in newDailyCouplePosts) {
      await _setPage(_dailyCouplePostModel);
    }
  }
}