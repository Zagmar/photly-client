import 'package:couple_seflie_app/main.dart';
import 'package:couple_seflie_app/ui/view/screen/login/login_screen.dart';
import 'package:couple_seflie_app/ui/view_model/user_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogoutScreen extends StatelessWidget {
  LogoutScreen({Key? key}) : super(key: key);
  late UserInfoViewModel _userInfoViewModel;

  @override
  Widget build(BuildContext context) {
    _userInfoViewModel = Provider.of<UserInfoViewModel>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: TextButton(
          onPressed: () async {
            await _userInfoViewModel.doLogout() ?
            {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false)
            }
                :
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    _userInfoViewModel.logoutFailMessage!
                ),
              ),
            );
          },
          child: Text(
              username
          ),
        ),
      ),
    );
  }
}
