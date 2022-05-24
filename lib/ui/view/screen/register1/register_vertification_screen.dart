import 'package:couple_seflie_app/ui/view/screen/register2/register_username_screen.dart';
import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:couple_seflie_app/ui/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../view_model/register1_view_model.dart';
import '../../widget/text_form_field.dart';
import '../../widget/top_widgets.dart';

class RegisterVertificationScreen extends StatelessWidget {
  RegisterVertificationScreen({Key? key}) : super(key: key);
  late LoginViewModel _loginViewModel;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _loginViewModel = Provider.of<LoginViewModel>(context);
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
                _loginViewModel.clear();
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
                        bottomText: "이메일 인증을 완료해주세요",
                      ),
                      Container(
                        child: Text(
                          "이메일 인증이 완료되면 \n저희 Photly를 즐길 수 있어요",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
                LargeButtonWidget(
                    onTap: () async {
                      await _loginViewModel.checkVerification();
                      _loginViewModel.isVerified ?
                      {
                        _loginViewModel.clear(),
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => RegisterUsernameScreen()), (route) => false)
                      }
                          :
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              _loginViewModel.verificationFailMessage!
                          ),
                        ),
                      );
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

