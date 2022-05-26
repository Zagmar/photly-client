import 'package:flutter/material.dart';
import '../../widget/route_button_widgets.dart';

class FindPwScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(),
              Text(
                  "관리자 문의 요망"
              ),
              LeftButtonOnlyWidget(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Navigator.pop(context);
                },
                buttonText: "이전",
              )
            ],
          ),
        ),
      ),
    );
  }
}