import 'package:couple_seflie_app/ui/view/screen/login/login_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register2/register_username_screen.dart';
import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:couple_seflie_app/ui/view_model/user_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../view_model/daily_couple_post_view_model.dart';
import '../../../view_model/user_profile_view_model.dart';
import '../../widget/text_form_field.dart';
import '../../widget/one_block_top_widget.dart';
import '../post/post_main_screen.dart';

bool _onPressed = false;

class RegisterVertificationScreen extends StatelessWidget {
  RegisterVertificationScreen({Key? key}) : super(key: key);
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
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: Container(),
          actions: <Widget>[
            InkWell(
              splashColor: Colors.transparent,
              onTap: () async {
                if(_onPressed == false) {
                  _onPressed = true;
                  FocusScope.of(context).unfocus();
                  await Provider.of<UserInfoViewModel>(context, listen: false).clearAll();
                  Navigator.popUntil(context, (route) => route.isFirst);
                  _onPressed = false;
                }
              },
              child: SizedBox(
                width: 50.w,
                child: Icon(
                  Icons.clear,
                  color: Color(0xFF000000),
                ),
              ),
            )
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(),
                OneBlockTopWidget(
                  topText: "서로 남기는\n하루 한장\n시작해볼까요",
                  bottomText: "이메일 인증을 완료해주세요",
                ),
                Container(
                    child: TextInputWidget(
                      hintText: "인증번호 입력",
                      maxLines: 1,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      onSaved: (value) async {
                        await _userInfoViewModel.checkVerificationCode(value??"");
                      },
                    )
                ),
                BottomLargeButtonWidget(
                    onTap: () async {
                      if(_onPressed == false) {
                        _onPressed = true;
                        _formKey.currentState!.save();
                        FocusScope.of(context).unfocus();
                        await _userInfoViewModel.checkInputOk();
                        //_userInfoViewModel.isVerificationCodeOk ?
                        _userInfoViewModel.inputOk ?
                        {
                          await _userInfoViewModel.doVerification(),
                          _userInfoViewModel.resultSuccess ?
                          //_userInfoViewModel.isVerified ?
                          {
                            if(_userInfoViewModel.resultState == null) {
                            //if(_userInfoViewModel.loginFailure == null) {
                              await Provider.of<UserProfileViewModel>(context, listen: false).setCurrentUser(),
                              await Provider.of<DailyCouplePostViewModel>(context, listen: false).initDailyCouplePosts(),
                              await Provider.of<UserInfoViewModel>(context, listen: false).clearAll(),
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => PostMainScreen()), (route) => false),
                            }
                            else if(_userInfoViewModel.resultState == "nonUserInfo"){
                            //else if(_userInfoViewModel.loginFailure == "nonUserInfo"){
                              await Provider.of<UserInfoViewModel>(context, listen: false).clearAll(),
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => RegisterUsernameScreen()), (route) => false),
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "로그인에 실패하였습니다.\n다시 로그인해주세요"
                                  ),
                                ),
                              ),
                              await Provider.of<UserInfoViewModel>(context, listen: false).clearAll(),
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false),
                            }
                          }
                              :
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  _userInfoViewModel.resultMessage!
                                  //_userInfoViewModel.verificationFailMessage!
                              ),
                            ),
                          ),
                        }
                            :
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                _userInfoViewModel.inputErrorMessage!
                                //_userInfoViewModel.verificationCodeErrorMessage!
                            ),
                          ),
                        );
                        _onPressed = false;
                      }
                    },
                    buttonText: "인증 완료"
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

