import 'package:couple_seflie_app/ui/view/screen/login/find_id_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/login/find_pw_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register2/register_username_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register3/register_couple_code_screen.dart';
import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:couple_seflie_app/ui/view_model/user_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../view_model/daily_couple_post_view_model.dart';
import '../../../view_model/register3_view_model.dart';
import '../../../view_model/user_info_view_model.dart';
import '../../widget/text_form_field.dart';
import '../../widget/one_block_top_widget.dart';
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
                MediaQuery.of(context).viewInsets.bottom <= 30.w ?
                OneBlockTopWidget(
                  topText: "서로 남기는\n하루 한장\n시작해볼까요?",
                  bottomText: "로그인을 진행합니다",
                ):
                OneBlockTopWidgetKeyboardOn(
                    text: "로그인 정보를 입력중입니다"
                ),
                LoginFormWidget(),
                BottomLargeButtonWidget(
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
                          await Provider.of<UserProfileViewModel>(context, listen: false).setCurrentUser();
                          final _dailyCouplePostViewModel = Provider.of<DailyCouplePostViewModel>(context, listen: false);
                          await _dailyCouplePostViewModel.initDailyCouplePosts();
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => PostMainScreen()), (route) => false);
                          /*
                          _dailyCouplePostViewModel.isCouple ?
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => PostMainScreen()), (route) => false)
                              :
                          {
                            await Provider.of<Register3ViewModel>(context, listen: false).setUserCoupleCode(),
                            Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) => PostMainScreen(), fullscreenDialog: true), (route) => false, ),
                          };

                           */
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
              ],
            ),
          )
      ),
    );
  }
}

class LoginFormWidget extends StatelessWidget {
  late UserInfoViewModel _userInfoViewModel;
  LoginFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _userInfoViewModel = Provider.of<UserInfoViewModel>(context);
    return Container(
      width: 375.w,
      height: 140.w,
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
                  await _userInfoViewModel.checkEmail(value??"");
                },
              ),
              TextInputWidget(
                hintText: "비밀번호 입력",
                maxLines: 1,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                onSaved: (value) async {
                  await _userInfoViewModel.checkPassword(value??"");
                },
              ),
            ],
          ),
          /// Other Functions
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleTextButton(
                  buttonText: "아이디 찾기",
                  onTap: (){
                    FocusScope.of(context).unfocus();
                    _userInfoViewModel.clear();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FindIdScreen()));
                  },
              ),
              BorderBetweenTextButtons(),
              SingleTextButton(
                  buttonText: "비밀번호 찾기",
                  onTap: (){
                    FocusScope.of(context).unfocus();
                    _userInfoViewModel.clear();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FindPwScreen()));
                  },
              ),
              BorderBetweenTextButtons(),
              SingleTextButton(
                buttonText: "회원가입",
                onTap: () {
                  FocusScope.of(context).unfocus();
                  _userInfoViewModel.clear();
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
  final GestureTapCallback onTap;
  const SingleTextButton({Key? key, required this.buttonText, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.w,
      alignment: Alignment.center,
      child: InkWell(
          onTap: onTap,
          child: Text(
            buttonText,
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          )
      ),
    );
  }
}

class BorderBetweenTextButtons extends StatelessWidget {
  const BorderBetweenTextButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.w,
      height: 20.w,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      color: Color(0xFF808080),
    );
  }
}

