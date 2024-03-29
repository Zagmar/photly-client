import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:couple_seflie_app/ui/view_model/user_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../widget/text_form_field.dart';
import '../../widget/one_block_top_widget.dart';
import '../login/login_screen.dart';

bool _onPressed = false;

class UpdatePwScreen extends StatelessWidget {
  UpdatePwScreen({Key? key}) : super(key: key);
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
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(),
                OneBlockTopWidget(topText: "${_userInfoViewModel.email!}의\n비밀번호를\n변경하고 있습니다", bottomText: "나머지 절차를 완료해주세요"),
                Container(
                  height: 150.w,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      TextInputWidget(
                        hintText: "초기화 확인 코드를 입력해주세요",
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (_){
                          FocusScope.of(context).unfocus();
                        },
                        obscureText: false,
                        onSaved: (value) {
                          _userInfoViewModel.checkResetPwConfirmedCode(value??"");
                        },
                      ),
                      TextInputWidget(
                        hintText: "변경하실 비밀번호를 입력해주세요",
                        maxLines: 1,
                        keyboardType: TextInputType.visiblePassword,
                        onFieldSubmitted: (_){
                          FocusScope.of(context).unfocus();
                        },
                        obscureText: true,
                        onSaved: (value) {
                          _userInfoViewModel.checkPassword(value??"");
                        },
                      ),
                      TextInputWidget(
                        hintText: "변경하실 비밀번호를 확인해주세요",
                        maxLines: 1,
                        keyboardType: TextInputType.visiblePassword,
                        onFieldSubmitted: (_){
                          FocusScope.of(context).unfocus();
                        },
                        obscureText: true,
                        onSaved: (value) {
                          _userInfoViewModel.checkPasswordCheck(value??"");
                        },
                      ),
                    ],
                  )
                ),
                MediaQuery.of(context).viewInsets.bottom <= 50 ?
                // Hide button when use keyboard
                BothButtonsWidget(
                    onTapLeft: () async {
                      if(_onPressed == false) {
                        _onPressed = true;
                        FocusScope.of(context).unfocus();
                        await Provider.of<UserInfoViewModel>(context, listen: false).clearAll();
                        Navigator.pop(context);
                        _onPressed = false;
                      }
                    },
                    buttonTextLeft: "이전",
                    onTapRight: () async {
                      if(_onPressed == false) {
                        _onPressed = true;
                        _formKey.currentState!.save();
                        FocusScope.of(context).unfocus();
                        await _userInfoViewModel.checkInputOk();
                        _userInfoViewModel.inputOk ?
                        //_userInfoViewModel.isConfirmResetPassword ?
                        {
                          await _userInfoViewModel.confirmResetPassword(),

                          _userInfoViewModel.resultSuccess ?
                          //_userInfoViewModel.isPWReset ?
                          {
                            FocusScope.of(context).unfocus(),
                            await Provider.of<UserInfoViewModel>(context, listen: false).clearAll(),
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false),
                          }
                              :
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  _userInfoViewModel.resultMessage!
                                  //_userInfoViewModel.resetPasswordResultMessage!
                              ),
                            ),
                          ),
                        }
                            :
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                _userInfoViewModel.inputErrorMessage!
                                //_userInfoViewModel.pwErrorMessage??_userInfoViewModel.pwCheckErrorMessage??_userInfoViewModel.pwResetErrorMessage??"Unknown Error"
                            ),
                          ),
                        );
                        _onPressed = false;
                      }
                    },
                    buttonTextRight: "완료"
                )
                    :
                Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}