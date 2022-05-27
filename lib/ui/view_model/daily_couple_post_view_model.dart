
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:couple_seflie_app/data/model/daily_couple_post_model.dart';
import 'package:couple_seflie_app/data/repository/auth_service.dart';
import 'package:couple_seflie_app/data/repository/daily_couple_post_repository.dart';
import 'package:flutter/material.dart';

import '../../data/datasource/remote_datasource.dart';

class DailyCouplePostViewModel extends ChangeNotifier {
  final DailyCouplePostRepository _dailyCouplePostRepository = DailyCouplePostRepository();
  // List of name of months in English
  List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  List<DailyCouplePostModel> _dailyCouplePosts = []; // Data list for page view
  String? _userId;

  final int _nDailyCouplePosts = 3; // Number of request data via API
  String? _errorMessage; // Error message when fail to load data through repository
  int? _index;

  bool _loading = true; // Set state to load screen until true (default : true)

  late String _year;
  late String _month;
  late String _day;
  late int _questionType;
  late String _questionText;
  String? _questionImageUrl;

  List<DailyCouplePostModel> get dailyCouplePosts => _dailyCouplePosts;
  bool get loading => _loading;
  int? get index => _index;

  String get year => _year;
  String get month => _month;
  String get day => _day;
  int get questionType => _questionType;
  String get questionText => _questionText;
  String? get questionImageUrl => _questionImageUrl;

  // Init mainScreen
  Future<void> initDailyCouplePosts() async {
    _userId = await AuthService().getCurrentUserId();
    print(_userId);
    print("DailyCouplePostViewModel 생성자 실행");
    print(_dailyCouplePosts.length.toString() + "개 있음");
    if(_dailyCouplePosts.isEmpty){
      print("DailyCouplePostViewModel IF문 통과");
      // set mainScreen to default
      await loadDailyCouplePosts();
      //print(_dailyCouplePosts.length.toString() + "개 있음");
      await setDailyInfo(0);
    }
  }

  // create today's couple post
  // temp
  Future<void> createTodayCouplePost() async {
    print("createTodayCouplePost 실행");
    // request (_nDailyCouplePosts) days' posts before last loaded day
    var response = await _dailyCouplePostRepository.createDailyCouplePost(_userId!);
    print(response);

    // failure -> put errorCode to failure
    if(response is Failure) {
      print("createTodayCouplePost 합치기 실패");
      _errorMessage = response.errorResponse;
      notifyListeners();
    }

    // success -> add new data to DailyCouplePosts & load
    if(response is Success) {
      print(response.response);
      print("createTodayCouplePost 합치기 성공");
      DailyCouplePostModel newDailyCouplePostModel = DailyCouplePostModel.fromJson(response.response);
      //List<DailyCouplePostModel> newDailyCouplePostList = DailyCouplePostModel(response.response);
      //await setPages(newDailyCouplePostList);
      _dailyCouplePosts = [newDailyCouplePostModel] + _dailyCouplePosts;
      print(_dailyCouplePosts);
      //print(_dailyCouplePosts.length.toString() + "개 있음");
      //notifyListeners();
    }
  }


  // refresh today's couple post
  refreshTodayCouplePost() async {
    // call API
    var response =  await _dailyCouplePostRepository.getDailyCouplePosts(_userId!, DateTime.now(), 1);

    // success -> update data to DailyCouplePosts
    if(response is Success) {
      _dailyCouplePosts.first = DailyCouplePostModel.fromJson((response.response as List).first);
    }

    // failure -> put errorCode to failure
    else if(response is Failure) {
      _errorMessage = response.errorResponse;
      notifyListeners();
      loadDailyCouplePosts();
    }
  }

  // load couple posts
  Future<void> loadDailyCouplePosts() async {
    print("loadDailyCouplePosts 실행");
    // request (_nDailyCouplePosts) days' posts before last loaded day
    var response = await _dailyCouplePostRepository.getDailyCouplePosts(_userId!, DateTime.now().subtract(Duration(days: _dailyCouplePosts.length)), _nDailyCouplePosts);

    // failure -> put errorCode to failure
    if(response is Failure) {
      print("실패");
      await createTodayCouplePost();
      _errorMessage = response.errorResponse;
      notifyListeners();
    }

    // success -> put data to DailyCouplePosts
    if(response is Success) {
      List<DailyCouplePostModel> newDailyCouplePostList = [];
      print("loadDailyCouplePosts 응답");
      print(response.response);
      // temp
      if((response.response as List).isNotEmpty){
        List list = response.response as List;
        print("(response.response as List).isNotEmpty");
        //newDailyCouplePostList = dailyCouplePostListFromJson(response.response);
        for (var element in list) {
          newDailyCouplePostList.add(DailyCouplePostModel.fromJson(element));
        }
        print("dailyCouplePostListFromJson 성공");
        _dailyCouplePosts += newDailyCouplePostList;

      }
      else{
        print("createTodayCouplePost실행");
        await createTodayCouplePost();
      }
      print("newDailyCouplePostList");
      //await setPages(newDailyCouplePostList);
      // Auto refresh today's couple post
      print(_dailyCouplePosts.length.toString() + "개 있음");


      print(_dailyCouplePosts.first.questionText);
      if(_dailyCouplePosts.first.dailyPostDate.year != DateTime.now().year || _dailyCouplePosts.first.dailyPostDate.month != DateTime.now().month || _dailyCouplePosts.first.dailyPostDate.day != DateTime.now().day) {
        await createTodayCouplePost();
      }
      await setPages(newDailyCouplePostList);
    }
  }

  setLoading(bool state) {
    _loading = state;
    notifyListeners();
  }


  setDailyInfo(index) async {
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

  setPages(List<DailyCouplePostModel> newDailyCouplePosts) async {
    setLoading(true);

    print("페이지 세팅");
    //for (int index = 0; index < _dailyCouplePosts.length; index++) {
    for (DailyCouplePostModel _dailyCouplePostModel in newDailyCouplePosts) {
      // Set date data
      if(DateTime.now().year == _dailyCouplePostModel.dailyPostDate.year && DateTime.now().month == _dailyCouplePostModel.dailyPostDate.month && DateTime.now().day == _dailyCouplePostModel.dailyPostDate.day){
        _dailyCouplePostModel.isToday = true;
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
}