import 'package:couple_seflie_app/ui/view/screen/register1/register_vertification_screen.dart';
import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../view_model/register1_view_model.dart';
import '../../widget/text_form_field.dart';
import '../../widget/top_widgets.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  late Register1ViewModel _registerViewModel;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _registerViewModel = Provider.of<Register1ViewModel>(context);
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
                _registerViewModel.clear();
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
                Container(
                  padding: EdgeInsetsDirectional.fromSTEB(35.w, 20.w, 35.w, 20.w),
                  child: Column(
                    children: <Widget>[
                      OneBlockTop(
                        topText: "서로 남기는\n하루 한장\n시작해볼까요",
                        bottomText: "회원가입을 진행합니다",
                      ),
                      RegisterFormWidget(registerViewModel: _registerViewModel),
                    ],
                  ),
                ),
                MediaQuery.of(context).viewInsets.bottom <= 50 ?
                // Register Button
                LargeButtonWidget(
                    onTap: () async {
                      _formKey.currentState!.save();
                      FocusScope.of(context).unfocus();
                      !_registerViewModel.isRegisterOk ?
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              _registerViewModel.idErrorMessage ?? _registerViewModel.pwErrorMessage ?? '입력된 정보가 올바르지 않습니다'
                          ),
                        ),
                      )
                          :
                      await _registerViewModel.doRegistration();

                      _registerViewModel.isRegistered ?
                      {
                        _registerViewModel.clear(),
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterVertificationScreen()))
                      }
                          :
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              _registerViewModel.registrationFailMessage!
                          ),
                        ),
                      );
                    },
                    buttonText: "회원가입"
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

class RegisterFormWidget extends StatelessWidget {
  final Register1ViewModel registerViewModel;
  const RegisterFormWidget({Key? key, required this.registerViewModel}) : super(key: key);

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
              await registerViewModel.checkEmail(value??"");
            },
          ),
          TextInputWidget(
            hintText: "비밀번호 입력",
            maxLines: 1,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            onSaved: (value) async {
              await registerViewModel.checkPassword(value??"");
            },
          ),
          TextInputWidget(
            hintText: "비밀번호 확인",
            maxLines: 1,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            onSaved: (value) async {
              await registerViewModel.checkPasswordCheck(value??"");
            },
          ),
        ],
      ),
    );
  }
}


