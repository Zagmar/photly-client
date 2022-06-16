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
          ListTile(
            title: Text('커플 등록'),
            onTap: () async {
              FocusScope.of(context).unfocus();
              await Provider.of<UserInfoViewModel>(context, listen: false).setUserCoupleCode();
              Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterCoupleCodeScreen(), fullscreenDialog: true,));
            },
          ),
          Divider(),
          ListTile(
            title: Text('계정 관리'),
            onTap: (){
              FocusScope.of(context).unfocus();
              Navigator.push(context, MaterialPageRoute(builder: (context) => ManageAccountScreen(), fullscreenDialog: true,));
            },
          ),
          Divider(),
          ListTile(
            title: Text('서비스 문의'),
            onTap: (){
              FocusScope.of(context).unfocus();
              Navigator.push(context, MaterialPageRoute(builder: (context) => InformationScreen(), fullscreenDialog: true,));
            },
          ),
        ],
      ),
    );
  }
}
