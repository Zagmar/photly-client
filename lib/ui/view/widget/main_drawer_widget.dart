import 'package:couple_seflie_app/ui/view/screen/login/login_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/manage/manage_account_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_edit_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:couple_seflie_app/ui/view_model/daily_couple_post_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../view_model/user_info_view_model.dart';
import '../../view_model/user_profile_view_model.dart';
import '../screen/manage/information_screen.dart';
import '../screen/register3/register_couple_code_screen.dart';

class MainDrawerWidget extends StatelessWidget {
  late UserProfileViewModel _userProfileViewModel;
  late UserInfoViewModel _userInfoViewModel;
  bool _onPressed = false;
  @override
  Widget build(BuildContext context) {
    _userProfileViewModel = Provider.of<UserProfileViewModel>(context, listen: false);
    _userInfoViewModel = Provider.of<UserInfoViewModel>(context);
    return Container(
      width: 300.w,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          children: [
            SizedBox(
              height: 200.w,
              child: DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/photlyIcon.png",
                          height: 30.w,
                        ),
                        Container(width: 10.w,),
                        Image.asset(
                          "assets/images/photlyName.png",
                          height: 30.w,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    Divider(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_userProfileViewModel.userName!} 님, 환영합니다',
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w400,
                              fontSize: 18.w
                          ),
                        ),
                        Provider.of<DailyCouplePostViewModel>(context).isCouple ?
                        Padding(
                          padding: EdgeInsets.only(top: 10.w),
                          child: Text(
                            '함께한지 ${_userProfileViewModel.coupleDays!}일째',
                            style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w700,
                                fontSize: 14.w
                            ),
                          ),
                        ):Container()
                      ],
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF000000),
                ),
              ),
            ),
            Provider.of<DailyCouplePostViewModel>(context).isCouple ?
            Container()
                :
            InkWell(
              splashColor: Colors.transparent,
              child: Container(
                  padding: EdgeInsets.all(18.w),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '커플 등록',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.blueAccent, fontWeight: FontWeight.w700),
                  )
              ),
              onTap: () async {
                if(_onPressed == false) {
                  _onPressed = true;
                  FocusScope.of(context).unfocus();
                  await Provider.of<UserInfoViewModel>(context, listen: false).setUserCoupleCode();
                  await Provider.of<UserInfoViewModel>(context, listen: false).clearAll();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterCoupleCodeScreen(), fullscreenDialog: true,));
                  _onPressed = false;
                }
              },
            ),
            InkWell(
              splashColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(18.w),
                alignment: Alignment.centerLeft,
                child: Text(
                  '로그아웃',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              onTap: () async {
                if(_onPressed == false) {
                  _onPressed = true;
                  await _userInfoViewModel.doLogout();
                  _userInfoViewModel.resultSuccess ?
                  //_userInfoViewModel.isLogout ?
                  {
                    Provider.of<DailyCouplePostViewModel>(context, listen: false).clear(),
                    await Provider.of<UserInfoViewModel>(context, listen: false).clearAll(),
                    Navigator.pushAndRemoveUntil(context, PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) => LoginScreen(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero
                    ), (route) => false),
                  }
                      :
                  ScaffoldMessenger(
                    child: SnackBar(
                      content: Text(
                          _userInfoViewModel.resultMessage!
                      ),
                    ),
                  );
                  _onPressed = false;
                }
              },
            ),
            Divider(),
            InkWell(
              splashColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(18.w),
                alignment: Alignment.centerLeft,
                child: Text(
                  '계정 관리',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              onTap: () async {
                if(_onPressed == false) {
                  _onPressed = true;
                  FocusScope.of(context).unfocus();
                  await Provider.of<UserInfoViewModel>(context, listen: false).clearAll();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ManageAccountScreen(), fullscreenDialog: true,));
                  _onPressed = false;
                }
              },
            ),
            Divider(),
            InkWell(
              splashColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(18.w),
                alignment: Alignment.centerLeft,
                child: Text(
                  '서비스 문의',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              onTap: () async {
                if(_onPressed == false) {
                  _onPressed = true;
                  FocusScope.of(context).unfocus();
                  await Provider.of<UserInfoViewModel>(context, listen: false).clearAll();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => InformationScreen(), fullscreenDialog: true,));
                  _onPressed = false;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
