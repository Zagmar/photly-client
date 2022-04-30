import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../view_model/register_view_model.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  late RegisterViewModel _registerViewModel;
  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _registerViewModel = Provider.of<RegisterViewModel>(_context);
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: registerScreen(),
    );

  }

  Widget registerScreen() {
    return SafeArea(
        child: GestureDetector(
          onTap: (){
            FocusScope.of(_context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Theme.of(_context).scaffoldBackgroundColor,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(),
                Container(
                  padding: EdgeInsetsDirectional.fromSTEB(35.w, 20.w, 35.w, 20.w),
                  child: Column(
                    children: <Widget>[
                      topWidget(),
                      Padding(padding: EdgeInsets.symmetric(vertical: 20.w)),
                      registerWidget(),
                    ],
                  ),
                ),
                MediaQuery.of(_context).viewInsets.bottom <= 50 ?
                registerButtonWidget()
                    :
                Container()
              ],
            ),
          ),
        )
    );
  }
  /// register Button
  Widget registerButtonWidget() {
    return InkWell(
      onTap: (){
        FocusScope.of(_context).unfocus();
        _registerViewModel.isRegisterOk ?
        Navigator.pushNamed(_context, '/registerUsernameScreen')
            :
        ScaffoldMessenger.of(_context).showSnackBar(
          SnackBar(
            content: Text(
                _registerViewModel.idErrorMessage ?? _registerViewModel.pwErrorMessage ?? _registerViewModel.pwCheckErrorMessage ?? '입력된 정보가 올바르지 않습니다'
            ),
          ),
        );
      },
      child: Container(
        width: 390.w,
        height: 60.w,
        color: Color(0xFF050505),
        alignment: Alignment.center,
        child: Text(
          "회원가입",
          style: TextStyle(
              fontSize: 16.w,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE5E5E5)
          ),
          textAlign: TextAlign.center,
        ),
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
            "서로 남기는\n하루 한장\n시작해볼까요",
            style: TextStyle(
                fontSize: 28.w,
                fontWeight: FontWeight.w700,
                color: Color(0xFF000000)
            ),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "회원가입을 진행합니다",
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
      height: 180.w,
      alignment: Alignment.center,
      /// Register Textfield
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            initialValue: _registerViewModel.email,
            decoration: InputDecoration(
                hintText: "아이디 입력",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.w,
                    color: Color(0xFFC4C4C4)
                )
            ),
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            onFieldSubmitted: (_){
              FocusScope.of(_context).unfocus();
            },
            obscureText: false,
            validator: (_) {
              if(_registerViewModel.idErrorMessage != null) {
                return _registerViewModel.idErrorMessage;
              }
            },
            onChanged: (value){
              _registerViewModel.checkEmail(value);
            },
          ),
          TextFormField(
            decoration: InputDecoration(
                hintText: "비밀번호 입력",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.w,
                    color: Color(0xFFC4C4C4)
                )
            ),
            maxLines: 1,
            keyboardType: TextInputType.visiblePassword,
            onFieldSubmitted: (_){
              FocusScope.of(_context).unfocus();
            },
            obscureText: true,
            validator: (_) {
              if(_registerViewModel.pwErrorMessage != null) {
                return _registerViewModel.pwErrorMessage;
              }
            },
            onChanged: (value){
              _registerViewModel.checkPassword(value);
            },
          ),
          TextFormField(
            decoration: InputDecoration(
                hintText: "비밀번호 확인",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.w,
                    color: Color(0xFFC4C4C4)
                )
            ),
            maxLines: 1,
            keyboardType: TextInputType.visiblePassword,
            onFieldSubmitted: (_){
              FocusScope.of(_context).unfocus();
            },
            obscureText: true,
            validator: (_) {
              if(_registerViewModel.pwCheckErrorMessage != null) {
                return _registerViewModel.pwCheckErrorMessage;
              }
            },
            onChanged: (value){
              _registerViewModel.checkPasswordCheck(value);
            },
          ),
        ],
      ),
    );
  }
}

