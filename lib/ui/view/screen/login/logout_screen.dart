import 'package:couple_seflie_app/main.dart';
import 'package:couple_seflie_app/ui/view/screen/login/login_screen.dart';
import 'package:couple_seflie_app/ui/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogoutScreen extends StatelessWidget {
  LogoutScreen({Key? key}) : super(key: key);
  late UserViewModel _userViewModel;

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: TextButton(
          onPressed: () async {
            await _userViewModel.doLogout() ?
            {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false)
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
          child: Text(
              username
          ),
        ),
      ),
    );
  }
}
