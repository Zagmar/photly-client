import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register/register_screen.dart';
import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:couple_seflie_app/ui/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../widget/text_form_field.dart';
import '../../widget/top_widgets.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  late LoginViewModel _loginViewModel;

  @override
  Widget build(BuildContext context) {
    _loginViewModel = Provider.of<LoginViewModel>(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(),
                Container(
                  padding: EdgeInsetsDirectional.fromSTEB(35.w, 20.w, 35.w, 20.w),
                  child: Column(
                    children: <Widget>[
                      OneBlockTop(
                        topText: "서로 남기는\n하루 한장\n시작해볼까요",
                        bottomText: "로그인을 진행합니다",
                      ),
                      LoginFormWidget(loginViewModel: _loginViewModel),
                    ],
                  ),
                ),
                MediaQuery.of(context).viewInsets.bottom <= 50 ?
                LargeButtonWidget(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      !_loginViewModel.isLoginOk ?
                      ScaffoldMessenger(
                        child: SnackBar(
                          content: Text(
                              _loginViewModel.idErrorMessage ?? _loginViewModel.pwErrorMessage ?? '입력된 정보가 올바르지 않습니다'
                          ),
                        ),
                      )
                          :
                      await _loginViewModel.doLogin() ?
                      {
                        _loginViewModel.clear(),
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => PostMainScreen()), (route) => false)
                      }
                          :
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              _loginViewModel.loginFailMessage!
                          ),
                        ),
                      );
                    },
                    buttonText: "로그인"
                )
                    :
                Container()
              ],
            ),
          )
      ),
    );
  }

  loginButtonFucntion(GlobalKey _scaffoldKey) async {
    print("실패1");
    FocusScope.of(_scaffoldKey.currentState!.context).unfocus();
    print("실패2");
    !_loginViewModel.isLoginOk ?
    ScaffoldMessenger(
      child: SnackBar(
        content: Text(
            _loginViewModel.idErrorMessage ?? _loginViewModel.pwErrorMessage ?? '입력된 정보가 올바르지 않습니다'
        ),
      ),
    )
        :
    await _loginViewModel.doLogin() ?
    {
      _loginViewModel.clear(),
      Navigator.pushAndRemoveUntil(_scaffoldKey.currentContext!, MaterialPageRoute(builder: (context) => PostMainScreen()), (route) => false)
    }
        :
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(
            _loginViewModel.loginFailMessage!
        ),
      ),
    );
  }

  /*
  /// login Button
  Widget loginButtonWidget() {
    return InkWell(
      onTap: () async {
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
        await _loginViewModel.doLogin() ?
        {
          _loginViewModel.clear(),
          Navigator.pushNamedAndRemoveUntil(_context, "/postMainScreen", (route) => false)
        }
            :
        ScaffoldMessenger.of(_context).showSnackBar(
          SnackBar(
            content: Text(
              _loginViewModel.loginFailMessage!
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

   */
}

class LoginFormWidget extends StatelessWidget {
  final LoginViewModel loginViewModel;
  const LoginFormWidget({Key? key, required this.loginViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              TextInputWidget(
                hintText: "아이디 입력",
                maxLines: 1,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value){
                  loginViewModel.checkEmail(value);
                },
              ),
              TextInputWidget(
                hintText: "비밀번호 입력",
                maxLines: 1,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value){
                  loginViewModel.checkPassword(value);
                },
              ),
            ],
          ),
          /// Other Functions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleTextButton(
                  buttonText: "아이디 찾기",
                  onPressed: (){
                    FocusScope.of(context).unfocus();
                    loginViewModel.clear();
                    Navigator.pushNamed(context, "/findIdScreen");
                  },
              ),
              BorderBetweenTextButtons(),
              SingleTextButton(
                  buttonText: "비밀번호 찾기",
                  onPressed: (){
                    FocusScope.of(context).unfocus();
                    loginViewModel.clear();
                    Navigator.pushNamed(context, "/findPwScreen");
                  },
              ),
              BorderBetweenTextButtons(),
              SingleTextButton(
                buttonText: "회원가입",
                onPressed: () {
                  print("회원가입 눌림");
                  FocusScope.of(context).unfocus();
                  loginViewModel.clear();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

class SingleTextButton extends StatelessWidget {
  final String buttonText;
  final GestureTapCallback onPressed;
  const SingleTextButton({Key? key, required this.buttonText, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 14.w,
            fontWeight: FontWeight.w400,
            color: Color(0xFF000000).withOpacity(0.5),
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        )
    );
  }
}

class BorderBetweenTextButtons extends StatelessWidget {
  const BorderBetweenTextButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.w,
      height: 17.w,
      color: Color(0xFF808080),
    );
  }
}

