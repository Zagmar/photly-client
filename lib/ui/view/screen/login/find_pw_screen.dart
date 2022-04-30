import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../view_model/login_view_model.dart';

class FindPwScreen extends StatelessWidget {
  FindPwScreen({Key? key}) : super(key: key);
  late LoginViewModel _loginViewModel;
  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _loginViewModel = Provider.of<LoginViewModel>(_context);
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: findIdScreen(),
    );
  }

  Widget findIdScreen() {
    return SafeArea(
        child: Scaffold(
          body: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(),
                Text(
                    "관리자 문의 요망"
                ),
                routeButtonWidget()
              ],
            ),
          ),
        )
    );
  }

  /// route Button
  Widget routeButtonWidget() {
    return Container(
      width: 390.w,
      height: 60.w,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.fromSTEB(25.w, 0, 25.w, 20.w),
      child: InkWell(
        onTap: (){
          FocusScope.of(_context).unfocus();
          Navigator.pop(_context);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28.w),
              border: Border.all(
                width: 2.w,
                color: Color(0xFF050505),
              )
          ),
          width: 90.w,
          height: 48.w,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 10.w),
          child: Container(
            width: 60.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.chevron_left_outlined, size: 30.w, color: Color(0xFF050505),),
                Text(
                  "이전",
                  style: TextStyle(
                      fontSize: 16.w,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF050505)
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

