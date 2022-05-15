import 'package:couple_seflie_app/main.dart';
import 'package:couple_seflie_app/ui/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogoutScreen extends StatelessWidget {
  LogoutScreen({Key? key}) : super(key: key);
  late BuildContext _context;
  late UserViewModel _userViewModel;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _userViewModel = Provider.of<UserViewModel>(_context);
    return Scaffold(
      backgroundColor: Theme.of(_context).scaffoldBackgroundColor,
      body: Center(
        child: TextButton(
          onPressed: () async {
            await _userViewModel.doLogout() ?
            {
              Navigator.pushNamedAndRemoveUntil(_context, "/loginScreen", (route) => false)
            }
                :
            ScaffoldMessenger.of(_context).showSnackBar(
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
