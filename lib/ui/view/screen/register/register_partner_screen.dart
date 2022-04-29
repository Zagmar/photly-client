import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              _registerViewModel.doRegistration() ?
              Navigator.pushNamedAndRemoveUntil(_context, "/mainScreen", (route) => false)
                  :
              ScaffoldMessenger.of(_context).showSnackBar(
                SnackBar(
                  content: Text('다시 시도해주세요'),
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
              child: Text(
                "완료",
                style: TextStyle(
                    fontSize: 16.w,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF050505)
                ),
                textAlign: TextAlign.center,
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
            "이제\n서로를\n연결해봐요",
            style: TextStyle(
                fontSize: 28.w,
                fontWeight: FontWeight.w700,
                color: Color(0xFF000000)
            ),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "초대링크를 함께하고 싶은 사람에게",
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
      height: 160.w,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              labelText: "상대방 코드 입력하기",
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.w,
                  color: Color(0xFF808080)
              ),
            ),
            // temp
            // code 길이 설정
            maxLines: 1,
            maxLength: 7,
            keyboardType: TextInputType.text,
            onFieldSubmitted: (_){
              FocusScope.of(_context).unfocus();
            },
            obscureText: false,
            validator: (_) {
              if(_registerViewModel.codeErrorMessage != null) {
                return _registerViewModel.codeErrorMessage;
              }
            },
            onChanged: (value){
              _registerViewModel.checkCode(value);
            },
          ),
          Padding(padding: EdgeInsets.only(bottom: 10.w)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: <Widget>[
              Container(
                width: 255.w,
                height: 20.w,
                child: Text(
                    _registerViewModel.userCode,
                  style: TextStyle(
                    fontSize: 16.w,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFD3D3D3),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  FocusScope.of(_context).unfocus();
                  Clipboard.setData(ClipboardData(text: _registerViewModel.userCode));
                },
                child: Container(
                  width: 45.w,
                  height: 15.w,
                  child: Text(
                      "복사하기",
                    style: TextStyle(
                      fontSize: 11.w,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF808080),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF808080),
                    ),
                  ),
                ),
              ),
              Divider()
            ],
          )
        ],
      ),
    );
  }
}

