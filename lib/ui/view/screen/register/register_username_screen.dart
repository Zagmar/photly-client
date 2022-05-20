import 'package:couple_seflie_app/ui/view/screen/register/register_anniversary_screen.dart';
import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:couple_seflie_app/ui/view/widget/text_form_field.dart';
import 'package:couple_seflie_app/ui/view/widget/top_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../view_model/register_view_model.dart';

class RegisterUsernameScreen extends StatelessWidget {
  RegisterUsernameScreen({Key? key}) : super(key: key);
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
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                                _registerViewModel.checkUsername(value??"");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    MediaQuery.of(context).viewInsets.bottom <= 50 ?
                    // Hide button when use keyboard
                    BothButtonsWidget(
                        onTapLeft: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                        buttonTextLeft: "이전",
                        onTapRight: () {
                          _formKey.currentState!.save();
                          FocusScope.of(context).unfocus();
                          _registerViewModel.isUsernameOk ?
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterAnniversaryScreen()))
                              :
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  _registerViewModel.usernameErrorMessage!
                              ),
                            ),
                          );
                        },
                        buttonTextRight: "다음",
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

