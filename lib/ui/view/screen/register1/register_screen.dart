import 'package:couple_seflie_app/ui/view/screen/register1/register_vertification_screen.dart';
import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:couple_seflie_app/ui/view_model/user_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../widget/text_form_field.dart';
import '../../widget/one_block_top_widget.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
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
              onTap: (){
                _userInfoViewModel.clear();
                FocusScope.of(context).unfocus();
                Navigator.popUntil(context, (route) => route.isFirst);
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
                MediaQuery.of(context).viewInsets.bottom <= 30.w ?
                OneBlockTopWidget(
                  topText: "서로 남기는\n하루 한장\n시작해볼까요",
                  bottomText: "회원가입을 진행합니다",
                ):
                OneBlockTopWidgetKeyboardOn(
                    text: "회원 정보를 입력중입니다"
                ),
                RegisterFormWidget(userInfoViewModel: _userInfoViewModel),
                // Register Button
                BottomLargeButtonWidget(
                    onTap: () async {
                      _formKey.currentState!.save();
                      FocusScope.of(context).unfocus();
                      !_userInfoViewModel.isRegisterOk ?
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              _userInfoViewModel.idErrorMessage ?? _userInfoViewModel.pwErrorMessage ?? '입력된 정보가 올바르지 않습니다'
                          ),
                        ),
                      )
                          :
                      await _userInfoViewModel.doRegistration();

                      _userInfoViewModel.isRegistered ?
                      {
                        _userInfoViewModel.clearSecret(),
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterVertificationScreen()))
                      }
                          :
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              _userInfoViewModel.registrationFailMessage!
                          ),
                        ),
                      );
                    },
                    buttonText: "회원가입"
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterFormWidget extends StatelessWidget {
  final UserInfoViewModel userInfoViewModel;
  const RegisterFormWidget({Key? key, required this.userInfoViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      height: 180.w,
      alignment: Alignment.center,
      child: Column(
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
          TextInputWidget(
            hintText: "비밀번호 확인",
            maxLines: 1,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            onSaved: (value) async {
              await userInfoViewModel.checkPasswordCheck(value??"");
            },
          ),
        ],
      ),
    );
  }
}


