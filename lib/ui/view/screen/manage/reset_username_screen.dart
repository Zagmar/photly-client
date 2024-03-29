import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:couple_seflie_app/ui/view_model/user_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../view_model/user_profile_view_model.dart';
import '../../widget/text_form_field.dart';
import '../../widget/one_block_top_widget.dart';

bool _onPressed = false;

class ResetUsernameScreen extends StatelessWidget {
  ResetUsernameScreen({Key? key}) : super(key: key);
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
                OneBlockTopWidget(topText: "닉네임을\n새롭게\n변경해보세요", bottomText: "변경할 닉네임을 입력해주세요"),
                Container(
                  height: 150.w,
                  alignment: Alignment.center,
                  child: TextInputWidget(
                    hintText: "서로 부르는 애칭, 별명 다 좋아요!",
                    maxLines: 1,
                    maxLength: 6,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_){
                      FocusScope.of(context).unfocus();
                    },
                    obscureText: false,
                    onSaved: (value) {
                      _userInfoViewModel.checkUsername(value??"");
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
                      if(_onPressed == false) {
                        _onPressed = true;
                        _formKey.currentState!.save();
                        FocusScope.of(context).unfocus();
                        await _userInfoViewModel.checkInputOk();
                        _userInfoViewModel.inputOk ?
                        //_userInfoViewModel.isUsernameOk ?
                        {
                          await _userInfoViewModel.updateUsername(),
                          _userInfoViewModel.resultSuccess ?
                          //_userInfoViewModel.isUploaded ?
                          {
                            await Provider.of<UserProfileViewModel>(context, listen: false).setCurrentUser(),
                            await Provider.of<UserInfoViewModel>(context, listen: false).clearAll(),
                            Navigator.pop(context),
                          }
                              :
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  _userInfoViewModel.resultMessage!
                                  //_userInfoViewModel.uploadFailMessage!
                              ),
                            ),
                          )
                        }
                            :
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                _userInfoViewModel.inputErrorMessage!
                                //_userInfoViewModel.usernameErrorMessage!
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