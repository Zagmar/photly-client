import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Custom Appbars for post screens

class PostAppbarModel extends StatelessWidget {
  final Widget? leadButton;
  final Widget? actionButton;
  const PostAppbarModel({Key? key, this.leadButton, this.actionButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390.w,
      height: 90.w,
      padding: EdgeInsets.only(left: 20.w),
      child: Row(
        children: <Widget>[
          Container(
            width: 275.w,
            alignment: Alignment.centerLeft,
            child: leadButton
          ),
          Container(
            color: Color(0xFF000000),
            width: 1.w,
          ),
          Container(
            width: 94.w,
            child: actionButton
          ),
        ],
      ),
    );
  }
}

class PostMainScreenAppbar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const PostMainScreenAppbar({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("postAppbar 실행");

    return PostAppbarModel(
      leadButton: SingleButton(
        icon: Icons.menu,
        onTap: () {
          FocusScope.of(scaffoldKey.currentContext!).unfocus();
          scaffoldKey.currentState?.openDrawer();
        },
      ),
    );
  }
}

class PostScreensAppbar extends StatelessWidget {
  const PostScreensAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PostAppbarModel(
      actionButton: SingleButton(
        icon: Icons.clear,
        onTap: () {
          Navigator.of(context).pop((route) => PostMainScreen());
        },
      ),
    );
  }
}

class SingleButton extends StatelessWidget {
  final IconData icon;
  final GestureTapCallback onTap;
  const SingleButton({Key? key, required this.icon, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
        height: 50.w,
        width: 50.w,
        child: Icon(
          icon,
          color: Color(0xFF667080),
          size: 30.w,
        ),
      ),
      onTap: onTap,
    );
  }
}