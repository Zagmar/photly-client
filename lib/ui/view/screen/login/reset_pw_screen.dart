import 'package:couple_seflie_app/ui/view/screen/login/update_pw_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register1/register_vertification_screen.dart';
import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:couple_seflie_app/ui/view_model/user_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../widget/text_form_field.dart';
import '../../widget/one_block_top_widget.dart';
import '../login/login_screen.dart';

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
                    onTapLeft: () {
                      _userInfoViewModel.clear();
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    },
                    buttonTextLeft: "이전",
                    onTapRight: () async {
                      _formKey.currentState!.save();
                      FocusScope.of(context).unfocus();
                      _userInfoViewModel.isIdOk ?
                      {
                        await _userInfoViewModel.resetPassword(),
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                _userInfoViewModel.resetPasswordResultMessage!
                            ),
                          ),
                        ),
                        if(_userInfoViewModel.isPWReset){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePwScreen()))
                        }
                      }
                          :
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              _userInfoViewModel.idErrorMessage!
                          ),
                        ),
                      );
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