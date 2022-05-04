
import 'package:couple_seflie_app/data/model/daily_couple_post_model.dart';
import 'package:couple_seflie_app/data/repository/daily_couple_post_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/datasource/remote_datasource.dart';

class DailyCouplePostViewModel extends ChangeNotifier {
  bool _loading = true;
  late Failure _failure;
  final DailyCouplePostRepository _dailyCouplePostRepository = DailyCouplePostRepository();
  final int _nDailyCouplePosts = 5;

  String userId = "rjsgy0815@naver.com"; // temp
  List<DailyCouplePostModel> _dailyCouplePosts = [];

  List<DailyCouplePostModel> get dailyCouplePosts => _dailyCouplePosts;
  Failure get failure => _failure;
  bool get loading => _loading;

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
    // loading...start
    setLoading(true);

    // request (_nDailyCouplePosts) days' posts before last loaded day
    var response = await _dailyCouplePostRepository.createDailyCouplePost(userId);

    // failure -> put errorCode to failure
    if(response is Failure) {
      setFailure(response);
    }

    // success -> add new data to DailyCouplePosts & load
    if(response is Success) {
      loadDailyCouplePosts();
    }

    // loading...end
    setLoading(false);
  }

  // refresh today's couple post
  refreshTodayCouplePost() async {
    // loading...start
    setLoading(true);

    // call API
    var response =  await _dailyCouplePostRepository.getDailyCouplePosts(userId, DateFormat('yyyyMMdd').format(DateTime.now()).toString(), 1);

    // success -> update data to DailyCouplePosts
    if(response is Success) {
      _dailyCouplePosts.first = dailyCouplePostListFromJson(response.response).first;
    }

    // failure -> put errorCode to failure
    else if(response is Failure) {
      setFailure(response);
      loadDailyCouplePosts();
    }

    // loading...end
    setLoading(false);
  }

  // load couple posts
  loadDailyCouplePosts() async {
    // loading...start
    setLoading(true);

    // request (_nDailyCouplePosts) days' posts before last loaded day
    var response =  await _dailyCouplePostRepository.getDailyCouplePosts(userId, DateFormat('yyyyMMdd').format(DateTime.now().subtract(Duration(days: _dailyCouplePosts.length))).toString(), _nDailyCouplePosts);

    // failure -> put errorCode to failure
    if(response is Failure) {
      setFailure(response);
    }

    // success -> put data to DailyCouplePosts
    if(response is Success) {
      // temp
      // Auto refresh today's couple post
      if(dailyCouplePostListFromJson(response.response).first.dailyPostDate != DateFormat('yyyyMMdd').format(DateTime.now()).toString()) {
        createTodayCouplePost();
      }
      setDailyCouplePosts(dailyCouplePostListFromJson(response.response));
    }



    // loading...end
    setLoading(false);
  }

  // add couple posts into list
  setDailyCouplePosts(List<DailyCouplePostModel> dailCouplePosts) {
    _dailyCouplePosts += dailCouplePosts;
    notifyListeners();
  }

  // when error observed in process
  setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }
}