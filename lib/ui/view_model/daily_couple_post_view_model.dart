
import 'package:couple_seflie_app/data/model/daily_couple_post_model.dart';
import 'package:couple_seflie_app/data/repository/daily_couple_post_repository.dart';
import 'package:couple_seflie_app/ui/view_model/post_view_model.dart';
import 'package:flutter/material.dart';

import '../../data/datasource/remote_datasource.dart';

class DailyCouplePostViewModel extends ChangeNotifier {
  bool _loading = true;
  String? _errorMessage;
  late String _screen;

  final DailyCouplePostRepository _dailyCouplePostRepository = DailyCouplePostRepository();
  final int _nDailyCouplePosts = 5;

  String userId = "rjsgy0815@naver.com"; // temp
  List<DailyCouplePostModel> _dailyCouplePosts = [];

  late String _year;
  late String _month;
  late String _day;
  late int _questionType;
  late String _questionText;
  late bool _isToday;
  late bool _isMyPost;

  String? _userPostId;
  String? _userPostImageUrl;
  String? _partnerPostId;
  String? _partnerPostImageUrl;
  String? _questionImageUrl;
  List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  List<DailyCouplePostModel> get dailyCouplePosts => _dailyCouplePosts;
  bool get loading => _loading;

  String get screen => _screen;
  String get year => _year;
  String get month => _month;
  String get day => _day;
  int get questionType => _questionType;
  String get questionText => _questionText;
  String? get questionImageUrl => _questionImageUrl;
  bool get isToday => _isToday;
  bool get isMyPost => _isMyPost;

  String? get userPostId => _userPostId;
  String? get userPostImageUrl => _userPostImageUrl;
  String? get partnerPostId => _partnerPostId;
  String? get partnerPostImageUrl => _partnerPostImageUrl;

  // set default of mainScreen
  DailyCouplePostViewModel() {
    if(_dailyCouplePosts.isEmpty){
      // set mainScreen to default
      loadDailyCouplePosts();
    }
  }

  // Whether the process is in progress
  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  // create today's couple post
  // temp
  // auto
  createTodayCouplePost() async {
    // request (_nDailyCouplePosts) days' posts before last loaded day
    var response = await _dailyCouplePostRepository.createDailyCouplePost(userId);

    // failure -> put errorCode to failure
    if(response is Failure) {
      print("합치기 실패");
      _errorMessage = response.errorResponse;
      notifyListeners();
    }

    // success -> add new data to DailyCouplePosts & load
    if(response is Success) {
      print(response.response);
      print("합치기 성공");
      _dailyCouplePosts = dailyCouplePostListFromJson(response.response) + _dailyCouplePosts;
      notifyListeners();
    }
  }

  // refresh today's couple post
  refreshTodayCouplePost() async {

    // call API
    var response =  await _dailyCouplePostRepository.getDailyCouplePosts(userId, DateTime.now(), 1);

    // success -> update data to DailyCouplePosts
    if(response is Success) {
      _dailyCouplePosts.first = dailyCouplePostListFromJson(response.response).first;
    }

    // failure -> put errorCode to failure
    else if(response is Failure) {
      _errorMessage = response.errorResponse;
      notifyListeners();
      loadDailyCouplePosts();
    }
  }

  // load couple posts
  loadDailyCouplePosts() async {
    // loading...start
    setLoading(true);
    // request (_nDailyCouplePosts) days' posts before last loaded day
    var response =  await _dailyCouplePostRepository.getDailyCouplePosts(userId, DateTime.now().subtract(Duration(days: _dailyCouplePosts.length)), _nDailyCouplePosts);

    // failure -> put errorCode to failure
    if(response is Failure) {
      _errorMessage = response.errorResponse;
      notifyListeners();
    }

    // success -> put data to DailyCouplePosts
    if(response is Success) {
      print(response.response);
      // temp
      // Auto refresh today's couple post
      _dailyCouplePosts += dailyCouplePostListFromJson(response.response);
      notifyListeners();

      print(_dailyCouplePosts.first.questionText);
      print(_dailyCouplePosts.last.questionText);
      if(_dailyCouplePosts.first.dailyPostDate.year != DateTime.now().year || _dailyCouplePosts.first.dailyPostDate.month != DateTime.now().month || _dailyCouplePosts.first.dailyPostDate.day != DateTime.now().day) {
        await createTodayCouplePost();
      }
      // setDailyCouplePosts(dailyCouplePostListFromJson(response.response));
      setPage(0);
    }

    // loading...end
    setLoading(false);
  }


  setIsMeUploaded(int index){
    if(_dailyCouplePosts[index].userPostId != null){
      _isMyPost = true;
    }
    else{
      _isMyPost = false;
    }
    notifyListeners();
  }

  setDate(int index) {
    DateTime dateTime = _dailyCouplePosts[index].dailyPostDate;

    if(DateTime.now().year == dateTime.year && DateTime.now().month == dateTime.month && DateTime.now().day == dateTime.day){
      _isToday = true;
      print("변경");
    }
    else{
      _isToday = false;
    }

    _year = dateTime.year.toString();
    _month = months[dateTime.month - 1];
    _day = dateTime.day.toString();
    notifyListeners();
  }

  setQuestion(int index){
    _questionType = _dailyCouplePosts[index].questionType;
    _questionText = _dailyCouplePosts[index].questionText;
    _questionImageUrl = _dailyCouplePosts[index].questionImageUrl;
    notifyListeners();
  }

  setPosts(int index){
    _userPostId = _dailyCouplePosts[index].userPostId;
    _userPostImageUrl = _dailyCouplePosts[index].userPostImageUrl;
    _partnerPostId = _dailyCouplePosts[index].partnerPostId;
    _partnerPostImageUrl = _dailyCouplePosts[index].partnerPostImageUrl;
    notifyListeners();
  }

  setPage(int index) {
    setDate(index);
    setIsMeUploaded(index);
    setQuestion(index);
    setPosts(index);
    setPosts(index);
  }

  setPost() async {
    await PostViewModel().getPost(_userPostId!);
    print("송신");
    //PostDailyInfoWidgetViewModel().setPostId(_userPostId!);
  }

  setScreenToMain(){
    _screen = "/dailyCouplePostScreen";
    notifyListeners();
  }

  setScreenToDetail(){
    _screen = "/postDetailScreen";
    notifyListeners();
  }

  setScreenToEdit(){
    _screen = "/postEditScreen";
    notifyListeners();
  }
}