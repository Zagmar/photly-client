import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_seflie_app/data/model/daily_couple_post_model.dart';
import 'package:couple_seflie_app/data/repository/daily_couple_post_repository.dart';
import 'package:flutter/material.dart';
import '../../data/datasource/remote_datasource.dart';
import '../../data/repository/firebase_cloud_messaging_service.dart';
import '../../data/repository/user_info_repository.dart';

class DailyCouplePostViewModel extends ChangeNotifier {
  final DailyCouplePostRepository _dailyCouplePostRepository = DailyCouplePostRepository();
  final UserInfoRepository _userInfoRepository = UserInfoRepository();
  final FirebaseCloudMessagingService _firebaseCloudMessagingService = FirebaseCloudMessagingService();
  final int _nRequestDailyCouplePosts = 3;

  List<DailyCouplePostModel> _dailyCouplePosts = [];
  DailyCouplePostModel _dailyCouplePost = DailyCouplePostModel();
  int? _index;
  bool _isCouple = false;
  String? _resultMessage;
  String? _failMessage;
  DateTime? _lastPushTime;

  List<DailyCouplePostModel> get dailyCouplePosts => _dailyCouplePosts;
  DailyCouplePostModel get dailyCouplePost => _dailyCouplePost;
  int? get index => _index;
  bool get isCouple => _isCouple;
  String? get resultMessage => _resultMessage;

  Future<void> initDailyCouplePosts() async {
    await _checkIsCouple();
    if(_dailyCouplePosts.isEmpty){
      await _firebaseCloudMessagingService.fcmSetting();
      await _loadDailyCouplePosts();
      await _setDailyInfo(0);
      notifyListeners();
    }
  }

  Future<void> pushPartner() async {
    if(_lastPushTime == null || DateTime.now().isAfter(_lastPushTime!.add(Duration(minutes: 1)))){
      var response = await _firebaseCloudMessagingService.pushPartnerToUpload();
      if(response is Success){
        _lastPushTime = DateTime.now();
        _resultMessage = "상대방을 푸시하였습니다";
        notifyListeners();
      }
      if(response is Failure){
        _resultMessage = "푸시하기 중 오류가 발생했습니다. 다시 시도해주세요";
        notifyListeners();
      }
    }
    else {
      _resultMessage = "푸시하기 후에는 1분이 지나야 다시 푸시가 가능합니다";
      notifyListeners();
    }
  }

  Future<void> refreshTodayCouplePost() async {
    await _checkIsCouple();
    var response =  await _dailyCouplePostRepository.getDailyCouplePosts(DateTime.now(), 1);
    if(response is Success) {
      _dailyCouplePosts.first = DailyCouplePostModel.fromJson((response.response as List).first);
      await _setPage(_dailyCouplePosts.first);

      if(_dailyCouplePosts.first.dailyPostDate!.year != DateTime.now().year || _dailyCouplePosts.first.dailyPostDate!.month != DateTime.now().month || _dailyCouplePosts.first.dailyPostDate!.day != DateTime.now().day) {
        await _createTodayCouplePost();
        await _setPage(_dailyCouplePosts.first);
      }
    }
    else if(response is Failure) {
      _failMessage = response.errorResponse;
    }
    notifyListeners();
  }

  Future<void> loadMoreCouplePosts() async{
    await _loadDailyCouplePosts();
    notifyListeners();
  }

  Future<void> setDailyInfo(index) async {
    await _setDailyInfo(index);
    notifyListeners();
  }

  Future<void> clear() async {
    _dailyCouplePosts = [];
    _dailyCouplePost = DailyCouplePostModel();
    _failMessage = null;
    _index = null;
    _resultMessage = null;
    _isCouple = false;
  }

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

  Future<void> _createTodayCouplePost() async {
    var response = await _dailyCouplePostRepository.createDailyCouplePost();
    if(response is Failure) {
      _failMessage = response.errorResponse;
    }
    if(response is Success) {
      DailyCouplePostModel newDailyCouplePostModel = DailyCouplePostModel.fromJson(response.response);
      _dailyCouplePosts = [newDailyCouplePostModel] + _dailyCouplePosts;
    }
  }

  Future<void> _loadDailyCouplePosts() async {
    var response = await _dailyCouplePostRepository.getDailyCouplePosts(_dailyCouplePosts.isEmpty?DateTime.now():_dailyCouplePosts.last.dailyPostDate!.subtract(Duration(days: 1)), _nRequestDailyCouplePosts);

    if(response is Failure) {
      _failMessage = response.errorResponse;
    }

    if(response is Success) {
      List<DailyCouplePostModel> newDailyCouplePostList = [];
      if((response.response as List).isNotEmpty){
        List list = response.response as List;
        for (var element in list) {
          newDailyCouplePostList.add(DailyCouplePostModel.fromJson(element));
        }
        _dailyCouplePosts += newDailyCouplePostList;
      }
      else{
        await _createTodayCouplePost();
      }
      if(_dailyCouplePosts.first.dailyPostDate!.year != DateTime.now().year || _dailyCouplePosts.first.dailyPostDate!.month != DateTime.now().month || _dailyCouplePosts.first.dailyPostDate!.day != DateTime.now().day) {
        await _createTodayCouplePost();
      }
      await _setPages(_dailyCouplePosts);
    }
  }

  Future<void> _setDailyInfo(index) async {
    _index = index;
    _dailyCouplePost = _dailyCouplePosts[index];
  }

  Future<void> _setPage(DailyCouplePostModel _dailyCouplePostModel) async {
    if(DateTime.now().year == _dailyCouplePostModel.dailyPostDate!.year && DateTime.now().month == _dailyCouplePostModel.dailyPostDate!.month && DateTime.now().day == _dailyCouplePostModel.dailyPostDate!.day){
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

    if(_dailyCouplePostModel.userPostId != null){
      _dailyCouplePostModel.isUserDone = true;
    }
    else{
      _dailyCouplePostModel.isUserDone = false;
    }

    if(_dailyCouplePostModel.partnerPostId != null){
      _dailyCouplePostModel.isPartnerDone = true;
    }
    else{
      _dailyCouplePostModel.isPartnerDone = false;
    }
  }

  Future<void> _setPages(List<DailyCouplePostModel> newDailyCouplePosts) async {
    for (DailyCouplePostModel _dailyCouplePostModel in newDailyCouplePosts) {
      await _setPage(_dailyCouplePostModel);
    }
  }
}