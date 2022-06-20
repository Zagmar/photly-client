import 'package:couple_seflie_app/ui/view/screen/login/find_id_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/login/reset_pw_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register2/register_username_screen.dart';
import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:couple_seflie_app/ui/view_model/user_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../view_model/daily_couple_post_view_model.dart';
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
                Container(
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
                            hintText: "이메일 입력",
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
                          /*
                          SingleTextButton(
                            buttonText: "아이디 찾기",
                            onTap: (){
                              FocusScope.of(context).unfocus();
                              _formKey.currentState!.reset();
                              _userInfoViewModel.clear();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => FindIdScreen()));
                            },
                          ),
                          BorderBetweenTextButtons(),

                           */
                          SingleTextButton(
                            buttonText: "비밀번호 재설정",
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              _formKey.currentState!.reset();
                              await _userInfoViewModel.clear();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPwScreen()));
                            },
                          ),
                          BorderBetweenTextButtons(),
                          SingleTextButton(
                            buttonText: "회원가입",
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              _formKey.currentState!.reset();
                              await _userInfoViewModel.clear();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
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
                      await _userInfoViewModel.doLogin();

                      switch (_userInfoViewModel.loginFailure) {
                        case null :
                          await Provider.of<UserProfileViewModel>(context, listen: false).setCurrentUser();
                          await Provider.of<DailyCouplePostViewModel>(context, listen: false).initDailyCouplePosts();
                          await Provider.of<UserInfoViewModel>(context, listen: false).clear();
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => PostMainScreen()), (route) => false);
                          break;
                        case "nonVerification" :
                          //_userInfoViewModel.clearSecret();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  _userInfoViewModel.loginFailMessage!
                              ),
                            ),
                          );
                          _formKey.currentState!.reset();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterVertificationScreen()));
                          break;
                        case "nonUserInfo" :
                          //_userInfoViewModel.clearSecret();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  _userInfoViewModel.loginFailMessage!
                              ),
                            ),
                          );
                          _formKey.currentState!.reset();
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => RegisterUsernameScreen()), (route) => false);
                          break;
                        case "nonUser" :
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  _userInfoViewModel.loginFailMessage!
                              ),
                            ),
                          );
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
                        default :
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "로그인에 실패하였습니다.\n다시 시도해주세요"
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

