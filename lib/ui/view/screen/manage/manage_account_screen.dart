

import 'package:couple_seflie_app/ui/view/screen/manage/reset_anniversary_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/manage/reset_username_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../view_model/daily_couple_post_view_model.dart';
import '../../../view_model/user_info_view_model.dart';
import '../../../view_model/user_profile_view_model.dart';
import '../../widget/post/post_appbar_widget.dart';
import '../login/login_screen.dart';
import '../login/reset_pw_screen.dart';
import '../post/post_main_screen.dart';

class ManageAccountScreen extends StatelessWidget {
  late UserInfoViewModel _userInfoViewModel;
  ManageAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _userInfoViewModel = Provider.of<UserInfoViewModel>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "계정 관리하기",
          style:  Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: Container(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: SingleButton(
              icon: Icons.clear,
              onTap: () async {
                await Provider.of<UserProfileViewModel>(context, listen: false).setCurrentUser();
                await Provider.of<DailyCouplePostViewModel>(context, listen: false).initDailyCouplePosts();
                await Provider.of<UserInfoViewModel>(context, listen: false).clear();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          children: [
            ListTile(
              title: Text('닉네임 변경', style: Theme.of(context).textTheme.bodyLarge,),
              onTap: () async {
                FocusScope.of(context).unfocus();
                await _userInfoViewModel.clear();
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResetUsernameScreen()));
              },
            ),
            ListTile(
              title: Text('기념일 변경', style: Theme.of(context).textTheme.bodyLarge,),
              onTap: () async {
                FocusScope.of(context).unfocus();
                await _userInfoViewModel.clear();
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResetAnniversaryScreen()));
              },
            ),
            ListTile(
              title: Text('비밀번호 변경', style: Theme.of(context).textTheme.bodyLarge,),
              onTap: () async {
                FocusScope.of(context).unfocus();
                await _userInfoViewModel.clear();
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPwScreen()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('나의 기록 초기화', style: Theme.of(context).textTheme.bodyLarge,),
              onTap: (){
                FocusScope.of(context).unfocus();
                showDialog(
                    context: context,
                    builder: (context) {
                      return WarningDialogWidget(
                        onTap: () async {
                          await _userInfoViewModel.doClearPosts();
                          _userInfoViewModel.isPostsClear ?
                          {
                            await Provider.of<DailyCouplePostViewModel>(context, listen: false).clear(),
                            await Provider.of<DailyCouplePostViewModel>(context, listen: false).initDailyCouplePosts(),
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => PostMainScreen()), (route) => false)
                          }
                              :
                          ScaffoldMessenger(
                            child: SnackBar(
                              content: Text(
                                  _userInfoViewModel.clearPostsFailMessage !
                              ),
                            ),
                          );
                        },
                      );
                    }
                );
              },
            ),
            ListTile(
              title: Text('커플 끊기', style: Theme.of(context).textTheme.bodyLarge,),
              onTap: (){
                FocusScope.of(context).unfocus();
                showDialog(
                    context: context,
                    builder: (context) {
                      return WarningDialogWidget(
                        onTap: () async {
                          await _userInfoViewModel.doClearPartner();
                          _userInfoViewModel.isPartnerClear ?
                          {
                            await Provider.of<DailyCouplePostViewModel>(context, listen: false).clear(),
                            await Provider.of<DailyCouplePostViewModel>(context, listen: false).initDailyCouplePosts(),
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => PostMainScreen()), (route) => false)
                          }
                              :
                          ScaffoldMessenger(
                            child: SnackBar(
                              content: Text(
                                  _userInfoViewModel.clearPartnerFailMessage !
                              ),
                            ),
                          );
                        },
                      );
                    }
                );
              },
            ),
            ListTile(
              title: Text(
                '회원 탈퇴',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.red),
              ),
              onTap: (){
                FocusScope.of(context).unfocus();
                showDialog(
                    context: context,
                    builder: (context) {
                      return WarningDialogWidget(
                        onTap: () async {
                          await _userInfoViewModel.clearUser();
                          _userInfoViewModel.isUserClear ?
                          {
                            await Provider.of<DailyCouplePostViewModel>(context, listen: false).clear(),
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false)
                          }
                              :
                          ScaffoldMessenger(
                            child: SnackBar(
                              content: Text(
                                  _userInfoViewModel.clearUserFailMessage !
                              ),
                            ),
                          );
                        },
                      );
                    }
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WarningDialogWidget extends StatelessWidget {
  final GestureTapCallback onTap;
  const WarningDialogWidget({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "진행 후에는 복구할 수 없습니다\n",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.w,
                  color: Colors.black,
                  letterSpacing: 0
              ),
            ),
            TextSpan(
              text:  "정말로 진행하시겠습니까?",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.w,
                  color: Colors.black,
                  letterSpacing: 0
              ),
            ),
          ],
        ),
      ),
      alignment: Alignment.center,
      contentPadding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.w),
      children: <Widget>[
        InkWell(
          onTap: onTap,
          child: Container(
            width: 100.w,
            child: Text(
              "진행할래요",
              style: TextStyle(
                fontSize: 12.w,
                fontWeight: FontWeight.w400,
                color: Color(0xFF808080),
                decoration: TextDecoration.underline,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(height: 10.w,),
        InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.w),
              //color: Color(0xFFEEEEEE),
            ),
            width: 390.w,
            height: 50.w,
            alignment: Alignment.center,
            child: Text(
              "취소",
              style: TextStyle(
                  fontSize: 16.w,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF319CFF)
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
