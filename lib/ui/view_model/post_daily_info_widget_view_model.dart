import 'package:flutter/material.dart';

class PostDailyInfoWidgetViewModel extends ChangeNotifier {
  late String _screen;
  late String _year;
  late String _month;
  late String _day;
  late int _questionType;
  late String _questionText;
  late bool _isToday;
  late bool _isMyPost;
  String? _questionImageUrl;
  List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  String get screen => _screen;
  String get year => _year;
  String get month => _month;
  String get day => _day;
  int get questionType => _questionType;
  String get questionText => _questionText;
  String? get questionImageUrl => _questionImageUrl;
  bool get isToday => _isToday;
  bool get isMyPost => _isMyPost;


  setScreen(String screen){
    _screen = screen;
    notifyListeners();
  }

  setIsMeUploaded(bool isMyPost){
    _isMyPost = isMyPost;
    notifyListeners();
  }

  setDate(DateTime dateTime) {
    if(DateTime.now().year == dateTime.year && DateTime.now().month == dateTime.month && DateTime.now().day == dateTime.day){
      _isToday = true;
    };
    _year = dateTime.year.toString();
    _month = months[dateTime.month - 1];
    _day = dateTime.day.toString();
    notifyListeners();
  }

  setQuestion(int questionType, String questionText, String? questionImageUrl){
    _questionType = questionType;
    _questionText = questionText;
    _questionImageUrl = questionImageUrl;
    notifyListeners();
  }
}