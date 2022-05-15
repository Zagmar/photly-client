import 'package:couple_seflie_app/data/model/daily_couple_post_model.dart';
import 'package:flutter/material.dart';

class PostDailyInfoViewModel extends ChangeNotifier {
  late String _year;
  late String _month;
  late String _day;
  late int _questionType;
  late String _questionText;
  String? _questionImageUrl;

  String get year => _year;
  String get month => _month;
  String get day => _day;
  int get questionType => _questionType;
  String get questionText => _questionText;
  String? get questionImageUrl => _questionImageUrl;

  List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  setDailyInfo(DailyCouplePostModel dailyCouplePostModel) async {
    DateTime dateTime = dailyCouplePostModel.dailyPostDate;

    _year = dateTime.year.toString();
    _month = months[dateTime.month - 1];
    _day = dateTime.day.toString();

    // Set question data
    _questionType = dailyCouplePostModel.questionType;
    _questionText = dailyCouplePostModel.questionText;
    _questionImageUrl = dailyCouplePostModel.questionImageUrl;

    notifyListeners();
  }
}