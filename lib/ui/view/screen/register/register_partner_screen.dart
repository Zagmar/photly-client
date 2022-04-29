import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../view_model/register_view_model.dart';

class RegisterPartnerScreen extends StatelessWidget {
  RegisterPartnerScreen({Key? key}) : super(key: key);
  late RegisterViewModel _registerViewModel;
  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _registerViewModel = Provider.of<RegisterViewModel>(context);
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: registerScreen(),
    );

  }

  Widget registerScreen() {
    return SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsetsDirectional.fromSTEB(35, 20, 35, 20),
              child: Column(
                children: <Widget>[
                  topWidget(),
                  registerWidget(),
                ],
              ),
            ),
            routeButtonWidget()
          ],
        )
    );
  }

  /// route Button
  Widget routeButtonWidget() {
    return Container(
      width: 390.w,
      height: 60.w,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
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
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.chevron_left_outlined, size: 16.w, color: Color(0xFF050505),),
                  Padding(padding: EdgeInsets.only(right: 10.w)),
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
          InkWell(
            onTap: (){
              FocusScope.of(_context).unfocus();
              _registerViewModel.isRegisterOk ?
              Navigator.pushNamed(_context, '/registerBirthdayScreen')
                  :
              ScaffoldMessenger.of(_context).showSnackBar(
                SnackBar(
                  content: Text('올바른 닉네임을 입력해주세요'),
                ),
              );
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
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "다음",
                    style: TextStyle(
                        fontSize: 16.w,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF050505)
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(padding: EdgeInsets.only(right: 10.w)),
                  Icon(Icons.chevron_right_outlined, size: 16.w, color: Color(0xFF050505),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// page Info
  Widget topWidget() {
    return Container(
      width: 320.w,
      height: 150.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "서로 불러줄\n닉네임을\n정해주세요",
            style: TextStyle(
                fontSize: 28.w,
                fontWeight: FontWeight.w700,
                color: Color(0xFF000000)
            ),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "나중에 수정이 가능해요!",
            style: TextStyle(
                fontSize: 16.w,
                fontWeight: FontWeight.w400,
                color: Color(0xFF000000).withOpacity(0.5)
            ),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget registerWidget() {
    return Container(
      width: 320.w,
      height: 150.w,
      alignment: Alignment.center,
      child: TextFormField(
        initialValue: _registerViewModel.username,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: "서로 부르는 애칭, 별명 다 좋아요!",
          hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.w,
              color: Color(0xFFC4C4C4)
          ),
          labelText: "닉네임",
          labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.w,
              color: Color(0xFF808080)
          ),
        ),
        maxLines: 1,
        maxLength: 6,
        keyboardType: TextInputType.text,
        onFieldSubmitted: (_){
          FocusScope.of(_context).unfocus();
        },
        obscureText: false,
        validator: (_) {
          if(_registerViewModel.usernameErrorMessage != null) {
            return _registerViewModel.usernameErrorMessage;
          }
        },
        onChanged: (value){
          _registerViewModel.checkUsername(value);
        },
      ),
    );
  }
}

