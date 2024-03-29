import 'package:couple_seflie_app/ui/view/screen/login/find_id_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/login/reset_pw_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register2/register_username_screen.dart';
import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:couple_seflie_app/ui/view_model/user_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../data/repository/data_repository.dart';
import '../../../view_model/daily_couple_post_view_model.dart';
import '../../../view_model/user_info_view_model.dart';
import '../../widget/text_form_field.dart';
import '../../widget/one_block_top_widget.dart';
import '../register1/register_screen.dart';
import '../register1/register_vertification_screen.dart';

bool _onPressed = false;

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
                )
                      :
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
                          SingleTextButton(
                            buttonText: "비밀번호 재설정",
                            onTap: () async {
                              if(_onPressed == false){
                                _onPressed = true;
                                FocusScope.of(context).unfocus();
                                _formKey.currentState!.reset();
                                await Provider.of<UserInfoViewModel>(context, listen: false).clearAll();
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPwScreen(),fullscreenDialog: true));
                                _onPressed = false;
                              }
                            },
                          ),
                          BorderBetweenTextButtons(),
                          SingleTextButton(
                            buttonText: "회원가입",
                            onTap: () async {
                              if(_onPressed == false){
                                _onPressed = true;
                                FocusScope.of(context).unfocus();
                                _formKey.currentState!.reset();
                                await Provider.of<UserInfoViewModel>(context, listen: false).clearAll();
                                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                                _onPressed = false;
                              }
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
                BottomLargeButtonWidget(
                    onTap: () async {
                      if(_onPressed == false){
                        _onPressed = true;
                        _formKey.currentState!.save();
                        FocusScope.of(context).unfocus();
                        await _userInfoViewModel.checkInputOk();
                        //!_userInfoViewModel.isLoginOk ?
                        _userInfoViewModel.inputOk ?
                        {
                          await _userInfoViewModel.doLogin(),

                          if(_userInfoViewModel.resultState == null){
                          //if(_userInfoViewModel.loginFailure == null){
                            await Provider.of<UserProfileViewModel>(context, listen: false).setCurrentUser(),
                            await Provider.of<DailyCouplePostViewModel>(context, listen: false).initDailyCouplePosts(),
                            await Provider.of<UserInfoViewModel>(context, listen: false).clearAll(),
                            DataRepository().sendExecutionPoint(),
                            Navigator.pushAndRemoveUntil(context, PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => PostMainScreen(),
                              transitionDuration: Duration.zero,
                            ), (route) => false),
                          }
                          else if(_userInfoViewModel.resultState == "nonVerification"){
                          //else if(_userInfoViewModel.loginFailure == "nonVerification"){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    _userInfoViewModel.resultMessage!
                                    //_userInfoViewModel.loginFailMessage!
                                ),
                              ),
                            ),
                            _formKey.currentState!.reset(),
                            await Provider.of<UserInfoViewModel>(context, listen: false).clearWithoutCredential(),
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterVertificationScreen())),
                          }
                          else if(_userInfoViewModel.resultState == "nonUserInfo") {
                          //else if(_userInfoViewModel.loginFailure == "nonUserInfo") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      _userInfoViewModel.resultMessage!
                                      //_userInfoViewModel.loginFailMessage!
                                  ),
                                ),
                              ),
                              _formKey.currentState!.reset(),
                              await Provider.of<UserInfoViewModel>(context, listen: false).clearAll(),
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => RegisterUsernameScreen()), (route) => false),
                          }
                          else if(_userInfoViewModel.resultState == "nonUser" || _userInfoViewModel.resultState == "fail") {
                          //else if(_userInfoViewModel.loginFailure == "nonUser" || _userInfoViewModel.loginFailure == "fail") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    _userInfoViewModel.resultMessage!
                                    //_userInfoViewModel.loginFailMessage!
                                ),
                              ),
                            ),
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    _userInfoViewModel.resultMessage!
                                    //_userInfoViewModel.loginFailMessage!
                                ),
                              ),
                            ),
                          }
                        }
                        :
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              //_userInfoViewModel.idErrorMessage ?? _userInfoViewModel.pwErrorMessage ?? '입력된 정보가 올바르지 않습니다'
                                _userInfoViewModel.inputErrorMessage!
                            ),
                          ),
                        );
                        _onPressed = false;
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
          splashColor: Colors.transparent,
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

