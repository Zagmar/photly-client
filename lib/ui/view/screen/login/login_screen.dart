import 'package:couple_seflie_app/ui/view_model/user_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  late UserInfoViewModel _userInfoViewModel;
  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _userInfoViewModel = Provider.of<UserInfoViewModel>(context);
    return ChangeNotifierProvider(
      create: (_) => UserInfoViewModel(),
      child: loginScreen(),
    );

  }

  Widget loginScreen() {
    return SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsetsDirectional.fromSTEB(35, 20, 35, 20),
              child: Column(
                children: <Widget>[
                  topWidget(),
                  loginWidget(),
                ],
              ),
            ),
            loginButtonWidget()
          ],
        )
    );
  }
  /// login Button
  Widget loginButtonWidget() {
    return InkWell(
      onTap: (){
        _userInfoViewModel.isLoginOk ?
        ScaffoldMessenger.of(_context).showSnackBar(
          SnackBar(
            content: Text('입력된 정보가 올바르지 않습니다'),
          ),
        )
            :
        _userInfoViewModel.doLogin() ?
        Navigator.pushNamedAndRemoveUntil(_context, "/mainScreen", (route) => false)
            :
        ScaffoldMessenger.of(_context).showSnackBar(
          SnackBar(
            content: Text('로그인에 실패했습니다.'),
          ),
        );
      },
      child: Container(
        width: 390.w,
        height: 60.w,
        color: Color(0xFF050505),
        alignment: Alignment.center,
        child: Text(
          "로그인",
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
            "로그인을 진행합니다",
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

  Widget loginWidget() {
    return Container(
      width: 320.w,
      height: 150.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /// Login Textfield
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "아이디 입력",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.w,
                        color: Color(0xFFC4C4C4)
                    )
                ),
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(_context).offset;
                },
                obscureText: false,
                validator: (_) {
                  if(_userInfoViewModel.idErrorMessage != null) {
                    return _userInfoViewModel.idErrorMessage;
                  }
                },
                onChanged: (value){
                  _userInfoViewModel.checkEmail(value);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "비밀번호 입력",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.w,
                        color: Color(0xFFC4C4C4)
                    )
                ),
                maxLines: 1,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_){
                  FocusScope.of(_context).offset;
                },
                obscureText: true,
                validator: (_) {
                  if(_userInfoViewModel.idErrorMessage != null) {
                    return _userInfoViewModel.idErrorMessage;
                  }
                },
                onChanged: (value){
                  _userInfoViewModel.checkPassword(value);
                },
              ),
            ],
          ),
          /// Other Functions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: (){
                    // temp
                    // id 찾기
                  },
                  child: Text(
                    "아이디 찾기",
                    style: TextStyle(
                      fontSize: 14.w,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF000000).withOpacity(0.5),
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  )
              ),
              Divider(),
              TextButton(
                  onPressed: (){
                    // temp
                    // 비밀번호 찾기
                  },
                  child: Text(
                    "비밀번호 찾기",
                    style: TextStyle(
                      fontSize: 14.w,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF000000).withOpacity(0.5),
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  )
              ),
              Divider(),
              TextButton(
                  onPressed: (){
                    // temp
                    // 회원가입
                  },
                  child: Text(
                    "회원가입",
                    style: TextStyle(
                      fontSize: 14.w,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF000000).withOpacity(0.5),
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  )
              ),
            ],
          )
        ],
      ),
    );
  }
}

