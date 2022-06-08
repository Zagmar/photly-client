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
                Text(
                    'Photly',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w700,
                    fontSize: 24.w
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                    Text(
                        _userProfileViewModel.userName!,
                      style: TextStyle(
                          color: Color(0xFF444444),
                          fontWeight: FontWeight.w400,
                          fontSize: 18.w
                      ),
                    )
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.yellow,
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
            onTap: () async {
              await _userInfoViewModel.doClearPosts();
              _userInfoViewModel.isDeleted ?
              {
                await Provider.of<DailyCouplePostViewModel>(context, listen: false).clear(),
                await Provider.of<DailyCouplePostViewModel>(context, listen: false).initDailyCouplePosts(),
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => PostMainScreen()), (route) => false)
              }
                  :
              ScaffoldMessenger(
                child: SnackBar(
                  content: Text(
                      _userInfoViewModel.deleteFailMessage !
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('커플 끊기'),
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
                      _userInfoViewModel.deleteFailMessage !
                  ),
                ),
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
            onTap: () {}
          ),
        ],
      ),
    );
  }
}

/*
Widget mainDrawerWidget(context, GlobalKey scaffoldKey) {
 if(scaffoldKey.currentContext != null) {
   print("테스트 성공");
   BuildContext context = scaffoldKey.currentState!.context;
 }
 else{
   print("테스트 실패");
 }

  UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      children: [
        DrawerHeader(
          child: Text('Photly'),
          decoration: BoxDecoration(
            color: Colors.yellow,
          ),
        ),
        ListTile(
          title: Text('Item 1'),
        ),
        ListTile(
          title: Text('로그아웃'),
          onTap: () async {
            //await _userViewModel.doLogout() ?
            await Provider.of<UserViewModel>(context, listen: false).doLogout() ?
            {
              Navigator.pushNamedAndRemoveUntil(context, "/loginScreen", (route) => false)
            }
                :
            ScaffoldMessenger(
              child: SnackBar(
                content: Text(
                    _userViewModel.logoutFailMessage!
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}

 */