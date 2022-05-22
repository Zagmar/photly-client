import 'package:couple_seflie_app/ui/view/screen/register2/register_anniversary_screen.dart';
import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:couple_seflie_app/ui/view/widget/text_form_field.dart';
import 'package:couple_seflie_app/ui/view/widget/top_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../view_model/register2_view_model.dart';

class RegisterUsernameScreen extends StatelessWidget {
  RegisterUsernameScreen({Key? key}) : super(key: key);
  late Register2ViewModel _register2ViewModel;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _register2ViewModel = Provider.of<Register2ViewModel>(context);
    return Container(
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
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
                          OneBlockTop(topText: "서로 불러줄\n닉네임을\n정해주세요", bottomText: "나중에 수정이 가능해요!"),
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
                                _register2ViewModel.checkUsername(value??"");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    MediaQuery.of(context).viewInsets.bottom <= 50 ?
                    // Hide button when use keyboard
                    RightButtonOnlyWidget(
                        onTap: () {
                          _formKey.currentState!.save();
                          FocusScope.of(context).unfocus();
                          _register2ViewModel.isUsernameOk ?
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterAnniversaryScreen()))
                              :
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  _register2ViewModel.usernameErrorMessage!
                              ),
                            ),
                          );
                        },
                        buttonText: "다음"
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

