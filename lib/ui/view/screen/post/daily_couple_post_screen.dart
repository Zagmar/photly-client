import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_seflie_app/ui/view_model/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../ui_setting.dart';
import '../../../view_model/daily_couple_post_view_model.dart';
import '../../widget/main_drawer_widget.dart';
import '../../widget/post/post_appbar_widget.dart';
import '../../widget/post/post_daily_info_widget.dart';


class DailyCouplePostScreen extends StatelessWidget {
  DailyCouplePostScreen({Key? key}) : super(key: key);
  late DailyCouplePostViewModel _dailyCouplePostViewModel;
  late BuildContext _context;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _context = context;
    _dailyCouplePostViewModel = Provider.of<DailyCouplePostViewModel>(_context);
    _dailyCouplePostViewModel.setScreenToMain();
    return ChangeNotifierProvider(
      create: (_) => DailyCouplePostViewModel(),
      child: postMainWidget(),
    );
  }

  /// Main structure
  Widget postMainWidget() {
    return GestureDetector(
      onTap: (){
        FocusScope.of(_context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: mainDrawerWidget(_context),
        backgroundColor: Theme.of(_context).scaffoldBackgroundColor,
        body: Container(
          child: _dailyCouplePostViewModel.dailyCouplePosts.isEmpty || _dailyCouplePostViewModel.loading ?
          // Show loading indicator when is loading
          Center(
            child: SizedBox(
                width: 30.w,
                height: 30.w,
                child: CircularProgressIndicator()
            ),
          )
              :
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  postAppBarWidget(_context, _scaffoldKey),
                  postDailyInfoWidget(_context),
                  postsWidget()
                ]
            ),
          ),
        ),
      ),
    );
  }

  Widget postsWidget() {
    return SizedBox(
      width: 390.w,
      height: 490.w,
      child: PageView.builder(
          onPageChanged:(index){
            _dailyCouplePostViewModel.setPage(index);
          },
          reverse: true,
          scrollDirection: Axis.horizontal,
          // controller: PageController(initialPage: 1),
          itemCount: _dailyCouplePostViewModel.dailyCouplePosts.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                dailyMyPostWidget(),
                Container(
                  height: 30.w,
                ),
                dailyPartnerPostWidget(),
              ],
            );
          }
      ),
    );
  }

  /// Split ratio
  /// 295 : 1 : 94

  /// My Daily Post
  Widget dailyMyPostWidget() {
    return Container(
      height: 220.w,
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
      child: _dailyCouplePostViewModel.userPostId != null ?
      /// Image that user posted
      Row(
        children: <Widget>[
          InkWell(
            onTap: () async {
              // temp
              PostViewModel _postViewModel = Provider.of<PostViewModel>(_context, listen: false);
              _postViewModel.getPost(_dailyCouplePostViewModel.userPostId!);
              print("1통과");
              Navigator.pushNamed(_context, "/postDetailScreen");
              print("2통과");
            },
            child: Container(
              width: 295.w,
              height: 295.w * IMAGE_RATIO,
              child: CachedNetworkImage(
                imageUrl: _dailyCouplePostViewModel.userPostImageUrl!,
                width: 295.w,
                height: 295.w * IMAGE_RATIO,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                      child: SizedBox(
                          width: 30.w,
                          height: 30.w,
                          child: CircularProgressIndicator(value: downloadProgress.progress)
                      ),
                    ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline_outlined),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: 95.w,
          ),
        ],
      )
          :
      // No post in that day
      _dailyCouplePostViewModel.isToday ?
      // If today
      /// Link to upload today's post
      InkWell(
        onTap: (){
          FocusScope.of(_context).unfocus();
          if(_dailyCouplePostViewModel.userPostId != null){
            PostViewModel _postViewModel = Provider.of<PostViewModel>(_context, listen: false);
            _postViewModel.getPost(_dailyCouplePostViewModel.userPostId!);
          }
          Navigator.pushNamed(_context, '/postEditScreen');
        },
        child: Container(
          height: 80.w,
          width: 120.w,
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 24.w,
                width: 24.w,
                child: Icon(
                  Icons.edit,
                ),
              ),
              Text(
                "내 답변 사진찍기",
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 14.w,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "아직 답변을 하지 않았어요\n얼른 답변을 찍어보세요",
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
      )
          :
      // Otherwise
      /// Inform that user didn't answer
      Container(
        height: 80.w,
        width: 120.w,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 24.w,
              width: 24.w,
              child: Icon(
                Icons.image_not_supported_outlined,
              ),
            ),
            Text(
              "사진이 없습니다",
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 14.w,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "답변을 하지 않았어요\n앞으로는 꾸준히 답변해보세요",
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
    );
  }

  /// Partner's Daily Post
  Widget dailyPartnerPostWidget() {
    return Container(
      height: 220.w,
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
      child: _dailyCouplePostViewModel.userPostId == null  ?
      Container(
        child: _dailyCouplePostViewModel.partnerPostId == null  ?
        // user : false, partner : false
        /// Just inform that partner didn't answer
        Container(
            height: 80.w,
            width: 220.w,
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 24.w,
                  width: 24.w,
                  child: Icon(
                    Icons.hourglass_bottom_outlined,
                  ),
                ),
                Text(
                  "답변을 기다려요",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 14.w,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "아직 답변을 하지 않았어요\n나의 답변을 작성하고 상대방에게 답변을 요청해봐요.",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 10.w,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
            :
        // user : false, partner : true
        _dailyCouplePostViewModel.isToday ?
        // today
        /// Show as blurred image
        Container(
            height: 220.w,
            width: 390.w,
            alignment: Alignment.center,
            child: CachedNetworkImage(
              imageUrl: _dailyCouplePostViewModel.partnerPostImageUrl!,
              height: 220.w,
              width: 390.w,
              progressIndicatorBuilder: (_context, url, downloadProgress) =>
                  Center(
                    child: SizedBox(
                        width: 30.w,
                        height: 30.w,
                        child: CircularProgressIndicator(value: downloadProgress.progress)
                    ),
                  ),
              errorWidget: (_context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ).blurred(
              colorOpacity: 0.5,
              blur: 30,
              overlay: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 24.w,
                    width: 24.w,
                    child: Icon(
                      Icons.check_circle_outline,
                    ),
                  ),
                  Text(
                    "답변 완료",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 14.w,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "상대방은 답변을 완료했어요\n얼른 답변하고 확인해보세요",
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
          )
            :
        // other days
        /// otherwise : original image
        Row(
          children: <Widget>[
            Container(
              width: 95.w,
            ),
            InkWell(
              child: Container(
                width: 295.w,
                height: 295.w * IMAGE_RATIO,
                child: CachedNetworkImage(
                  imageUrl: _dailyCouplePostViewModel.partnerPostImageUrl!,
                  width: 295.w,
                  height: 295.w * IMAGE_RATIO,
                  progressIndicatorBuilder: (_context, url, downloadProgress) =>
                      Center(
                        child: SizedBox(
                            width: 30.w,
                            height: 30.w,
                            child: CircularProgressIndicator(value: downloadProgress.progress)
                        ),
                      ),
                  errorWidget: (_context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
              onTap: () async {
                PostViewModel _postViewModel = Provider.of<PostViewModel>(_context, listen: false);
                _postViewModel.getPost(_dailyCouplePostViewModel.partnerPostId!);
                Navigator.pushNamed(_context, "/postDetailScreen");
              },
            ),
          ],
        ),
      )
          :
      Container(
        child: _dailyCouplePostViewModel.partnerPostId == null  ?
        // user : true, partner : false
        /// Partner doesn't answer
        Container(
          height: 80.w,
          width: 120.w,
          alignment: Alignment.center,
          child: _dailyCouplePostViewModel.isToday ?
          // today
          /// Provide function to alert partner to answer
          InkWell(
            onTap: (){
              // temp
              // 푸시하기 기능
            },
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 24.w,
                  width: 24.w,
                  child: Icon(
                    Icons.notifications_outlined,
                  ),
                ),
                Text(
                  "답변 푸쉬하기",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 14.w,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "아직 답변을 하지 않았어요\n답변을 요청해보세요",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 10.w,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
              :
          // Other days
          /// Inform that partner didn't answer
          Column(
            children: <Widget>[
              SizedBox(
                height: 24.w,
                width: 24.w,
                child: Icon(
                  Icons.warning_amber_outlined,
                ),
              ),
              Text(
                "슬퍼요",
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 14.w,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "상대가 답변을 하지 않았어요\n다음 날을 기대해봐요",
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 10.w,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        )
            :
        // user : true, partner : true
        /// Image that partner posted
        Row(
          children: <Widget>[
            Container(
              width: 95.w,
            ),
            InkWell(
              onTap: () async {
                PostViewModel _postViewModel = Provider.of<PostViewModel>(_context, listen: false);
                _postViewModel.getPost(_dailyCouplePostViewModel.partnerPostId!);
                Navigator.pushNamed(_context, "/postDetailScreen");
              },
              child: Container(
                width: 295.w,
                height: 295.w * IMAGE_RATIO,
                child: CachedNetworkImage(
                  imageUrl: _dailyCouplePostViewModel.partnerPostImageUrl!,
                  width: 295.w,
                  height: 295.w * IMAGE_RATIO,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                        child: SizedBox(
                            width: 30.w,
                            height: 30.w,
                            child: CircularProgressIndicator(value: downloadProgress.progress)
                        ),
                      ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        )
      )
    );
  }
}
