import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/user_view_model.dart';

Widget mainDrawerWidget(BuildContext context) {
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
            await _userViewModel.doLogout() ?
            {
              Navigator.pushNamedAndRemoveUntil(context, "/loginScreen", (route) => false)
            }
                :
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
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