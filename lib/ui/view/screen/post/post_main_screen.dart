import 'package:blur/blur.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_detail_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/post/post_edit_screen.dart';
import 'package:couple_seflie_app/ui/view/screen/register3/register_couple_code_screen.dart';
import 'package:couple_seflie_app/ui/view_model/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../ui_setting.dart';
import '../../../view_model/daily_couple_post_view_model.dart';
import '../../../view_model/register3_view_model.dart';
import '../../widget/loading_widget.dart';
import '../../widget/main_drawer_widget.dart';
import '../../widget/post/post_appbar_widget.dart';
import '../../widget/post/post_daily_info_widget.dart';

class PostMainScreen extends StatelessWidget {
  PostMainScreen({Key? key}) : super(key: key);
  late DailyCouplePostViewModel _dailyCouplePostViewModel;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _dailyCouplePostViewModel = Provider.of<DailyCouplePostViewModel>(context);


    return RefreshIndicator(
      onRefresh: () => _dailyCouplePostViewModel.refreshTodayCouplePost(),
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          key: _scaffoldKey,
          drawer: MainDrawerWidget(),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Container(),
                    PostMainScreenAppbar(scaffoldKey: _scaffoldKey),
                    PostDailyInfoWidget(),
                    SizedBox(
                      width: FULL_WIDTH.w,
                      height: (FULL_WIDTH * 2 + 30).w,
                      child: PageView.builder(
                          reverse: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: _dailyCouplePostViewModel.dailyCouplePosts.length,
                          onPageChanged: (index) {
                            if(index == _dailyCouplePostViewModel.dailyCouplePosts.length - 1) {
                              _dailyCouplePostViewModel.loadCouplePosts();
                              print("인덱스 끝");
                            }
                            _dailyCouplePostViewModel.setDailyInfo(index);
                          },
                          controller: PageController(initialPage: _dailyCouplePostViewModel.index??0),
                          itemBuilder: (context, index) {
                            print("itemBuilder" + index.toString());
                            return Column(
                              children: <Widget>[
                                UserDailyPostWidget(index: index),
                                Container(height: 30.w),
                                PartnerDailyPostWidget(index: index),
                              ],
                            );
                          }
                      ),
                    ),
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageButtonWidget extends StatelessWidget {
  final int postId;
  final String postImageUrl;
  const ImageButtonWidget({Key? key, required this.postId, required this.postImageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: null,
      onTap: () async {
        final PostViewModel _postViewModel = Provider.of<PostViewModel>(context, listen: false);
        await _postViewModel.getPost(postId);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostDetailScreen())
        );
      },
      child: CachedNetworkImageWidget(
          imageUrl: postImageUrl,
          width: MAIN_SPACE_WIDTH.w,
          height: MAIN_SPACE_WIDTH.w * IMAGE_RATIO
      ),
    );
  }
}

class DailyPostWidgetFrame extends StatelessWidget {
  final Widget widget;
  const DailyPostWidgetFrame({Key? key, required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MAIN_SPACE_WIDTH.w * IMAGE_RATIO,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                width: 1.w,
                color: Color(0xFF000000)
            ),
            bottom: BorderSide(
                width: 1.w,
                color: Color(0xFF000000)
            ),
          ),
        ),
        alignment: Alignment.center,
        child: widget
    );
  }
}

class UserDailyPostWidget extends StatelessWidget {
  final int index;
  const UserDailyPostWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DailyCouplePostViewModel _dailyCouplePostViewModel = Provider.of<DailyCouplePostViewModel>(context);
    print("user 반복되는 중");
    return DailyPostWidgetFrame(
      widget: _dailyCouplePostViewModel.dailyCouplePosts[index].isUserDone! ?
      // Image of posted image by user
      Row(
        children: <Widget>[
          ImageButtonWidget(postId: _dailyCouplePostViewModel.dailyCouplePosts[index].userPostId!, postImageUrl: _dailyCouplePostViewModel.dailyCouplePosts[index].userPostImageUrl!,),
          Container(
            width: (EMPTY_SPACE_WIDTH + 1).w,
          ),
        ],
      )
          :
      // No post in that day
      Container(
        child: _dailyCouplePostViewModel.dailyCouplePosts[index].isToday! ?
        // If today
        // Provide image button to upload today's post
        EmptyPostButton(
          mainText: '내 답변 사진찍기',
          subText: '아직 답변을 하지 않았어요\n얼른 답변을 찍어보세요',
          iconImagePath: 'images/icons/icon_edit.svg',
          onTap: () async {
            FocusScope.of(context).unfocus();
            final PostViewModel _postViewModel = Provider.of<PostViewModel>(context, listen: false);
            await _postViewModel.setEmptyPost();
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostEditScreen())
            );
          },
        )
            :
        // Otherwise
        /// Inform that user didn't answer
        EmptyPostButton(
            iconImagePath: "images/icons/icon_empty.svg",
            mainText: "사진이 없습니다",
            subText: "답변을 하지 않았어요\n앞으로는 꾸준히 답변해보세요"
        ),
      ),
    );
  }
}


class PartnerDailyPostWidget extends StatelessWidget {
  final int index;
  const PartnerDailyPostWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DailyCouplePostViewModel _dailyCouplePostViewModel = Provider.of<DailyCouplePostViewModel>(context);
    print("partner 반복되는 중");
   return DailyPostWidgetFrame(
       widget: _dailyCouplePostViewModel.isCouple ?
       _dailyCouplePostViewModel.dailyCouplePosts[index].isUserDone! ?
       // user : true
       Container(
           child: _dailyCouplePostViewModel.dailyCouplePosts[index].isPartnerDone! ?
           // user : true, partner : true
           /// Image that partner posted
           Row(
             children: <Widget>[
               Container(
                 width: (EMPTY_SPACE_WIDTH + 1).w,
               ),
               ImageButtonWidget(
                   postId: _dailyCouplePostViewModel.dailyCouplePosts[index].partnerPostId!,
                   postImageUrl: _dailyCouplePostViewModel.dailyCouplePosts[index].partnerPostImageUrl!
               )
             ],
           )
               :
           // user : true, partner : false
           Container(
             child: _dailyCouplePostViewModel.dailyCouplePosts[index].isToday! ?
             // today - user : true, partner : false
             /// Provide function to alert partner to answer
             EmptyPostButton(
               iconImagePath: "images/icons/icon_notification.svg",
               mainText: "답변 푸쉬하기",
               subText: "아직 답변을 하지 않았어요\n답변을 요청해보세요",
               onTap: () {
                 // temp
                 // 답변 푸시 기능
               },
             )
                 :
             // Other days - user : true, partner : false
             /// Inform that partner didn't answer
             EmptyPostButton(
               iconImagePath: "images/icons/icon_empty.svg",
               mainText: "사진이 없습니다",
               subText: "상대가 답변을 하지 않았어요\n다음 날을 기대해봐요",
             ),
           )
       )
           :
       // user : false
       Container(
         child: _dailyCouplePostViewModel.dailyCouplePosts[index].isPartnerDone! ?
         // user : false, partner : true
          _dailyCouplePostViewModel.dailyCouplePosts[index].isToday! ?
         // today - user : false, partner : true
         /// Show as blurred image
         CachedNetworkImageWidget(
           imageUrl: _dailyCouplePostViewModel.dailyCouplePosts[index].partnerPostImageUrl!,
           width: MAIN_SPACE_WIDTH.w,
           height: MAIN_SPACE_WIDTH.w * IMAGE_RATIO,
           boxFit: BoxFit.cover,
         ).blurred(
             colorOpacity: 0.5,
             blur: 30,
             overlay: EmptyPostButton(
               iconImagePath: "images/icons/icon_checked.svg",
               mainText: "답변 완료",
               subText: "상대방은 답변을 완료했어요\n얼른 답변하고 확인해보세요",
             )
         )
             :
         // other days - user : false, partner : true
         /// otherwise : original image
         Row(
           children: <Widget>[
             Container(
               width: (EMPTY_SPACE_WIDTH + 1).w,
             ),
             ImageButtonWidget(
                 postId: _dailyCouplePostViewModel.dailyCouplePosts[index].partnerPostId!,
                 postImageUrl: _dailyCouplePostViewModel.dailyCouplePosts[index].partnerPostImageUrl!
             )
           ],
         )
             :
         // user : false, partner : false
         /// Just inform that partner didn't answer
         EmptyPostButton(
             iconImagePath: "images/icons/icon_waiting.svg",
             mainText: "답변을 기다려요",
             subText: "아직 답변을 하지 않았어요\n나의 답변을 작성하고 상대방에게 답변을 요청해봐요."
         ),
       )
           :
       EmptyPostButton(
         iconImagePath: "images/icons/icon_notification.svg",
         mainText: "상대방 등록하기",
         subText: "등록된 상대방이 없어요\n상대방을 등록 후에 같이 즐겨봐요",
         onTap: () async {
           print("등록");
           await Provider.of<Register3ViewModel>(context, listen: false).setUserCoupleCode();
           Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => RegisterCoupleCodeScreen(), fullscreenDialog: true),
           );
         },
       )
   );
  }
}


class EmptyPostButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final String iconImagePath;
  final String mainText;
  final String subText;
  const EmptyPostButton({Key? key, this.onTap, required this.iconImagePath, required this.mainText, required this.subText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        child: Container(
          //height: 150.w,
          //width: 150.w,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                iconImagePath,
                width: 24.w,
                height: 24.w,
                fit: BoxFit.contain,
              ),
              Text(
                mainText,
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 14.w,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                subText,
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 10.w,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}