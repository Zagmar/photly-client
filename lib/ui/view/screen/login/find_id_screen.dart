import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_model/login_view_model.dart';

class FindIdScreen extends StatelessWidget {
  FindIdScreen({Key? key}) : super(key: key);
  late LoginViewModel _loginViewModel;
  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _loginViewModel = Provider.of<LoginViewModel>(context);
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: findIdScreen(),
    );
  }

  Widget findIdScreen() {
    return SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            "관리자 문의 요망"
          ),
        )
    );
  }
}
