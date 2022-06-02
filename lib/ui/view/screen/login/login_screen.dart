import 'package:couple_seflie_app/ui/view/screen/login/find_id_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/login/find_pw_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register2/register_username_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register3/register_couple_code_screen.dart';
import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../view_model/daily_couple_post_view_model.dart';
import '../../../view_model/user_info_view_model.dart';
import '../../widget/text_form_field.dart';
import '../../widget/top_widgets.dart';
import '../register1/register_screen.dart';
import '../register1/register_vertification_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  late UserInfoViewModel _userInfoViewModel;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _userInfoViewModel = Provider.of<UserInfoViewModel>(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Form(
            key: _formKey,
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
                      LoginFormWidget(userInfoViewModel: _userInfoViewModel),
                    ],
                  ),
                ),
                MediaQuery.of(context).viewInsets.bottom <= 50 ?
                LargeButtonWidget(
                    onTap: () async {
                      _formKey.currentState!.save();
                      FocusScope.of(context).unfocus();
                      !_userInfoViewModel.isLoginOk ?
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              _userInfoViewModel.idErrorMessage ?? _userInfoViewModel.pwErrorMessage ?? '입력된 정보가 올바르지 않습니다'
                          ),
                        ),
                      )
                          :
                      {
                        await _userInfoViewModel.doLogout(),
                        await _userInfoViewModel.doLogin(),
                      };

                      switch (_userInfoViewModel.loginFail) {
                        case null :
                          break;
                        case "success" :
                          final _dailyCouplePostViewModel = Provider.of<DailyCouplePostViewModel>(context, listen: false);
                          await _dailyCouplePostViewModel.initDailyCouplePosts();
                          _dailyCouplePostViewModel.isCouple ?
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => PostMainScreen()), (route) => false)
                              :
                          Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) => RegisterCoupleCodeScreen(), fullscreenDialog: true), (route) => false, );
                          break;
                        case "nonVerification" :
                          _userInfoViewModel.clearSecret();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterVertificationScreen()));
                          break;
                        case "nonUserInfo" :
                          _userInfoViewModel.clearSecret();
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => RegisterUsernameScreen()), (route) => false);
                          break;
                        case "fail" :
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  _userInfoViewModel.loginFailMessage!
                              ),
                            ),
                          );
                          break;
                      }
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
}

class LoginFormWidget extends StatelessWidget {
  final UserInfoViewModel userInfoViewModel;
  LoginFormWidget({Key? key, required this.userInfoViewModel}) : super(key: key);

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
                onSaved: (value) async {
                  await userInfoViewModel.checkEmail(value??"");
                },
              ),
              TextInputWidget(
                hintText: "비밀번호 입력",
                maxLines: 1,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                onSaved: (value) async {
                  await userInfoViewModel.checkPassword(value??"");
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
                    userInfoViewModel.clear();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FindIdScreen()));
                  },
              ),
              BorderBetweenTextButtons(),
              SingleTextButton(
                  buttonText: "비밀번호 찾기",
                  onPressed: (){
                    FocusScope.of(context).unfocus();
                    userInfoViewModel.clear();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FindPwScreen()));
                  },
              ),
              BorderBetweenTextButtons(),
              SingleTextButton(
                buttonText: "회원가입",
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  userInfoViewModel.clear();
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

