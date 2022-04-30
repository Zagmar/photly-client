import 'package:couple_seflie_app/ui/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  late LoginViewModel _loginViewModel;
  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _loginViewModel = Provider.of<LoginViewModel>(_context);
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: loginScreen(),
    );
  }

  Widget loginScreen() {
    return SafeArea(
      child: GestureDetector(
        onTap: (){
          FocusScope.of(_context).unfocus();
        },
        child: Scaffold(
            backgroundColor: Theme.of(_context).scaffoldBackgroundColor,
            resizeToAvoidBottomInset : false,
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
                      loginWidget(),
                    ],
                  ),
                ),
                MediaQuery.of(_context).viewInsets.bottom <= 50 ?
                loginButtonWidget()
                    :
                Container()
              ],
            )
        ),
      ),
    );
  }
  /// login Button
  Widget loginButtonWidget() {
    return InkWell(
      onTap: (){
        FocusScope.of(_context).unfocus();
        !_loginViewModel.isLoginOk ?
        ScaffoldMessenger.of(_context).showSnackBar(
          SnackBar(
            content: Text(
              _loginViewModel.idErrorMessage ?? _loginViewModel.pwErrorMessage ?? '입력된 정보가 올바르지 않습니다'
            ),
          ),
        )
            :
        _loginViewModel.doLogin() ?
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
      height: 200.w,
      alignment: Alignment.center,
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
                  if(_loginViewModel.idErrorMessage != null) {
                    return _loginViewModel.idErrorMessage;
                  }
                },
                onChanged: (value){
                  _loginViewModel.checkEmail(value);
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
                  if(_loginViewModel.pwErrorMessage != null) {
                    return _loginViewModel.pwErrorMessage;
                  }
                },
                onChanged: (value){
                  _loginViewModel.checkPassword(value);
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
                    FocusScope.of(_context).unfocus();
                    Navigator.pushNamed(_context, "/findIdScreen");
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
              Container(
                width: 1.w,
                height: 17.w,
                color: Color(0xFF808080),
              ),
              TextButton(
                  onPressed: (){
                    FocusScope.of(_context).unfocus();
                    Navigator.pushNamed(_context, "/findPwScreen");
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
              Container(
                width: 1.w,
                height: 17.w,
                color: Color(0xFF808080),
              ),
              TextButton(
                  onPressed: (){
                    FocusScope.of(_context).unfocus();
                    Navigator.pushNamed(_context, "/registerScreen");
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

