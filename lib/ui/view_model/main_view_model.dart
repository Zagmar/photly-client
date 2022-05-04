import 'package:flutter/material.dart';

import '../../data/repository/auth_service.dart';

class MainViewModel with ChangeNotifier {
  String _initialRoute = "/loginScreen";

  String get initialRoute => _initialRoute;

  setInitialRoute(AuthFlowStatus authFlowStatus) {
    if(authFlowStatus != AuthFlowStatus.session) {
      _initialRoute = "/mainScreen";
    }
    else{
      _initialRoute = "/loginScreen";
    }
    print(_initialRoute);
    notifyListeners();
  }
}