import 'package:couple_seflie_app/ui/view/screen/post/post_main_screen.dart';
import 'package:couple_seflie_app/ui/view_model/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../ui_setting.dart';

// Custom Appbars for post screens

class PostAppbarModel extends StatelessWidget {
  final Widget? leadButton;
  final Widget? actionButton;
  const PostAppbarModel({Key? key, this.leadButton, this.actionButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: 58.w,
      child: Row(
        children: <Widget>[
          Container(
              padding: EdgeInsetsDirectional.fromSTEB(20.w, 10.w, 20.w, 0),
              width: MAIN_SPACE_WIDTH.w,
              alignment: Alignment.centerLeft,
              child: leadButton
          ),
          Container(
            color: Color(0xFF000000),
            width: BORDER_WIDTH.w,
          ),
          Container(
            width: EMPTY_SPACE_WIDTH.w,
            alignment: Alignment.center,
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
  final GestureTapCallback onTap;
  const PostScreensAppbar({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PostAppbarModel(
      actionButton: SingleButton(
        icon: Icons.clear,
        onTap: onTap,
      ),
    );
  }
}

class ManageAccountScreenAppbar extends StatelessWidget {
  final GestureTapCallback onTap;
  const ManageAccountScreenAppbar({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PostAppbarModel(
      actionButton: SingleButton(
        icon: Icons.clear,
        onTap: onTap,
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
      splashColor: Colors.transparent,
      child: SizedBox(
        height: 48.w,
        width: 48.w,
        child: Icon(
          icon,
          color: Color(0xFF000000),
          size: 30.w,
        ),
      ),
      onTap: onTap,
    );
  }
}