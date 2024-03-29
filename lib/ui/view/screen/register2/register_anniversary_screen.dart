import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../view_model/daily_couple_post_view_model.dart';
import '../../../view_model/user_info_view_model.dart';
import '../../../view_model/user_profile_view_model.dart';
import '../../widget/route_button_widgets.dart';
import '../../widget/one_block_top_widget.dart';
import '../post/post_main_screen.dart';

bool _onPressed = false;

class RegisterAnniversaryScreen extends StatelessWidget {
  RegisterAnniversaryScreen({Key? key}) : super(key: key);
  //late Register2ViewModel _register2ViewModel;
  late UserInfoViewModel _userInfoViewModel;

  @override
  Widget build(BuildContext context) {
    //_register2ViewModel = Provider.of<Register2ViewModel>(context);
    _userInfoViewModel = Provider.of<UserInfoViewModel>(context);
    return Container(
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(),
                  OneBlockTopWidget(
                    topText: "서로의\n특별한 날을\n기록해주세요",
                    bottomText: "처음 만난 날은 언제인가요?",
                  ),
                  Container(
                      width: 320.w,
                      height: 150.w,
                      alignment: Alignment.center,
                      child: CupertinoDatePicker(
                        minimumYear: 1950,
                        maximumYear: DateTime.now().year,
                        initialDateTime: DateTime.now(),
                        maximumDate: DateTime.now(),
                        onDateTimeChanged: (DateTime value) async {
                          await _userInfoViewModel.setAnniversary(value);
                        },
                        mode: CupertinoDatePickerMode.date,
                      )
                  ),
                  BothButtonsWidget(
                      onTapLeft: () async {
                        if(_onPressed == false) {
                          _onPressed = true;
                          FocusScope.of(context).unfocus();
                          await Provider.of<UserInfoViewModel>(context, listen: false).clearWithoutCredential();
                          Navigator.pop(context);
                          _onPressed = false;
                        }
                      },
                      buttonTextLeft: "이전",
                      onTapRight: () async {
                        if(_onPressed == false) {
                          _onPressed = true;
                          print("푸시");
                          FocusScope.of(context).unfocus();
                          await _userInfoViewModel.uploadUserInfoToDB();
                          _userInfoViewModel.resultSuccess ?
                          //_userInfoViewModel.isUploaded ?
                          {
                            await Provider.of<UserProfileViewModel>(context, listen: false).setCurrentUser(),
                            await Provider.of<DailyCouplePostViewModel>(context, listen: false).initDailyCouplePosts(),
                            await Provider.of<UserInfoViewModel>(context, listen: false).clearAll(),
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PostMainScreen()))
                          }
                              :
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    _userInfoViewModel.resultMessage!
                                    //_userInfoViewModel.uploadFailMessage !
                                )
                            ),
                          );
                          _onPressed = false;
                        }
                      },
                      buttonTextRight: "다음"
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}

