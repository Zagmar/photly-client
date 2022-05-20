import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:couple_seflie_app/ui/view/widget/text_form_field.dart';
import 'package:couple_seflie_app/ui/view/widget/top_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../view_model/register_view_model.dart';

class RegisterCoupleCodeScreen extends StatelessWidget {
  RegisterCoupleCodeScreen({Key? key}) : super(key: key);
  late RegisterViewModel _registerViewModel;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _registerViewModel = Provider.of<RegisterViewModel>(context);
    return Container(
        child: GestureDetector(
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
            body: SafeArea(
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
                              topText: "이제\n서로를\n연결해봐요",
                              bottomText: "초대 링크를 함께하고 싶은 사람에게"
                          ),
                          RegisterCoupleCodeWidget(registerViewModel: _registerViewModel,),
                        ],
                      ),
                    ),
                    MediaQuery.of(context).viewInsets.bottom <= 50 ?
                    BothButtonsWidget(
                        onTapLeft: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                        buttonTextLeft: "이전",
                        onTapRight: () async {
                          _formKey.currentState!.save();
                          FocusScope.of(context).unfocus();
                          await _registerViewModel.doRegistration() ?
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    _registerViewModel.registrationResultMessage
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            ),
                            Navigator.pushNamedAndRemoveUntil(context, "/loginScreen", (route) => false)
                          }
                              :
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  _registerViewModel.registrationResultMessage
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
        )
    );
  }
}

class RegisterCoupleCodeWidget extends StatelessWidget {
  final RegisterViewModel registerViewModel;
  const RegisterCoupleCodeWidget({Key? key, required this.registerViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      height: 160.w,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextInputWidget(
              maxLines: 1,
              maxLength: 7,
              keyboardType: TextInputType.text,
              obscureText: false,
              onSaved: (value) async {
                await registerViewModel.checkCode(value??"");
              },
          ),
          Padding(padding: EdgeInsets.only(bottom: 10.w)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "나의 코드 복사하기",
                style: TextStyle(
                    fontSize: 16.w,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF808080)
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 10.w)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 255.w,
                    height: 20.w,
                    child: Text(
                      registerViewModel.userCode,
                      style: TextStyle(
                        fontSize: 16.w,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFD3D3D3),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      FocusScope.of(context).unfocus();
                      Clipboard.setData(ClipboardData(text: registerViewModel.userCode));
                    },
                    child: Container(
                      width: 45.w,
                      height: 15.w,
                      child: Text(
                        "복사하기",
                        style: TextStyle(
                          fontSize: 11.w,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF808080),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF808080),
                        ),
                      ),
                    ),
                  ),
                  Divider()
                ],
              ),
              Divider(
                thickness: 1.w,
                color: Color(0xFFC4C4C4),
              )
            ],
          ),
        ],
      ),
    );
  }
}
