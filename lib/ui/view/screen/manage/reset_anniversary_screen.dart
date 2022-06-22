import 'package:couple_seflie_app/ui/view/screen/login/update_pw_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register1/register_vertification_screen.dart';
import 'package:couple_seflie_app/ui/view/widget/route_button_widgets.dart';
import 'package:couple_seflie_app/ui/view_model/user_info_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../view_model/user_profile_view_model.dart';
import '../../widget/text_form_field.dart';
import '../../widget/one_block_top_widget.dart';
import '../login/login_screen.dart';

class ResetAnniversaryScreen extends StatelessWidget {
  ResetAnniversaryScreen({Key? key}) : super(key: key);
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
                OneBlockTopWidget(topText: "서로의\n특별한 날을\n기록해보세요", bottomText: "처음 만난 날은 언제인가요?"),
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
                        _userInfoViewModel.setAnniversary(value);
                      },
                      mode: CupertinoDatePickerMode.date,
                    )
                ),
                MediaQuery.of(context).viewInsets.bottom <= 50 ?
                // Hide button when use keyboard
                BothButtonsWidget(
                    onTapLeft: () {
                      _userInfoViewModel.clear();
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    },
                    buttonTextLeft: "이전",
                    onTapRight: () async {
                      FocusScope.of(context).unfocus();
                      if(!_userInfoViewModel.isAnniversaryOk){
                        _userInfoViewModel.setAnniversary(DateTime.now());
                      }

                      await _userInfoViewModel.updateAnniversary();
                      _userInfoViewModel.isUploaded ?
                      {
                        await Provider.of<UserProfileViewModel>(context, listen: false).setCurrentUser(),
                        await Provider.of<UserInfoViewModel>(context, listen: false).clear(),
                        Navigator.pop(context),
                      }
                          :
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                _userInfoViewModel.uploadFailMessage !
                            )
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
    );
  }
}