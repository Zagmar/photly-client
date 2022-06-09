import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_seflie_app/data/model/daily_couple_post_model.dart';
import 'package:couple_seflie_app/data/repository/auth_service.dart';
import 'package:couple_seflie_app/data/repository/daily_couple_post_repository.dart';
import 'package:flutter/material.dart';

import '../../data/datasource/remote_datasource.dart';
import '../../data/repository/user_info_repository.dart';

class DailyCouplePostViewModel extends ChangeNotifier {
  final DailyCouplePostRepository _dailyCouplePostRepository = DailyCouplePostRepository();
  final _userInfoRepository = UserInfoRepository();

  // List of name of months in English
  List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  List<DailyCouplePostModel> _dailyCouplePosts = []; // Data list for page view
  String? _userId;

  final int _nDailyCouplePosts = 3; // Number of request data via API
  String? _errorMessage; // Error message when fail to load data through repository
  int? _index;

  bool _loading = true; // Set state to load screen until true (default : true)

  String? _year;
  String? _month;
  String? _day;
  int? _questionType;
  String? _questionText;
  String? _questionImageUrl;

  bool _isCouple = false;

  List<DailyCouplePostModel> get dailyCouplePosts => _dailyCouplePosts;
  bool get loading => _loading;
  int? get index => _index;

  String get year => _year!;
  String get month => _month!;
  String get day => _day!;
  int get questionType => _questionType!;
  String get questionText => _questionText!;
  String? get questionImageUrl => _questionImageUrl;
  bool get isCouple => _isCouple;

  // Init mainScreen
  Future<void> initDailyCouplePosts() async {
    _userId = await AuthService().getCurrentUserId();
    await checkIsCouple();
    if(_dailyCouplePosts.isEmpty){
      // set mainScreen to default
      await loadDailyCouplePosts();
      await setDailyInfo(0);
      notifyListeners();
    }
  }

  Future<void> checkIsCouple() async {
    var response = await _userInfoRepository.getPartner();
    if(response is Failure) {
      _isCouple = false;
    }
    if(response is Success) {
      if(response.response["partnerId"] == null){
        _isCouple = false;
      }
      else{
        _isCouple = true;
      }
    }
  }

  // create today's couple post
  Future<void> createTodayCouplePost() async {
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


  // refresh today's couple post
  Future<void> refreshTodayCouplePost() async {
    // call API
    var response =  await _dailyCouplePostRepository.getDailyCouplePosts(_userId!, DateTime.now(), 1);

    // success -> update data to DailyCouplePosts
    if(response is Success) {
      _dailyCouplePosts.first = DailyCouplePostModel.fromJson((response.response as List).first);
      await setPage(_dailyCouplePosts.first);
    }

    // failure -> put errorCode to failure
    else if(response is Failure) {
      _errorMessage = response.errorResponse;
    }

    notifyListeners();
  }

  // load couple posts
  Future<void> loadDailyCouplePosts() async {
    // request (_nDailyCouplePosts) days' posts before last loaded day
    var response = await _dailyCouplePostRepository.getDailyCouplePosts(_userId!, _dailyCouplePosts.isEmpty?DateTime.now():_dailyCouplePosts.last.dailyPostDate.subtract(Duration(days: 1)), _nDailyCouplePosts);

    // failure -> put errorCode to failure
    if(response is Failure) {
      await createTodayCouplePost();
      _errorMessage = response.errorResponse;
    }

    // success -> put data to DailyCouplePosts
    if(response is Success) {
      List<DailyCouplePostModel> newDailyCouplePostList = [];

      if((response.response as List).isNotEmpty){
        List list = response.response as List;
        for (var element in list) {
          newDailyCouplePostList.add(DailyCouplePostModel.fromJson(element));
        }
        _dailyCouplePosts += newDailyCouplePostList;
      } else{
        await createTodayCouplePost();
      }

      // Auto refresh today's couple post
      if(_dailyCouplePosts.first.dailyPostDate.year != DateTime.now().year || _dailyCouplePosts.first.dailyPostDate.month != DateTime.now().month || _dailyCouplePosts.first.dailyPostDate.day != DateTime.now().day) {
        await createTodayCouplePost();
      }
      await setPages(_dailyCouplePosts);
    }
  }

  Future<void> loadCouplePosts() async{
    await loadDailyCouplePosts();
    notifyListeners();
  }

  Future<void> setDailyInfo(index) async {
    _index = index;
    DateTime dateTime = _dailyCouplePosts[index].dailyPostDate;
    print(dateTime);

    _year = dateTime.year.toString();
    print(_year);


    _month = months[dateTime.month - 1];
    print(_month);


    _day = dateTime.day.toString();
    print(_day);


    // Set question data
    _questionType = _dailyCouplePosts[index].questionType;
    _questionText = _dailyCouplePosts[index].questionText;
    _questionImageUrl = _dailyCouplePosts[index].questionImageUrl;

    notifyListeners();
  }

  setLoading(bool loading){
    _loading = loading;
    notifyListeners();
  }

  setPage(DailyCouplePostModel _dailyCouplePostModel) async {
    setLoading(true);
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
    setLoading(false);
  }

  setPages(List<DailyCouplePostModel> newDailyCouplePosts) async {
    setLoading(true);

    print("페이지 세팅");
    //for (int index = 0; index < _dailyCouplePosts.length; index++) {
    for (DailyCouplePostModel _dailyCouplePostModel in newDailyCouplePosts) {
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

    setLoading(false);
  }

  Future<void> clear() async {
    _dailyCouplePosts = []; // Data list for page view
    _userId = null;
    _errorMessage = null; // Error message when fail to load data through repository
    _index = null;

    _loading = true; // Set state to load screen until true (default : true)

    _year = null;
    _month = null;
    _day = null;
    _questionType = null;
    _questionText = null;
    _questionImageUrl = null;

    _isCouple = false;
  }
}