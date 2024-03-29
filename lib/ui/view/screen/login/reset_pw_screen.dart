import 'package:couple_seflie_app/ui/view/screen/login/update_pw_screen.dart';
import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:couple_seflie_app/ui/view_model/user_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../widget/text_form_field.dart';
import '../../widget/one_block_top_widget.dart';

bool _onPressed = false;

class ResetPwScreen extends StatelessWidget {
  ResetPwScreen({Key? key}) : super(key: key);
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
                OneBlockTopWidget(topText: "비밀번호를\n새롭게\n변경해보세요", bottomText: "사용중인 아이디를 입력해주세요"),
                Container(
                  height: 150.w,
                  alignment: Alignment.center,
                  child: TextInputWidget(
                    hintText: "이메일을 입력해주세요",
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_){
                      FocusScope.of(context).unfocus();
                    },
                    obscureText: false,
                    onSaved: (value) {
                      _userInfoViewModel.checkEmail(value??"");
                    },
                  ),
                ),
                MediaQuery.of(context).viewInsets.bottom <= 50 ?
                // Hide button when use keyboard
                BothButtonsWidget(
                    onTapLeft: () async {
                      if(_onPressed == false) {
                        _onPressed = true;
                        await Provider.of<UserInfoViewModel>(context, listen: false).clearAll();
                        FocusScope.of(context).unfocus();
                        Navigator.pop(context);
                        _onPressed = false;
                      }
                    },
                    buttonTextLeft: "이전",
                    onTapRight: () async {
                      if(_onPressed == false){
                        _onPressed = true;
                        _formKey.currentState!.save();
                        FocusScope.of(context).unfocus();
                        //_userInfoViewModel.isIdOk ?
                        await _userInfoViewModel.checkInputOk();
                        _userInfoViewModel.inputOk ?
                        {
                          await _userInfoViewModel.resetPassword(),
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  _userInfoViewModel.resultMessage!
                                  //_userInfoViewModel.resetPasswordResultMessage!
                              ),
                            ),
                          ),
                          if(_userInfoViewModel.resultSuccess){
                          //if(_userInfoViewModel.isPWReset){
                          await Provider.of<UserInfoViewModel>(context, listen: false).clearWithoutCredential(),
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePwScreen()))
                          }
                        }
                            :
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                _userInfoViewModel.inputErrorMessage!
                                //_userInfoViewModel.idErrorMessage!
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