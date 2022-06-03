import 'package:couple_seflie_app/ui/view/screen/login/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../view_model/register2_view_model.dart';
import '../../../view_model/user_info_view_model.dart';
import '../../widget/route_button_widgets.dart';
import '../../widget/top_widgets.dart';

class RegisterAnniversaryScreen extends StatelessWidget {
  RegisterAnniversaryScreen({Key? key}) : super(key: key);
  late Register2ViewModel _register2ViewModel;
  late UserInfoViewModel _userInfoViewModel;

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
                          topText: "서로의\n특별한 날을\n기록해주세요",
                          bottomText: "가장 특별한 하루를 정해주세요",
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
                              onDateTimeChanged: (DateTime value) {
                                _register2ViewModel.setAnniversary(value);
                              },
                              mode: CupertinoDatePickerMode.date,
                            )
                        ),
                      ],
                    ),
                  ),
                  BothButtonsWidget(
                      onTapLeft: (){
                        FocusScope.of(context).unfocus();
                        Navigator.pop(context);
                      },
                      buttonTextLeft: "이전",
                      onTapRight: () async {
                        FocusScope.of(context).unfocus();
                        _register2ViewModel.isAnniversaryOk ?
                        {
                          await _register2ViewModel.uploadUserInfoToDB(),
                          _register2ViewModel.isUploaded ?
                          {
                            _userInfoViewModel = Provider.of<UserInfoViewModel>(context),
                            await _userInfoViewModel.doLogout(),
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()))
                          }
                              :
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    _register2ViewModel.uploadFailMessage !
                                )
                            ),
                          )
                        }
                            :
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                _register2ViewModel.anniversaryErrorMessage!
                            )
                          ),
                        );
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

