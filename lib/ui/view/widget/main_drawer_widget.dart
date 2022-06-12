import 'package:couple_seflie_app/ui/view/screen/login/login_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_edit_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:couple_seflie_app/ui/view_model/daily_couple_post_view_model.dart';
import 'package:couple_seflie_app/ui/view_model/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../view_model/user_info_view_model.dart';
import '../../view_model/user_profile_view_model.dart';

class MainDrawerWidget extends StatelessWidget {
  late UserProfileViewModel _userProfileViewModel;
  late UserInfoViewModel _userInfoViewModel;
  @override
  Widget build(BuildContext context) {
    _userProfileViewModel = Provider.of<UserProfileViewModel>(context, listen: false);
    _userInfoViewModel = Provider.of<UserInfoViewModel>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        children: [
          DrawerHeader(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /*
                    _userProfileViewModel.userImageUrl == null ?
                    Image.asset(
                      "images/default/avatar.png",
                      width: 30.w,
                      height: 30.w,
                      fit: BoxFit.cover,
                    )
                    :
                    CachedNetworkImageWidget(
                        imageUrl: _userProfileViewModel.userImageUrl!,
                        width: 30.w,
                        height: 30.w
                    ),
                    Padding(padding: EdgeInsets.only(right: 10.w)),

                     */
                    Text(
                      '${_userProfileViewModel.userName!} 님, 환영합니다',
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w400,
                          fontSize: 18.w
                      ),
                    )
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xFF000000),
            ),
          ),
          ListTile(
            title: Text('로그아웃'),
            onTap: () async {
              await _userInfoViewModel.doLogout();

              _userInfoViewModel.isLogout ?
              {
                Provider.of<DailyCouplePostViewModel>(context, listen: false).clear(),
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false)
              }
                  :
              ScaffoldMessenger(
                child: SnackBar(
                  content: Text(
                      _userInfoViewModel.logoutFailMessage!
                  ),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text('나의 기록 초기화'),
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
            title: Text('커플 끊기'),
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
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600
              ),
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
    );
  }
}

class WarningDialogWidget extends StatelessWidget {
  final GestureTapCallback onTap;
  WarningDialogWidget({Key? key, required this.onTap}) : super(key: key);

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
