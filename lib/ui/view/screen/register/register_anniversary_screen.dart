import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../view_model/register_view_model.dart';

class RegisterAnniversaryScreen extends StatelessWidget {
  RegisterAnniversaryScreen({Key? key}) : super(key: key);
  late RegisterViewModel _registerViewModel;
  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _registerViewModel = Provider.of<RegisterViewModel>(context);
    return Container(
        child: GestureDetector(
          onTap: (){
            FocusScope.of(_context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(_context).scaffoldBackgroundColor,
              elevation: 0,
              leading: Container(),
              actions: <Widget>[
                InkWell(
                  onTap: (){
                    _registerViewModel.clear();
                    FocusScope.of(_context).unfocus();
                    Navigator.popUntil(_context, ModalRoute.withName("/loginScreen"));
                  },
                  child: SizedBox(
                    width: 50.w,
                    child: Icon(
                      Icons.clear,
                      color: Color(0xFF000000),
                    ),
                  ),
                )
              ],
            ),
            backgroundColor: Theme.of(_context).scaffoldBackgroundColor,
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(),
                  Container(
                    padding: EdgeInsetsDirectional.fromSTEB(35.w, 20.w, 35.w, 20.w),
                    child: Column(
                      children: <Widget>[
                        topWidget(),
                        Padding(padding: EdgeInsets.symmetric(vertical: 20.w)),
                        registerWidget(),
                      ],
                    ),
                  ),
                  routeButtonWidget()
                ],
              ),
            ),
          ),
        )
    );
  }

  /// route Button
  Widget routeButtonWidget() {
    return Container(
      width: 390.w,
      height: 60.w,
      alignment: Alignment.centerRight,
      padding: EdgeInsetsDirectional.fromSTEB(25.w, 0, 25.w, 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: (){
              FocusScope.of(_context).unfocus();
              Navigator.pop(_context);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28.w),
                  border: Border.all(
                    width: 2.w,
                    color: Color(0xFF050505),
                  )
              ),
              width: 90.w,
              height: 48.w,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10.w),
              child: Container(
                width: 60.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.chevron_left_outlined, size: 30.w, color: Color(0xFF050505),),
                    Text(
                      "이전",
                      style: TextStyle(
                          fontSize: 16.w,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF050505)
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              FocusScope.of(_context).unfocus();
              _registerViewModel.isAnniversaryOk ?
              Navigator.pushNamed(_context, "/registerPartnerScreen")
                  :
              ScaffoldMessenger.of(_context).showSnackBar(
                SnackBar(
                  content: Text('날짜를 올바르게 선택해주세요'),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28.w),
                  border: Border.all(
                    width: 2.w,
                    color: Color(0xFF050505),
                  )
              ),
              width: 90.w,
              height: 48.w,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 10.w),
              child: Container(
                width: 60.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "다음",
                      style: TextStyle(
                          fontSize: 16.w,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF050505)
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Icon(Icons.chevron_right_outlined, size: 30.w, color: Color(0xFF050505),)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// page Info
  Widget topWidget() {
    return Container(
      width: 320.w,
      height: 150.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "서로의\n특별한 날을\n기록해주세요",
            style: TextStyle(
                fontSize: 28.w,
                fontWeight: FontWeight.w700,
                color: Color(0xFF000000)
            ),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "가장 특별한 하루를 정해주세요",
            style: TextStyle(
                fontSize: 16.w,
                fontWeight: FontWeight.w400,
                color: Color(0xFF000000).withOpacity(0.5)
            ),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget registerWidget() {
    return Container(
      width: 320.w,
      height: 150.w,
      alignment: Alignment.center,
      child: CupertinoDatePicker(
        minimumYear: 1950,
        maximumYear: DateTime.now().year,
        initialDateTime: DateTime.now(),
        maximumDate: DateTime.now(),
        onDateTimeChanged: (DateTime value) {
          _registerViewModel.setAnniversary(value);
        },
        mode: CupertinoDatePickerMode.date,
      )
    );
  }
}

