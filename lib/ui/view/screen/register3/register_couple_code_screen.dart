import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:couple_seflie_app/ui/view/widget/text_form_field.dart';
import 'package:couple_seflie_app/ui/view/widget/one_block_top_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../view_model/daily_couple_post_view_model.dart';
import '../../../view_model/user_info_view_model.dart';

bool _onPressed = false;

class RegisterCoupleCodeScreen extends StatelessWidget {
  RegisterCoupleCodeScreen({Key? key}) : super(key: key);
  late UserInfoViewModel _userInfoViewModel;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _userInfoViewModel = Provider.of<UserInfoViewModel>(context);
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
                  splashColor: Colors.transparent,
                  onTap: () async {
                    if(_onPressed == false) {
                      _onPressed = true;
                      FocusScope.of(context).unfocus();
                      await Provider.of<UserInfoViewModel>(context, listen: false).clearAll();
                      Navigator.pop(context);
                      _onPressed = false;
                    }
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
            body: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(),
                  OneBlockTopWidget(
                      topText: "이제\n서로를\n연결해봐요",
                      bottomText: "초대 링크를 함께하고 싶은 사람에게"
                  ),
                  RegisterCoupleCodeWidget(),
                  MediaQuery.of(context).viewInsets.bottom <= 50 ?
                  BottomLargeButtonWidget(
                      onTap: () async {
                        if(_onPressed == false) {
                          _onPressed = true;
                          _formKey.currentState!.save();
                          FocusScope.of(context).unfocus();
                          await _userInfoViewModel.checkInputOk();
                          _userInfoViewModel.inputOk ?
                          //_userInfoViewModel.isCoupleCoupleCodeOk ?
                          {
                            await _userInfoViewModel.matchCoupleCode(),
                            _userInfoViewModel.resultSuccess ?
                            //_userInfoViewModel.isCoupleCodeMatched ?
                            {
                              await Provider.of<DailyCouplePostViewModel>(context, listen: false).clear(),
                              await Provider.of<DailyCouplePostViewModel>(context, listen: false).initDailyCouplePosts(),
                              await Provider.of<UserInfoViewModel>(context, listen: false).clearAll(),
                              //_register3ViewModel.clearCoupleCode(),
                              Navigator.pop(context),
                            }
                                :
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    _userInfoViewModel.resultMessage!
                                    //_userInfoViewModel.coupleCodeMatchFailMessage!
                                ),
                              ),
                            )
                          }
                          :
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  _userInfoViewModel.inputErrorMessage!
                                  //_userInfoViewModel.coupleCodeErrorMessage!
                              ),
                            ),
                          );
                          _onPressed = false;
                        }
                      },
                      buttonText: "등록하기"
                  )
                      :
                  Container()
                ],
              ),
            ),
          ),
        )
    );
  }
}

class RegisterCoupleCodeWidget extends StatelessWidget {

  const RegisterCoupleCodeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserInfoViewModel _userInfoViewModel = Provider.of<UserInfoViewModel>(context);
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
              maxLength: 8,
              keyboardType: TextInputType.text,
              obscureText: false,
              onSaved: (value) async {
                await _userInfoViewModel.checkCoupleCode(value??"");
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
                      _userInfoViewModel.userCode??"로드 실패",
                      style: TextStyle(
                        fontSize: 16.w,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFD3D3D3),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: (){
                      if(_onPressed == false) {
                        _onPressed = true;
                        FocusScope.of(context).unfocus();
                        Clipboard.setData(ClipboardData(text: _userInfoViewModel.userCode!));
                        _onPressed = false;
                      }
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
