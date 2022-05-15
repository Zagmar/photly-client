import 'package:couple_seflie_app/ui/view/screen/login/login_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/user_view_model.dart';

class MainDrawerWidget extends StatelessWidget {
  late UserViewModel _userViewModel;
  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context);
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
              await Provider.of<UserViewModel>(context, listen: false).doLogout() ?
              {
                //Navigator.pushNamedAndRemoveUntil(context, "/loginScreen", (route) => false)
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false)
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